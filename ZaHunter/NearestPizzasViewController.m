//
//  NearestPizzasViewController.m
//  ZaHunter
//
//  Created by Alejandro Tami on 06/08/14.
//  Copyright (c) 2014 Alejandro Tami. All rights reserved.
//

#import "NearestPizzasViewController.h"
#import  <MapKit/MapKit.h>
#import "Pizzeria.h"
#import "ViewController.h"

@interface NearestPizzasViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;



@end

@implementation NearestPizzasViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//Chicago Coordinates = CLLocationCoordinate2DMake(41.88322, -87.63243);
    
//    MKCoordinateRegion region;
//    region.center.latitude = 41.88322;
//    region.center.longitude = -87.63243;
//    region.span.latitudeDelta =  1;
//    region.span.longitudeDelta =  1;
//    
//    [self.map setRegion:region animated:YES];
    
    for (MKMapItem *pizza in self.items) {
        [self.map addAnnotation:pizza.placemark];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    ViewController *vc = [[self.tabBarController viewControllers]objectAtIndex:0];
    
    self.items = vc.fourNearest;
    
    for (MKMapItem *pizza in self.items) {
        [self.map addAnnotation:pizza.placemark];
    }
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation != self.map.userLocation) {
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
        pin.image = [UIImage imageNamed:@"pizza"];
        
        return pin;

    }
    
    return nil;
}


@end
