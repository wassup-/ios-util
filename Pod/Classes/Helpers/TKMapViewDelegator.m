//
//  TKMapViewDelegator.m
//  TKProgress
//
//  Created by Tom Knapen on 02/03/16.
//  Copyright © 2016 Appwise. All rights reserved.
//

#import "TKMapViewDelegator.h"
#import "TKAnnotationWrapper.h"

#ifndef weakify

#define weakify(var) \
autoreleasepool{} \
__weak typeof(var) var ## _weak__ = var

#endif

#ifndef strongify

#define strongify(var) \
autoreleasepool{} \
__strong typeof(var) var = var ## _weak__

#endif

@implementation TKMapViewDelegator

+(instancetype)delegatorForMapView:(MKMapView *)mapView {
	TKMapViewDelegator *instance = [self new];
	instance.mapView = mapView;
	mapView.delegate = instance;
	return instance;
}

#pragma mark -

-(void)configureWithAnnotations:(NSArray<TKAnnotationWrapper *> *)annotations {
	[self.mapView removeAnnotations:self.mapView.annotations];
	[self.mapView addAnnotations:annotations];
}

-(void)reloadData {
	@weakify(self);
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		@strongify(self);

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

		dispatch_async(dispatch_get_main_queue(), ^{
			@strongify(self);
			[self configureWithAnnotations:annotations];
		});
	});
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
	id<MKAnnotation> annotation = view.annotation;

	NSIndexPath *indexPath = [self.class indexPathOf:annotation];
	id data = [self.class dataOf:annotation];
	id<MKAnnotation> anno = [self.class annotationOf:annotation];

	if([self mapView:mapView shouldSelectAnnotation:anno atIndexPath:indexPath withData:data]) {
		[self mapView:mapView didSelectAnnotation:anno atIndexPath:indexPath withData:data];
	}
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	id<MKAnnotation> annotation = view.annotation;

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
