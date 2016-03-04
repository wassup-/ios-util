//
//  TKMapViewDelegator.h
//  TKProgress
//
//  Created by Tom Knapen on 02/03/16.
//  Copyright © 2016 Appwise. All rights reserved.
//

#import "TKMapViewDelegate.h"
#import "TKMapViewDataSource.h"

@import MapKit;

@interface TKMapViewDelegator : NSObject<MKMapViewDelegate>

@property (nonatomic, weak) MKMapView *mapView;

@property (nonatomic, weak) id<MKMapViewDelegate> passthroughDelegate;
@property (nonatomic, weak) id<TKMapViewDelegate> delegate;
@property (nonatomic, weak) id<TKMapViewDataSource> dataSource;

-(void)reloadData;

+(instancetype)delegatorForMapView:(MKMapView *)mapView;

@end
