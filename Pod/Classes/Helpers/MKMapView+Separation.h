//
//  MKMapView+Separation.h
//  TKProgress
//
//  Created by Tom Knapen on 02/03/16.
//  Copyright © 2016 Appwise. All rights reserved.
//

#import "TKMapViewDataSource.h"
#import "TKMapViewDelegate.h"

@import MapKit;

@interface MKMapView (Separation)

@property (nonatomic, weak) id<TKMapViewDelegate> tkDelegate;
@property (nonatomic, weak) id<TKMapViewDataSource> tkDataSource;

-(void)reloadAnnotations;

@end
