//
//  TKScrollViewController.m
//  iOS-util
//
//  Created by Tom Knapen on 14/09/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import "TKScrollViewController.h"

@import Masonry;

@interface TKScrollViewController () <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isScrolling;

@end

static CGFloat const kTopViewMinHeight = 0.;
static CGFloat const kTopViewMaxHeight = 400.;

@implementation TKScrollViewController

@synthesize isScrolling = _isScrolling;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.scrollView.delegate = self;

	[self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.mas_topLayoutGuide);
	}];
}

-(void)scrollToTop:(BOOL)animated {
	[self.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:animated];
}

#pragma mark - Properties

-(BOOL)isScrolling {
	return _isScrolling;
}

-(void)setIsScrolling:(BOOL)isScrolling {
	if(isScrolling != self.isScrolling) {
		_isScrolling = isScrolling;

		if(_isScrolling) {
			[self scrollingDidStart:self.scrollView.contentOffset.y];
		} else {
			[self scrollingDidEnd:self.scrollView.contentOffset.y];
		}
	}
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	// Sanity check
	if(scrollView != self.scrollView) return;

	self.isScrolling = YES;

	const CGFloat minHeight = [self minimumHeight];
	const CGFloat maxHeight = [self maximumHeight];
	const CGPoint offset = scrollView.contentOffset;
	const CGFloat offsetY = offset.y + self.scrollView.contentInset.top;
	const CGFloat height = (maxHeight - offsetY) - self.bottomOffset;
	const CGFloat clampedHeight = fmax(minHeight, fmin(maxHeight, height));

	[self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(clampedHeight);
	}];

	[self didScroll:height];

	if(height < minHeight) {
		[self lessThanMinimum:height];
	} else {
		[self greaterThanMinimum:height];

		if(height < maxHeight) {
			[self lessThanMaximum:height];
		} else {
			[self greaterThanMaximum:height];
		}
	}
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	// Sanity check
	if(scrollView != self.scrollView) return;

	self.isScrolling = NO;
}

-(CGFloat)minimumHeight {
	return [self.delegate scrollViewController:self minimumHeight:kTopViewMinHeight];
}

-(CGFloat)maximumHeight {
	return [self.delegate scrollViewController:self maximumHeight:kTopViewMaxHeight];
}

-(void)didScroll:(CGFloat)height {
	if([self.delegate respondsToSelector:@selector(scrollViewController:didScroll:)])
		[self.delegate scrollViewController:self didScroll:height];
}

-(void)lessThanMinimum:(CGFloat)height {
	if([self.delegate respondsToSelector:@selector(scrollViewController:lessThanMinimum:)])
		[self.delegate scrollViewController:self lessThanMinimum:height];
}

-(void)greaterThanMinimum:(CGFloat)height {
	if([self.delegate respondsToSelector:@selector(scrollViewController:greaterThanMinimum:)])
		[self.delegate scrollViewController:self greaterThanMinimum:height];
}

-(void)lessThanMaximum:(CGFloat)height {
	if([self.delegate respondsToSelector:@selector(scrollViewController:lessThanMaximum:)])
		[self.delegate scrollViewController:self lessThanMaximum:height];
}

-(void)greaterThanMaximum:(CGFloat)height {
	if([self.delegate respondsToSelector:@selector(scrollViewController:greaterThanMaximum:)])
		[self.delegate scrollViewController:self greaterThanMaximum:height];
}

-(void)scrollingDidStart:(CGFloat)offset {
		if([self.delegate respondsToSelector:@selector(scrollViewController:scrollingDidStart:)])
			[self.delegate scrollViewController:self scrollingDidStart:offset];
}

-(void)scrollingDidEnd:(CGFloat)offset {
	if([self.delegate respondsToSelector:@selector(scrollViewController:scrollingDidEnd:)])
		[self.delegate scrollViewController:self scrollingDidEnd:offset];
}

@end
