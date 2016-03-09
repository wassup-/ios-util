//
//  TKCircularSliderView.m
//  iOS-util
//
//  Created by Tom Knapen on 16/09/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import "TKCircularSliderView.h"

@import Masonry;

#pragma mark - Structs

typedef struct {
	CGVector start;
	CGVector end;
} Quadrant;

typedef struct {
	CGVector center;
	CGFloat size;
} Section;

typedef struct {
	NSInteger minimumValue;
	NSInteger maximumValue;
	NSInteger currentValue;
} State;

static const Quadrant quadrants[] = {
	{ { 0, -1}, { 1,  0} },
	{ { 1,  0}, { 0,  1} },
	{ { 0,  1}, {-1,  0} },
	{ {-1,  0}, { 0, -1} },
};

#pragma mark - Utility functions

CGVector VectorSub(CGVector left, CGVector right) {
	return CGVectorMake(left.dx - right.dx, left.dy - right.dy);
}

CGFloat VectorLength(CGVector vec) {
	return sqrt((vec.dx * vec.dx) + (vec.dy * vec.dy));
}

CGVector VectorNormalize(CGVector vec) {
	const CGFloat len = VectorLength(vec);
	return CGVectorMake(vec.dx / len, vec.dy / len);
}

BOOL isVectorInSection(CGVector vector, Section section) {
	const CGVector norm_vec = VectorNormalize(vector);
	const CGVector norm_cen = VectorNormalize(section.center);
	const CGFloat length = VectorLength(VectorSub(norm_cen, norm_vec));
	return length <= (section.size / 2.);
}

#pragma mark -

@interface TKCircularSliderView ()

@property (nonatomic, assign) State state;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) CGPoint sliderOffset;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation TKCircularSliderView

@synthesize isDragging = _isDragging;
@synthesize sliderView = _sliderView;

#pragma mark - UIView

-(void)awakeFromNib {
	[super awakeFromNib];

	_sliderView = ({
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sliderRadius, self.sliderRadius)];
		view.backgroundColor = self.backgroundColor;
		view.layer.cornerRadius = (self.sliderRadius / 2.);
		view;
	});

	{
		CAShapeLayer *borderLayer = CAShapeLayer.layer;
		borderLayer.strokeColor = self.backgroundColor.CGColor;
		borderLayer.fillColor = UIColor.clearColor.CGColor;
		borderLayer.lineWidth = 2.;
		borderLayer.lineDashPattern = @[@4, @2];

		CGRect rect = self.layer.bounds;
		borderLayer.path = [UIBezierPath bezierPathWithOvalInRect:rect].CGPath;

		[self.layer addSublayer:borderLayer];
	}

	self.backgroundColor = UIColor.clearColor;
	self.layer.cornerRadius = (self.frame.size.width / 2.);

	[self addSubview:_sliderView];
	[self bringSubviewToFront:_sliderView];

	[_sliderView mas_updateConstraints:^(MASConstraintMaker *make) {
		// Size
		make.width.mas_equalTo(self.sliderRadius);
		make.height.mas_equalTo(self.sliderRadius);
		// Position
		make.centerX.equalTo(self.mas_centerX);
		make.centerY.equalTo(self.mas_centerY);
	}];

	self.sliderOffset = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);

	self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	[self addGestureRecognizer:self.tapGesture];
}

-(void)layoutSubviews {
	[super layoutSubviews];
	[self repositionSliderView];
}

#pragma mark - UIResponder

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *const touch = touches.anyObject;
	self.isDragging = [touch.view isEqual:self.sliderView];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if(!self.isDragging)
		return;

	UITouch *const touch = touches.anyObject;

	if(![touch.view isEqual:self.sliderView])
		return;

	[self updateValueBasedOnPosition:[touch locationInView:self]];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *const touch = touches.anyObject;

	if(![touch.view isEqual:self.sliderView])
		return;

	self.isDragging = NO;
}

#pragma mark - Actions

-(void)tap:(UITapGestureRecognizer*)gesture {
	if(![gesture.view isEqual:self])
		return;

	[self updateValueBasedOnPosition:[gesture locationInView:self]];
}

#pragma mark -

-(void)updateValueBasedOnPosition:(CGPoint)position {
	const CGVector vector = [self pointToVector:position];
	const NSInteger value = [self valueFor:vector];
	if((value >= self.minimumValue) && (value <= self.maximumValue)) {
		self.currentValue = value;
	}
}

#pragma mark - Properties

-(NSInteger)minimumValue {
	return self.state.minimumValue;
}

-(void)setMinimumValue:(NSInteger)minimumValue {
	State newState = { minimumValue, self.maximumValue, self.currentValue };
	self.state = newState;
}

-(NSInteger)maximumValue {
	return self.state.maximumValue;
}

-(void)setMaximumValue:(NSInteger)maximumValue {
	State newState = { self.minimumValue, maximumValue, self.currentValue };
	self.state = newState;
}

-(NSInteger)numValues {
	return ((self.maximumValue - self.minimumValue) + 1) / self.stepSize;
}

-(NSInteger)currentValue {
	return self.state.currentValue;
}

