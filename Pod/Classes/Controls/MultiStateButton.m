//
//  MultiStateButton.m
//  iOS-util
//
//  Created by Tom Knapen on 01/10/15.
//  Copyright © 2015 Tom Knapen. All rights reserved.
//

#import "MultiStateButton.h"

@interface InteractionRegion ()

-(BOOL)containsPoint:(CGPoint)point inButton:(MultiStateButton*)button;

@end

@implementation InteractionRegion
@synthesize region = _region;
@synthesize action = _action;

-(instancetype)initWithRegion:(MultiStateButtonInteractionRegion)region {
	return [self initWithRegion:region andAction:nil];
}

-(instancetype)initWithRegion:(MultiStateButtonInteractionRegion)region andAction:(MultiStateButtonAction)action {
	self = [super init];
	_region = region;
	_action = action;
	return self;
}

-(CGRect)rectForRegion:(MultiStateButtonInteractionRegion)region inRect:(CGRect)rect {
	switch(region) {
		case MultiStateButtonInteractionRegionTop:
			return CGRectMake(0.,
							  0.,
							  rect.size.width,
							  rect.size.height / 2.);
		case MultiStateButtonInteractionRegionRight:
			return CGRectMake(rect.size.width / 2.,
							  0.,
							  rect.size.width / 2.,
							  rect.size.height);
		case MultiStateButtonInteractionRegionBottom:
			return CGRectMake(0.,
							  rect.size.height / 2.,
							  rect.size.width,
							  rect.size.height / 2.);
		case MultiStateButtonInteractionRegionLeft:
			return CGRectMake(0.,
							  0.,
							  rect.size.width / 2.,
							  rect.size.height);
	}
}

-(CGRect)rectInRect:(CGRect)parentRect {
	CGRect rect = CGRectMake(0, 0, parentRect.size.width, parentRect.size.height);
	if(self.region & MultiStateButtonInteractionRegionTop)
		rect = CGRectIntersection(rect, [self rectForRegion:MultiStateButtonInteractionRegionTop inRect:parentRect]);
	if(self.region & MultiStateButtonInteractionRegionRight)
		rect = CGRectIntersection(rect, [self rectForRegion:MultiStateButtonInteractionRegionRight inRect:parentRect]);
	if(self.region & MultiStateButtonInteractionRegionBottom)
		rect = CGRectIntersection(rect, [self rectForRegion:MultiStateButtonInteractionRegionBottom inRect:parentRect]);
	if(self.region & MultiStateButtonInteractionRegionLeft)
		rect = CGRectIntersection(rect, [self rectForRegion:MultiStateButtonInteractionRegionLeft inRect:parentRect]);
	return rect;
}

-(BOOL)containsPoint:(CGPoint)point inButton:(MultiStateButton *)button {
	const CGRect myRect = [self rectInRect:button.frame];
	return CGRectContainsPoint(myRect, point);
}

@end


@interface MultiStateButton ()

@property (nonatomic, strong) UIImage *originalBackgroundImage;
@property (nonatomic, strong) NSMutableArray<InteractionRegion *> *realInteractionRegions;

@end

@implementation MultiStateButton
@synthesize backgroundImageView = _backgroundImageView;

#pragma mark - Initialization

-(void)initialize {
	self.realInteractionRegions = [NSMutableArray array];
}

#pragma mark - UIControl

-(instancetype)init {
	self = [super init];
	[self initialize];
	return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	[self initialize];
	return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	[self initialize];
	return self;
}

#pragma mark - Methods

-(void)addInteraction:(InteractionRegion *)interaction {
	[self.realInteractionRegions addObject:interaction];
}

-(void)removeInteractionRegion:(MultiStateButtonInteractionRegion)region {
	for(InteractionRegion *interactionRegion in self.realInteractionRegions) {
		if(interactionRegion.region == region) {
			[self.realInteractionRegions removeObject:interactionRegion];
			break;
		}
	}
}

#pragma mark - Gestures

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self onTouchDown:touches.anyObject];
}

//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//	UITouch *const touch = touches.anyObject;
//	const CGPoint position = [touch locationInView:self];
//	for(InteractionRegion *interactionRegion in self.interactionRegions) {
//		if([interactionRegion containsPoint:position inButton:self]) {
//			self.backgroundImage = interactionRegion.image;
//			[self.interactionDelegate userInteraction:self inRegion:interactionRegion.region];
//			break;
//		}
//	}
//}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self onTouchUp:touches.anyObject];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self onTouchUp:touches.anyObject];
}

#pragma mark - Actions

-(void)onTouchDown:(UITouch *)touch {
	const CGPoint position = [touch locationInView:self];
	for(InteractionRegion *interactionRegion in self.interactionRegions) {
		if([interactionRegion containsPoint:position inButton:self]) {
			self.buttonState = MultiStateButtonStateActive;
			interactionRegion.action(self);
			[self.interactionDelegate userInteraction:self inRegion:interactionRegion.region];
			[self sendActionsForControlEvents:UIControlEventValueChanged];
			break;
		}
	}
}

-(void)onTouchUp:(UITouch *)touch {
	self.buttonState = MultiStateButtonStateInactive;
	self.backgroundImage = self.originalBackgroundImage;
}

#pragma mark - Properties

-(UIImageView *)backgroundImageView {
	if(!_backgroundImageView) {
		_backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		_backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
		_backgroundImageView.userInteractionEnabled = YES;
		[self addSubview:_backgroundImageView];
	}
	return _backgroundImageView;
}

-(NSArray<InteractionRegion *> *)interactionRegions {
	return self.realInteractionRegions;
}

-(UIImage *)backgroundImage {
	return self.backgroundImageView.image;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage {
	self.backgroundImageView.image = backgroundImage;
	if(!self.originalBackgroundImage)
		self.originalBackgroundImage = backgroundImage;
}

#pragma mark - Delegate methods

@end

@implementation InteractionRegion (EasyConstruct)

+(instancetype)interactionWithRegion:(MultiStateButtonInteractionRegion)region thatChangesBackgroundImageTo:(UIImage *)image {
		return [[self alloc] initWithRegion: region
								  andAction: ^(MultiStateButton *button) {
									  button.backgroundImage = image;
								  }];
}

@end
