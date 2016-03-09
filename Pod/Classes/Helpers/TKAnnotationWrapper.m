//
//  TKAnnotationWrapper.m
//  ios-util
//
//  Created by Tom Knapen on 02/03/16.
//  Copyright © 2016 Appwise. All rights reserved.
//

#import "TKAnnotationWrapper.h"

@interface TKAnnotationWrapper ()

@property (nonatomic, strong) id<MKAnnotation> annotation;

@end

@implementation TKAnnotationWrapper

+(instancetype)wrap:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data {
	TKAnnotationWrapper *instance = [self new];
	instance.annotation = annotation;
	instance.indexPath = indexPath;
	instance.data = data;
	return instance;
}

-(id<MKAnnotation>)unwrap {
	return self.annotation;
}

#pragma mark - Passthrough

-(CLLocationCoordinate2D)coordinate {
	return [self.unwrap coordinate];
}

-(NSString *)title {
	if([self.annotation respondsToSelector:@selector(title)]) {
		return [self.unwrap title];
	}
	return nil;
}

-(NSString *)subtitle {
	if([self.annotation respondsToSelector:@selector(subtitle)]) {
		return [self.unwrap subtitle];
	}
	return nil;
}

@end


@implementation MKMapView (TKAnnotationWrapper)

-(TKAnnotationWrapper *)annotationAtIndexPath:(NSIndexPath *)indexPath {
	for(id<MKAnnotation> annotation in self.annotations) {
		if(![annotation isKindOfClass:TKAnnotationWrapper.class]) continue;
		TKAnnotationWrapper *wrapper = (TKAnnotationWrapper *)annotation;
		if(wrapper.indexPath == indexPath) return wrapper;
	}
	return nil;
}

@end
