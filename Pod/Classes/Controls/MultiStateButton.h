//
//  MultiStateButton.h
//  iOS-util
//
//  Created by Tom Knapen on 01/10/15.
//  Copyright © 2015 Tom Knapen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MultiStateButtonState) {
	MultiStateButtonStateInactive = 0,
	MultiStateButtonStateActive
};

typedef NS_OPTIONS(NSUInteger, MultiStateButtonInteractionRegion) {
	MultiStateButtonInteractionRegionTop = 1,
	MultiStateButtonInteractionRegionRight = 2,
	MultiStateButtonInteractionRegionBottom = 4,
	MultiStateButtonInteractionRegionLeft = 8,
};

@class MultiStateButton;

typedef void(^MultiStateButtonAction)(MultiStateButton *button);

@interface InteractionRegion : NSObject

@property (nonatomic, readonly) MultiStateButtonInteractionRegion region;
@property (nonatomic, readonly) MultiStateButtonAction action;

-(instancetype)initWithRegion:(MultiStateButtonInteractionRegion)region;
-(instancetype)initWithRegion:(MultiStateButtonInteractionRegion)region andAction:(MultiStateButtonAction)action;

@end

@protocol MultiStateButtonInteractionProtocol <NSObject>
@required
-(void)userInteraction:(MultiStateButton *)button inRegion:(MultiStateButtonInteractionRegion)region;

@end

@interface MultiStateButton : UIControl

@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) MultiStateButtonState buttonState;
@property (nonatomic, strong) id<MultiStateButtonInteractionProtocol> interactionDelegate;

@property (nonatomic, readonly) NSArray<InteractionRegion *> *interactionRegions;

-(void)addInteraction:(InteractionRegion *)interaction;

-(void)removeInteractionRegion:(MultiStateButtonInteractionRegion)region;

@end


@interface InteractionRegion (EasyConstruct)

+(instancetype)interactionWithRegion:(MultiStateButtonInteractionRegion)region thatChangesBackgroundImageTo:(UIImage *)image;

@end
