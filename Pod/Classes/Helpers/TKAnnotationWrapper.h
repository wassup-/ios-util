//
//  TKAnnotationWrapper.h
//  ios-util
//
//  Created by Tom Knapen on 02/03/16.
//  Copyright © 2016 Appwise. All rights reserved.
//

@import MapKit;

@interface TKAnnotationWrapper : NSObject<MKAnnotation>

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) id data;

+(instancetype)wrap:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data;
-(id<MKAnnotation>)unwrap;

@end


@interface MKMapView (TKAnnotationWrapper)

-(TKAnnotationWrapper *)annotationAtIndexPath:(NSIndexPath *)indexPath;

@end
