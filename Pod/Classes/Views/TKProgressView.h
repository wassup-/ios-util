//
//  TKProgressView.h
//  iOS-util
//
//  Created by Tom Knapen on 01/03/16.
//  Copyright © 2016 Tom Knapen. All rights reserved.
//

@import UIKit;

#pragma mark - Classes

@protocol TKProgressInterface;

@class TKProgress;
@class TKDeterminateProgress;
@class TKIndeterminateProgress;

@interface TKProgress : UIView

+(id<TKProgressInterface>)hideOnView:(UIView *)view;

@end

@interface TKStatusProgress : TKProgress

+(id<TKProgressInterface>)showOnView:(UIView *)view withSuccess:(NSString *)success;
+(id<TKProgressInterface>)showOnView:(UIView *)view withError:(NSString *)error;

+(id<TKProgressInterface>)showOnView:(UIView *)view withSuccess:(NSString *)success hideDelay:(NSTimeInterval)hideDelay;
+(id<TKProgressInterface>)showOnView:(UIView *)view withError:(NSString *)error hideDelay:(NSTimeInterval)hideDelay;

@end

@interface TKDeterminateProgress : TKProgress

+(id<TKProgressInterface>)showOnView:(UIView *)view withProgress:(CGFloat)progress;
+(id<TKProgressInterface>)showOnView:(UIView *)view withMessage:(NSString *)message andProgress:(CGFloat)progress;

@end

@interface TKIndeterminateProgress : TKProgress

+(id<TKProgressInterface>)showOnView:(UIView *)view;
+(id<TKProgressInterface>)showOnView:(UIView *)view withMessage:(NSString *)message;

@end

#pragma mark - Categories

//@interface TKProgress (Status)
//
//+(instancetype)showOnView:(UIView *)view withMessage:(NSString *)message;
//+(instancetype)showOnView:(UIView *)view withSuccess:(NSString *)success;
//+(instancetype)showOnView:(UIView *)view withError:(NSString *)error;
//
//@end
//
//@interface TKProgress (Determinate)
//
//+(TKDeterminateProgress *)showOnView:(UIView *)view withProgress:(CGFloat)progress;
//+(TKDeterminateProgress *)showOnView:(UIView *)view withMessage:(NSString *)message andProgress:(CGFloat)progress;
//
//@end
//
//@interface TKProgress (Indeterminate)
//
//+(TKIndeterminateProgress *)showOnView:(UIView *)view;
//+(TKIndeterminateProgress *)showOnView:(UIView *)view withMessage:(NSString *)message;
//
//@end
