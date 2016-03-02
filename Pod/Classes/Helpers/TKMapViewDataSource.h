#ifndef TKMapViewDataSource_
#define TKMapViewDataSource_

@import Foundation;
@import MapKit;

@protocol TKMapViewDataSource

@required
-(NSInteger)numberOfAnnotationsForMapView:(MKMapView *)mapView;

-(id)mapView:(MKMapView *)mapView dataForAnnotationAtIndexPath:(NSIndexPath *)indexPath;
-(id<MKAnnotation>)mapView:(MKMapView *)mapView annotationAtIndexPath:(NSIndexPath *)indexPath withData:(id)data;

-(id)mapView:(MKMapView *)mapView classOrIdentifierForAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data;
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data reusingView:(MKAnnotationView *)view;
-(void)mapView:(MKMapView *)mapView configureView:(MKAnnotationView *)view forAnnotation:(id<MKAnnotation>)annotation atIndexPath:(NSIndexPath *)indexPath withData:(id)data;

@end

#endif // TKMapViewDataSource_
