//
//  TKSwitch.h
//  iOS-util
//
//  Created by Tom Knapen on 21/09/15.
//  Copyright © 2015 Tom Knapen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKSwitch;

@protocol TKSwitchProtocol <NSObject>
@required
-(void)selectedIndexChanged:(TKSwitch*)control selectedIndex:(NSInteger)selectedIndex;

@optional
-(void)selectedIndexWillChange:(TKSwitch*)control toIndex:(NSInteger)selectedIndex;

@end

@interface TKSwitch : UIControl

@property (nonatomic, strong) IBInspectable NSString *leftTitle;
@property (nonatomic, strong) IBInspectable NSString *rightTitle;
@property (nonatomic, assign) IBInspectable NSInteger selectedIndex;
@property (nonatomic, strong) IBInspectable UIColor *selectedBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *titleColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedTitleColor;
@property (nonatomic, strong) IBInspectable UIFont *titleFont;
@property (nonatomic, assign) IBInspectable CGFloat selectedBackgroundInset;

@property (nonatomic, assign) IBInspectable NSTimeInterval animationDuration;
@property (nonatomic, assign) IBInspectable CGFloat animationSpringDamping;
@property (nonatomic, assign) IBInspectable CGFloat animationInitialSpringVelocity;

@property (nonatomic, weak) id<TKSwitchProtocol> delegate;

@end
