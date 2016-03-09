//
//  MKMapView+Separation.m
//  TKProgress
//
//  Created by Tom Knapen on 02/03/16.
//  Copyright © 2016 Appwise. All rights reserved.
//

#import "MKMapView+Separation.h"
#import "TKMapViewDelegator.h"

#import <objc/runtime.h>

@implementation MKMapView (Separation)

-(TKMapViewDelegator *)tkDelegator {
	TKMapViewDelegator *delegator = objc_getAssociatedObject(self, @selector(tkDelegator));
	if(!delegator) {
		delegator = [TKMapViewDelegator delegatorForMapView:self];
		objc_setAssociatedObject(self, @selector(tkDelegator), delegator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return delegator;
}

-(id<TKMapViewDelegate>)tkDelegate {
	TKMapViewDelegator *delegator = [self tkDelegator];
	return delegator.delegate;
}

-(void)setTkDelegate:(id<TKMapViewDelegate>)tkDelegate {
	TKMapViewDelegator *delegator = [self tkDelegator];
	delegator.delegate = tkDelegate;
}

-(id<TKMapViewDataSource>)tkDataSource {
	TKMapViewDelegator *delegator = [self tkDelegator];
	return delegator.dataSource;
}

-(void)setTkDataSource:(id<TKMapViewDataSource>)tkDataSource {
	TKMapViewDelegator *delegator = [self tkDelegator];
	delegator.dataSource = tkDataSource;
}

-(void)reloadAnnotations {
	TKMapViewDelegator *delegator = [self tkDelegator];
	[delegator reloadData];
}

@end
