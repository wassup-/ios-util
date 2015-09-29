//
//  TKToastView.h
//  iOS-util
//
//  Created by Tom Knapen on 11/09/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKToastView : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL removeOnHide;

-(void)show;
-(void)showWithDuration:(NSTimeInterval)duration;

-(void)showInView:(UIView*)parentView;
-(void)showInView:(UIView*)parentView withDuration:(NSTimeInterval)duration;

-(void)hide;

+(void)showToast:(NSString*)text inView:(UIView*)parentView withDuration:(NSTimeInterval)duration;

@end
