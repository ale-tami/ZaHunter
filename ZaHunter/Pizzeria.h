//
//  Pizzeria.h
//  ZaHunter
//
//  Created by Alejandro Tami on 06/08/14.
//  Copyright (c) 2014 Alejandro Tami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Pizzeria : MKMapItem

@property MKRoute *routeToPizza;
@property int distance;


@end
