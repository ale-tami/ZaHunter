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

@interface ViewController ()<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property CLLocationManager *locationManager;
@property CLLocation *ourLocation;
@property NSArray *nearPizzaPlaces;

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
}

- (void) searchForPizzas
{
    MKLocalSearchRequest *searchRequest = [MKLocalSearchRequest new];
    searchRequest.naturalLanguageQuery = @"pizza";
    searchRequest.region = MKCoordinateRegionMake(self.ourLocation.coordinate, MKCoordinateSpanMake(1, 1));
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        self.nearPizzaPlaces = response.mapItems;
        [self.tableView reloadData];
        
    }];
    
}

#pragma mark UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    Pizzeria *mapItem = [self.nearPizzaPlaces objectAtIndex:indexPath.row];
    
    cell.textLabel.text = mapItem.placemark.name;
    cell.detailTextLabel.text = mapItem.placemark.thoroughfare;
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nearPizzaPlaces.count;
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
