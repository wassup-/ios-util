//
//  TKMultiStateButton.h
//  iOS-util
//
//  Created by Tom Knapen on 01/10/15.
//  Copyright © 2015 Tom Knapen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TKMultiStateButtonState) {
	TKMultiStateButtonStateInactive = 0,
	TKMultiStateButtonStateActive
};

typedef NS_OPTIONS(NSUInteger, TKMultiStateButtonInteractionRegion) {
	TKMultiStateButtonInteractionRegionTop = 1,
	TKMultiStateButtonInteractionRegionRight = 2,
	TKMultiStateButtonInteractionRegionBottom = 4,
	TKMultiStateButtonInteractionRegionLeft = 8,
};

@class TKMultiStateButton;

typedef void(^TKMultiStateButtonAction)(TKMultiStateButton *button);

@interface TKInteractionRegion : NSObject

@property (nonatomic, readonly) TKMultiStateButtonInteractionRegion region;
@property (nonatomic, readonly) TKMultiStateButtonAction action;

-(instancetype)initWithRegion:(TKMultiStateButtonInteractionRegion)region;
-(instancetype)initWithRegion:(TKMultiStateButtonInteractionRegion)region andAction:(TKMultiStateButtonAction)action;

@end

@protocol TKMultiStateButtonInteractionProtocol <NSObject>
@required
-(void)userInteraction:(TKMultiStateButton *)button inRegion:(TKMultiStateButtonInteractionRegion)region;

@end

@interface TKMultiStateButton : UIControl

@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) TKMultiStateButtonState buttonState;
@property (nonatomic, strong) id<TKMultiStateButtonInteractionProtocol> interactionDelegate;

@property (nonatomic, readonly) NSArray<TKInteractionRegion *> *interactionRegions;

-(void)addInteraction:(TKInteractionRegion *)interaction;

-(void)removeInteractionRegion:(TKMultiStateButtonInteractionRegion)region;

@end


@interface TKInteractionRegion (EasyConstruct)

+(instancetype)interactionWithRegion:(TKMultiStateButtonInteractionRegion)region thatChangesBackgroundImageTo:(UIImage *)image;

@end
