//
//  TKGradientBackgroundView.m
//  iOS-util
//
//  Created by Tom Knapen on 20/10/15.
//  Copyright © 2015 Tom Knapen. All rights reserved.
//

#import "TKGradientBackgroundView.h"

@interface TKGradientBackgroundView ()

@property (nonatomic, strong, readonly) CAGradientLayer *gradientLayer;

@end

@implementation TKGradientBackgroundView

@synthesize gradientLayer = _gradientLayer;

-(void)layoutSubviews {
	[super layoutSubviews];
	self.gradientLayer.frame = self.bounds;
}

#pragma mark - Properties

-(UIColor *)startColor {
	return _startColor ?: UIColor.clearColor;
}

-(UIColor *)endColor {
	return _endColor ?: UIColor.clearColor;
}

-(CAGradientLayer *)gradientLayer {
	if(!_gradientLayer) {
		_gradientLayer = [CAGradientLayer new];
		_gradientLayer.frame = self.bounds;
		_gradientLayer.colors = @[(id)self.startColor.CGColor, (id)self.endColor.CGColor];
		[self.layer insertSublayer:_gradientLayer atIndex:0];
	}
	return _gradientLayer;
}

@end
