//
//  TKScrollViewController.h
//  iOS-util
//
//  Created by Tom Knapen on 14/09/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKScrollViewController;

@protocol TKScrollViewControllerProtocol <NSObject>

@required
-(CGFloat)scrollViewController:(TKScrollViewController*)scrollViewController minimumHeight:(CGFloat)suggestedHeight;
-(CGFloat)scrollViewController:(TKScrollViewController*)scrollViewController maximumHeight:(CGFloat)suggestedHeight;

@optional
-(void)scrollViewController:(TKScrollViewController*)scrollViewController didScroll:(CGFloat)height;
-(void)scrollViewController:(TKScrollViewController*)scrollViewController lessThanMinimum:(CGFloat)height;
-(void)scrollViewController:(TKScrollViewController*)scrollViewController greaterThanMinimum:(CGFloat)height;

-(void)scrollViewController:(TKScrollViewController*)scrollViewController lessThanMaximum:(CGFloat)height;
-(void)scrollViewController:(TKScrollViewController*)scrollViewController greaterThanMaximum:(CGFloat)height;

-(void)scrollViewController:(TKScrollViewController*)scrollViewController scrollingDidStart:(CGFloat)offset;
-(void)scrollViewController:(TKScrollViewController *)scrollViewController scrollingDidEnd:(CGFloat)offset;

@end

@interface TKScrollViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, assign) CGFloat bottomOffset;

@property (nonatomic, strong) id<TKScrollViewControllerProtocol> delegate;

-(void)scrollToTop:(BOOL)animated;

@end
