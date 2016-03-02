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

#endif // TKMapViewDelegate_
