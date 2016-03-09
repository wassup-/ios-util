//
//  TKMapViewDelegator.m
//  iOS-util
//
//  Created by Tom Knapen on 02/03/16.
//  Copyright © 2016 Appwise. All rights reserved.
//

#import "TKMapViewDelegator.h"
#import "TKAnnotationWrapper.h"

@import LBDelegateMatrioska;

@interface TKMapViewDelegator ()

@property (nonatomic, strong) LBDelegateMatrioska *delegateProxy;

@end

@implementation TKMapViewDelegator

#pragma mark - Creators

+(instancetype)delegatorForMapView:(MKMapView *)mapView {
	TKMapViewDelegator *instance = [self new];
	instance.mapView = mapView;
	mapView.delegate = instance.delegateProxy;
	return instance;
}

#pragma mark -

-(void)configureWithAnnotations:(NSArray<TKAnnotationWrapper *> *)annotations {
	[self.mapView removeAnnotations:self.mapView.annotations];
	[self.mapView addAnnotations:annotations];
}

-(void)reloadData {
	const NSInteger annotationCount = [self.dataSource numberOfAnnotationsForMapView:self.mapView];
	NSMutableArray<TKAnnotationWrapper *> *annotations = [NSMutableArray arrayWithCapacity:annotationCount];
	for(NSInteger i = 0; i < annotationCount; ++i) {
		NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:i];
		id data = [self.dataSource mapView:self.mapView dataForAnnotationAtIndexPath:indexPath];
		id<MKAnnotation> original = [self.dataSource mapView: self.mapView
									   annotationAtIndexPath: indexPath
													withData: data];
		[annotations addObject:[TKAnnotationWrapper wrap: original
											 atIndexPath: indexPath
												withData: data]];
	}

	[self configureWithAnnotations:annotations];
}

#pragma mark - Properties

-(LBDelegateMatrioska *)delegateProxy {
	if(!_delegateProxy) {
		_delegateProxy = [[LBDelegateMatrioska alloc] initWithDelegates:@[self]];
	}
	return _delegateProxy;
}

-(void)setPassthroughDelegate:(id<MKMapViewDelegate>)passthroughDelegate {
	if(_passthroughDelegate) {
		[self.delegateProxy removeDelegate:_passthroughDelegate];
	}

	_passthroughDelegate = passthroughDelegate;

	if(_passthroughDelegate) {
		[self.delegateProxy addDelegate:_passthroughDelegate];
	}
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	// Defaults for when [annotation isKindOfClass:MKUserLocation.class]
	NSIndexPath *indexPath = nil;
	id data = nil;
	id<MKAnnotation> anno = annotation;
	id identifier = nil;
	MKAnnotationView *reuseView = nil;

	if(![annotation isKindOfClass:MKUserLocation.class]) {
		indexPath = [self.class indexPathOf:annotation];
		data = [self.class dataOf:annotation];
		anno = [self.class annotationOf:annotation];

		identifier = [self.dataSource mapView: mapView
			   classOrIdentifierForAnnotation: anno
								  atIndexPath: indexPath
									 withData: data];

		reuseView = ([identifier isKindOfClass:NSString.class]) ? [mapView dequeueReusableAnnotationViewWithIdentifier:identifier] : nil;
	}

	MKAnnotationView *view = [self.dataSource mapView: mapView
									viewForAnnotation: anno
										  atIndexPath: indexPath
											 withData: data
										  reusingView: reuseView];
	[self.dataSource mapView: mapView
			   configureView: view
			   forAnnotation: anno
				 atIndexPath: indexPath
					withData: data];

	return view;
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	NSParameterAssert(view);
	id<MKAnnotation> annotation = view.annotation;
	NSAssert([annotation isKindOfClass:TKAnnotationWrapper.class], @"Unexpected annotation type");

	NSIndexPath *indexPath = [self.class indexPathOf:annotation];
	id data = [self.class dataOf:annotation];
	id<MKAnnotation> anno = [self.class annotationOf:annotation];

	if([self mapView:mapView shouldSelectAnnotation:anno atIndexPath:indexPath withData:data]) {
		[self mapView:mapView didSelectAnnotation:anno atIndexPath:indexPath withData:data];
	}
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	NSParameterAssert(view);
	id<MKAnnotation> annotation = view.annotation;
	NSAssert([annotation isKindOfClass:TKAnnotationWrapper.class], @"Unexpected annotation type");

	NSIndexPath *indexPath = [self.class indexPathOf:annotation];
	id data = [self.class dataOf:annotation];
	id<MKAnnotation> anno = [self.class annotationOf:annotation];

	if([self mapView:mapView shouldDeselectAnnotation:anno atIndexPath:indexPath withData:data]) {
		[self mapView:mapView didDeselectAnnotation:anno atIndexPath:indexPath withData:data];
	}
}

#pragma mark - Passthrough

-(BOOL)mapView:(MKMapView *)mapView shouldSelectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data {
	if([self.delegate respondsToSelector:@selector(mapView:shouldSelectAnnotation:atIndexPath:withData:)]) {
		return [self.delegate mapView:mapView shouldSelectAnnotation:annotation atIndexPath:indexPath withData:data];
	}
	return YES;
}

-(BOOL)mapView:(MKMapView *)mapView shouldDeselectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data {
	if([self.delegate respondsToSelector:@selector(mapView:shouldDeselectAnnotation:atIndexPath:withData:)]) {
		return [self.delegate mapView:mapView shouldDeselectAnnotation:annotation atIndexPath:indexPath withData:data];
	}
	return YES;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data {
	if([self.delegate respondsToSelector:@selector(mapView:didSelectAnnotation:atIndexPath:withData:)]) {
		[self.delegate mapView:mapView didSelectAnnotation:annotation atIndexPath:indexPath withData:data];
	}
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data {
	if([self.delegate respondsToSelector:@selector(mapView:didDeselectAnnotation:atIndexPath:withData:)]) {
		[self.delegate mapView:mapView didDeselectAnnotation:annotation atIndexPath:indexPath withData:data];
	}
}

#pragma mark - Helpers

+(NSIndexPath *)indexPathOf:(TKAnnotationWrapper *)annotation {
	return annotation.indexPath;
}

+(id)dataOf:(TKAnnotationWrapper *)annotation {
	return annotation.data;
}

+(id<MKAnnotation>)annotationOf:(TKAnnotationWrapper *)annotation {
	return annotation.unwrap;
}

@end

@implementation MKMapView (TKDelegate)

-(void)selectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data animated:(BOOL)animated {
	TKAnnotationWrapper *wrapper = nil;
	if(![annotation isKindOfClass:TKAnnotationWrapper.class]) {
		wrapper = [self annotationAtIndexPath:indexPath];
	} else {
		wrapper = annotation;
	}

	[self selectAnnotation:wrapper animated:animated];
}

-(void)deselectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data animated:(BOOL)animated {
	TKAnnotationWrapper *wrapper = nil;
	if(![annotation isKindOfClass:TKAnnotationWrapper.class]) {
		wrapper = [self annotationAtIndexPath:indexPath];
	} else {
		wrapper = annotation;
	}

	[self deselectAnnotation:wrapper animated:animated];
}

@end
