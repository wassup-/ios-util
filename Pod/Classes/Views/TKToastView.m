//
//  TKToastView.m
//  iOS-util
//
//  Created by Tom Knapen on 11/09/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

/**
 * http://stackoverflow.com/a/20904416/840382 
 */

#import "TKToastView.h"

@interface TKToastView ()

@property (nonatomic, strong, readonly) UILabel *textLabel;

@end

static CGFloat const kToastHeight = 50.;
static CGFloat const kToastGap = 10.;
static CGFloat const kToastMargin = 20.;
static CGFloat const kLabelInset = 10.;

@implementation TKToastView

@synthesize textLabel = _textLabel;

#pragma mark - UIView

-(void)initialize {
	// Visual
	self.backgroundColor = UIColor.darkGrayColor;
	self.alpha = 0.;
	self.layer.cornerRadius = (kToastHeight / 10.);
	
	// Logical
	self.removeOnHide = NO;
}

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

#pragma mark - Properties

-(UILabel *)textLabel {
	if(!_textLabel) {
		_textLabel = [[UILabel alloc] initWithFrame:CGRectMake((kLabelInset / 2.), (kLabelInset / 2.), self.frame.size.width - kLabelInset, self.frame.size.height - kLabelInset)];
		_textLabel.backgroundColor = UIColor.clearColor;
		_textLabel.textAlignment = NSTextAlignmentCenter;
		_textLabel.textColor = UIColor.whiteColor;
		_textLabel.numberOfLines = 2;
		_textLabel.font = [UIFont systemFontOfSize:13.];
		_textLabel.lineBreakMode = NSLineBreakByCharWrapping;
		[self addSubview:_textLabel];
	}
	return _textLabel;
}

-(NSString*)text {
	return self.textLabel.text;
}

-(void)setText:(NSString *)text {
	self.textLabel.text = text;
}

#pragma mark - Methods

-(void)show {
	[UIView animateWithDuration:.4 animations:^{
		self.alpha = .9;
		self.textLabel.alpha = .9;
	} completion:nil];
}

-(void)showWithDuration:(NSTimeInterval)duration {
	[self show];
	[self performSelector:@selector(hide) withObject:nil afterDelay:duration];
}

-(void)showInView:(UIView *)parentView {
	[parentView addSubview:self];
	[self show];
}

-(void)showInView:(UIView *)parentView withDuration:(NSTimeInterval)duration {
	[parentView addSubview:self];
	[self showWithDuration:duration];
}

-(void)hide {
	[UIView animateWithDuration:.4 animations:^{
		self.alpha = 0.;
		self.textLabel.alpha = 0.;
	} completion:^(BOOL finished) {
		if(finished && self.removeOnHide)
			[self removeFromSuperview];
	}];
}

+(void)showToast:(NSString *)text inView:(UIView *)parentView withDuration:(NSTimeInterval)duration {
	NSInteger toastsInParent = 0;
	for(UIView *subview in parentView.subviews) {
		if([subview isKindOfClass:TKToastView.class])
			toastsInParent += 1;
	}
	
	const CGRect parentFrame = parentView.frame;
	const CGFloat yOrigin = parentFrame.size.height - ((kToastHeight + kToastGap) * (toastsInParent + 1));
	const CGRect selfFrame = CGRectMake(parentFrame.origin.x + kToastMargin, yOrigin, parentFrame.size.width - (kToastMargin * 2.), kToastHeight);

	TKToastView *const toast = [[TKToastView alloc] initWithFrame:selfFrame];
	toast.text = text;
	toast.removeOnHide = YES;
	
	[toast showInView:parentView withDuration:duration];
}

@end
