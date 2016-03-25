//
//  TKMapViewDelegator.m
//  iOS-util
//
//  Created by Tom Knapen on 02/03/16.
//  Copyright © 2016 Appwise. All rights reserved.
//

#import "TKMapViewDelegator.h"

#import <objc/runtime.h>

@import LBDelegateMatrioska;

static char const kAssociationDelegatorKey;
static char const kAssociatedIndexPathKey;
static char const kAssociatedDatakey;
static char const kAssociatedAnnotationKey;

@interface TKMapViewDelegator ()

@property (nonatomic, strong) LBDelegateMatrioska *delegateProxy;

@end

@implementation TKMapViewDelegator

#pragma mark - Creators

+(instancetype)delegatorForMapView:(MKMapView *)mapView {
	TKMapViewDelegator *instance = objc_getAssociatedObject(mapView, &kAssociationDelegatorKey);

	if(!instance) {
		instance = ({
			TKMapViewDelegator *instance = [self new];
			instance.mapView = mapView;
			
			id<MKMapViewDelegate> prevDelegate = mapView.delegate;
			mapView.delegate = instance.delegateProxy;
			if(prevDelegate) {
				instance.passthroughDelegate = prevDelegate;
			}
			instance;
		});
		objc_setAssociatedObject(mapView, &kAssociationDelegatorKey, instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return instance;
}

#pragma mark -

-(void)configureWithAnnotations:(NSArray<id<MKAnnotation>> *)annotations {
	[self.mapView removeAnnotations:self.mapView.annotations];
	[self.mapView addAnnotations:annotations];
}

-(void)reloadData {
	const NSInteger annotationCount = [self.dataSource numberOfAnnotationsForMapView:self.mapView];
	NSMutableArray<id<MKAnnotation>> *annotations = [NSMutableArray arrayWithCapacity:annotationCount];
	for(NSInteger i = 0; i < annotationCount; ++i) {
		NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:i];
		id data = [self.dataSource mapView:self.mapView dataForAnnotationAtIndexPath:indexPath];
		id<MKAnnotation> annotation = [self.dataSource mapView: self.mapView
										 annotationAtIndexPath: indexPath
													  withData: data];
		
		[self.class setIndexPathOf:annotation to:indexPath];
		[self.class setDataOf:annotation to:data];
		[self.class setAnnotationOf:annotation to:annotation];
		
		[annotations addObject:annotation];
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
	NSIndexPath *indexPath = [self.class indexPathOf:annotation];
	id data = [self.class dataOf:annotation];
	id<MKAnnotation> anno = [self.class annotationOf:annotation];
	id identifier = [self.dataSource mapView: mapView
			  classOrIdentifierForAnnotation: anno
								 atIndexPath: indexPath
									withData: data];
	MKAnnotationView *reuseView = ([identifier isKindOfClass:NSString.class]) ? [mapView dequeueReusableAnnotationViewWithIdentifier:identifier] : nil;

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
	
	if([annotation isKindOfClass:MKUserLocation.class]) return;

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

	if([annotation isKindOfClass:MKUserLocation.class]) return;

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

+(void)setIndexPathOf:(id<MKAnnotation>)annotation to:(NSIndexPath *)indexPath {
	objc_setAssociatedObject(annotation, &kAssociatedIndexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void)setDataOf:(id<MKAnnotation>)annotation to:(id)data {
	objc_setAssociatedObject(annotation, &kAssociatedDatakey, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void)setAnnotationOf:(id<MKAnnotation>)annotation to:(id<MKAnnotation>)anno {
	objc_setAssociatedObject(annotation, &kAssociatedAnnotationKey, anno, OBJC_ASSOCIATION_ASSIGN);
}

+(NSIndexPath *)indexPathOf:(id<MKAnnotation>)annotation {
	if([annotation isKindOfClass:MKUserLocation.class]) return nil;
	return objc_getAssociatedObject(annotation, &kAssociatedIndexPathKey);
}

+(id)dataOf:(id<MKAnnotation>)annotation {
	if([annotation isKindOfClass:MKUserLocation.class]) return nil;
	return objc_getAssociatedObject(annotation, &kAssociatedDatakey);
}

+(id<MKAnnotation>)annotationOf:(id<MKAnnotation>)annotation {
	if([annotation isKindOfClass:MKUserLocation.class]) return annotation;
	return objc_getAssociatedObject(annotation, &kAssociatedAnnotationKey);
}

@end

@implementation MKMapView (TKDelegate)

-(void)selectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data animated:(BOOL)animated {
	[self selectAnnotation:annotation animated:animated];
}

-(void)deselectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data animated:(BOOL)animated {
	[self deselectAnnotation:annotation animated:animated];
}

@end

@implementation MKMapView (TKMapViewDelegator)

-(id<MKAnnotation>)annotationAtIndexPath:(NSIndexPath *)indexPath {
	for(id<MKAnnotation> annotation in self.annotations) {
		if([TKMapViewDelegator indexPathOf:annotation] == indexPath) return annotation;
	}
	return nil;
}

-(id<MKAnnotation>)annotationWithData:(id)data {
	for(id<MKAnnotation> annotation in self.annotations) {
		if([TKMapViewDelegator dataOf:annotation] == data) return annotation;
	}
	return nil;
}

@end
