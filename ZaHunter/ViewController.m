//
//  ViewController.m
//  ZaHunter
//
//  Created by Alejandro Tami on 06/08/14.
//  Copyright (c) 2014 Alejandro Tami. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Pizzeria.h"
#import "NearestPizzasViewController.h"

@interface ViewController ()<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property CLLocationManager *locationManager;
@property CLLocation *ourLocation;
@property NSArray *nearPizzaPlaces;

@property float timeEatRampage;

@end

//-27.791588, -64.249637

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    self.nearPizzaPlaces = [NSArray new];
    self.fourNearest = [[NSMutableArray alloc]initWithCapacity:4];
    [self.fourNearest insertObject:[MKMapItem new] atIndex:0];
    [self.fourNearest insertObject:[MKMapItem new]  atIndex:1];
    [self.fourNearest insertObject:[MKMapItem new]  atIndex:2];
    [self.fourNearest insertObject:[MKMapItem new]  atIndex:3];
    
    self.timeEatRampage = 0.0;
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:YES];
    
    NearestPizzasViewController *npvc = [[self.tabBarController viewControllers]objectAtIndex:1];
    
    npvc.items = self.fourNearest;
    
}


- (void) searchForPizzas
{
    
    MKLocalSearchRequest *searchRequest = [MKLocalSearchRequest new];
    searchRequest.naturalLanguageQuery = @"pizza";
    searchRequest.region = MKCoordinateRegionMake(self.ourLocation.coordinate, MKCoordinateSpanMake(1, 1));
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
         self.nearPizzaPlaces = response.mapItems;
        
        
        for (Pizzeria *item in response.mapItems) {
   
            MKDirectionsRequest *request = [MKDirectionsRequest new];
            
            request.source = [MKMapItem mapItemForCurrentLocation];
            request.destination = item;
            request.transportType = MKDirectionsTransportTypeWalking;
            
            MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
            
            [directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error) {
                
                NSLog(@"%f",response.expectedTravelTime);
                
                self.timeEatRampage += (response.expectedTravelTime / 60)+50;
                
                [self.tableView reloadData]; //where else could I put this line

            }];
        
        }
        
    }];
    
}

#pragma mark UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    Pizzeria *mapItem = [self.nearPizzaPlaces objectAtIndex:indexPath.row];
    
    float kmToPizza = [mapItem.placemark.location distanceFromLocation: self.ourLocation]/1000.0;
    
    if (kmToPizza <= 10) {
        cell.backgroundColor = [UIColor greenColor];
        //sorry for this, it's late and I wnt to finish
        
        if ([((Pizzeria*)[self.fourNearest objectAtIndex:0]).placemark.location distanceFromLocation:self.ourLocation] < kmToPizza) {
            [self.fourNearest replaceObjectAtIndex:0 withObject:mapItem];
        } else if ([((Pizzeria*)[self.fourNearest objectAtIndex:1]).placemark.location distanceFromLocation:self.ourLocation]< kmToPizza) {
            [self.fourNearest replaceObjectAtIndex:1 withObject:mapItem];
        } else if ([((Pizzeria*)[self.fourNearest objectAtIndex:2]).placemark.location distanceFromLocation:self.ourLocation]< kmToPizza) {
            [self.fourNearest replaceObjectAtIndex:2 withObject:mapItem];
        } else if ([((Pizzeria*)[self.fourNearest objectAtIndex:3]).placemark.location distanceFromLocation:self.ourLocation]< kmToPizza) {
            [self.fourNearest replaceObjectAtIndex:3 withObject:mapItem];
        }
        
        
    }
    
    cell.textLabel.text = mapItem.name;  
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %fkm",mapItem.placemark.thoroughfare, kmToPizza];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nearPizzaPlaces.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Fat bastard in %f minutes", self.timeEatRampage ];
}

#pragma mark CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
//    CLGeocoder *geocoder = [CLGeocoder new];
//    
//    [geocoder reverseGeocodeLocation: [locations firstObject] completionHandler:^(NSArray *placemarks, NSError *error) {
//        <#code#>
//    }];
    
    self.ourLocation = locations.firstObject;
    [self.locationManager stopUpdatingLocation];

    [self searchForPizzas];
    
    
}



@end