-(void)setCurrentValue:(NSInteger)currentValue {
	NSAssert(currentValue >= self.minimumValue, @"currentValue must be at least minimumValue");
	NSAssert(currentValue <= self.maximumValue, @"currentValue must be at most maximumValue");

	if(self.state.currentValue != currentValue) {
		const NSInteger diff = currentValue - self.state.currentValue;
		// TODO fix check
		if(diff < 0) {
			[self valueDecrement:-diff];
		} else if(diff > 0) {
			[self valueIncrement:diff];
		}

		State newState = { self.minimumValue, self.maximumValue, currentValue };
		self.state = newState;

		[self setNeedsLayout];

		[self valueChanged:self.currentValue];
	}
}

-(BOOL)isDragging {
	return _isDragging;
}

-(void)setIsDragging:(BOOL)isDragging {
	if(_isDragging != isDragging) {
		_isDragging = isDragging;
		if(_isDragging) {
			[self draggingDidStart:self.currentValue];
		} else {
			[self draggingDidEnd:self.currentValue];
		}
	}
}

#pragma mark - Delegate methods

-(void)valueIncrement:(NSInteger)value {
	if([self.delegate respondsToSelector:@selector(circularSliderView:valueIncrement:)])
		[self.delegate circularSliderView:self valueIncrement:value];
}

-(void)valueDecrement:(NSInteger)value {
	if([self.delegate respondsToSelector:@selector(circularSliderView:valueDecrement:)])
		[self.delegate circularSliderView:self valueDecrement:value];
}

-(void)valueChanged:(NSInteger)value {
	[self.delegate circularSliderView:self valueChanged:value];
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)draggingDidStart:(NSInteger)value {
	if([self.delegate respondsToSelector:@selector(circularSliderView:draggingDidStart:)])
		[self.delegate circularSliderView:self draggingDidStart:value];
}

-(void)draggingDidEnd:(NSInteger)value {
	if([self.delegate respondsToSelector:@selector(circularSliderView:draggingDidEnd:)])
		[self.delegate circularSliderView:self draggingDidEnd:value];
}

#pragma mark - Helper functions

-(void)repositionSliderView {
	const CGVector center = [self vectorFor:self.currentValue];
	const CGPoint offset = CGPointMake(center.dx * self.sliderOffset.x, center.dy * self.sliderOffset.y);
	[self.sliderView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.center.centerOffset(offset);
	}];
}

+(CGVector)incrementTowardsEnd:(CGVector)vector increment:(CGVector)diff end:(CGVector)end {
	if(vector.dx < end.dx)
		vector.dx += diff.dx;
	else
		vector.dx -= diff.dx;
	if(vector.dy < end.dy)
		vector.dy += diff.dy;
	else
		vector.dy -= diff.dy;
	return vector;
}

-(CGVector)pointToVector:(CGPoint)point {
	const CGPoint center = self.sliderOffset;
	const CGVector vec = CGVectorMake(point.x - center.x, point.y - center.y);
	return VectorNormalize(vec);
}

-(NSInteger)indexOfVector:(CGVector)vector inQuadrant:(Quadrant)quadrant sections:(NSInteger)sections {
	const CGFloat kSectionSize = (1. / sections);

	for(NSInteger i = 0; i < sections; ++i) {
		const CGVector center = [self.class incrementTowardsEnd:quadrant.start increment:CGVectorMake(i * kSectionSize, i * kSectionSize) end:quadrant.end];
		const Section section = { center, kSectionSize};
		if(isVectorInSection(vector, section))
			return i;
	}

	return -1;
}

-(NSInteger)valueAt:(CGVector)vector minimum:(NSInteger)minimum maximum:(NSInteger)maximum {
	static NSInteger const kNumQuadrants = 4;
	const NSInteger kNumSectionsPerQuadrant = self.numValues / kNumQuadrants;

	NSInteger baseIndex = minimum;

	for(NSInteger i = 0; i < kNumQuadrants; ++i) {
		const Quadrant quadrant = quadrants[i];

		const NSInteger index = [self indexOfVector:vector inQuadrant:quadrant sections:kNumSectionsPerQuadrant];
		if(index >= 0)
			return baseIndex + index;

		baseIndex += kNumSectionsPerQuadrant;
	}

	return (minimum - 1);
}

-(NSInteger)valueFor:(CGVector)vector {
	return [self valueAt:vector minimum:self.minimumValue maximum:self.maximumValue];
}

-(CGVector)vectorFor:(NSInteger)value {
	NSAssert(value >= self.minimumValue, @"value must be at least minimumValue");
	NSAssert(value <= self.maximumValue, @"value must be at most minimumValue");

	value -= self.minimumValue;

	static const NSInteger kNumQuadrants = 4;
	const NSInteger kNumSectionsPerQuadrant = self.numValues / kNumQuadrants;
	const CGFloat kSectionSize = (1. / kNumSectionsPerQuadrant);

	const NSInteger quadrant = (value / kNumSectionsPerQuadrant);
	const NSInteger section = (value - (quadrant * kNumSectionsPerQuadrant));

	const Quadrant quad = quadrants[quadrant];
	const CGVector center = [self.class incrementTowardsEnd:quad.start increment:CGVectorMake(section * kSectionSize, section * kSectionSize) end:quad.end];
	return VectorNormalize(center);
}

@end
