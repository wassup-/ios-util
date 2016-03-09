//
//  TKMapViewDelegate.h
//  iOS-util
//
//  Created by Tom Knapen on 28/01/16.
//
//

#ifndef TKMapViewDelegate_
#define TKMapViewDelegate_

@import Foundation;
@import MapKit;

@protocol TKMapViewDelegate <NSObject>

@optional
-(BOOL)mapView:(MKMapView *)mapView shouldSelectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data;
-(BOOL)mapView:(MKMapView *)mapView shouldDeselectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data;

-(void)mapView:(MKMapView *)mapView didSelectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data;
-(void)mapView:(MKMapView *)mapView didDeselectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data;

@end


@interface MKMapView (TKDelegate)

-(void)selectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data animated:(BOOL)animated;
-(void)deselectAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data animated:(BOOL)animated;

@end

#endif // TKMapViewDelegate_
