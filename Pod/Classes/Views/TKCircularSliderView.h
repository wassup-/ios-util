//
//  TKCircularSliderView.h
//  iOS-util
//
//  Created by Tom Knapen on 16/09/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

@import CoreGraphics;
@import UIKit;

@class TKCircularSliderView;

@protocol TKCircularSliderViewProtocol <NSObject>

@required
-(void)circularSliderView:(TKCircularSliderView*)sliderView valueChanged:(NSInteger)value;

@optional
-(void)circularSliderView:(TKCircularSliderView*)sliderView valueIncrement:(NSInteger)increment;
-(void)circularSliderView:(TKCircularSliderView *)sliderView valueDecrement:(NSInteger)decrement;

-(void)circularSliderView:(TKCircularSliderView*)sliderView draggingDidStart:(NSInteger)value;
-(void)circularSliderView:(TKCircularSliderView*)sliderView draggingDidEnd:(NSInteger)value;

@end

@interface TKCircularSliderView : UIControl

@property (nonatomic, assign) IBInspectable NSInteger minimumValue;
@property (nonatomic, assign) IBInspectable NSInteger maximumValue;
@property (nonatomic, assign) IBInspectable NSInteger currentValue;

@property (nonatomic, assign) IBInspectable NSInteger stepSize;

@property (nonatomic, assign) IBInspectable CGFloat sliderRadius;
@property (nonatomic, strong, readonly) UIView *sliderView;

@property (nonatomic, weak) id<TKCircularSliderViewProtocol> delegate;

@end
