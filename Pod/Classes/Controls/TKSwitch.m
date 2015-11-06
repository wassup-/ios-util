//
//  TKSwitch.m
//  iOS-util
//
//  Created by Tom Knapen on 21/09/15.
//  Copyright © 2015 Tom Knapen. All rights reserved.
//

#import "TKSwitch.h"

@interface TKSwitch () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *titleLabelsContentView;
@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) UILabel *rightTitleLabel;

@property (nonatomic, strong) UIView *selectedTitleLabelsContentView;
@property (nonatomic, strong) UILabel *selectedLeftTitleLabel;
@property (nonatomic, strong) UILabel *selectedRightTitleLabel;

@property (nonatomic, strong) UIView *selectedBackgroundView;

@property (nonatomic, strong) UIView *titleMaskView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) CGRect initialSelectedBackgroundViewFrame;

@end

static NSString * const kObserverPath = @"selectedBackgroundView.frame";

typedef NS_ENUM(NSUInteger, SwitchSide) {
	SwitchSideNone,
	SwitchSideLeft,
	SwitchSideRight,
};

CGRect CGMakeRect(CGPoint origin, CGSize size) {
	return CGRectMake(origin.x, origin.y, size.width, size.height);
}

@implementation TKSwitch

@synthesize selectedIndex = _selectedIndex;

+(void)makeRoundedCorners:(UIView*)view {
	view.layer.cornerRadius = view.bounds.size.height / 2.;
}

-(UIView*)createNewView {
	UIView *const newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
	return newView;
}

-(UILabel*)createNewTitleLabel:(SwitchSide)side {
	const CGFloat offsetX = (side == SwitchSideLeft) ? 0 : (self.bounds.size.width / 2.);
	UILabel *const label = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 0, self.bounds.size.width / 2., self.bounds.size.height)];
	label.lineBreakMode = NSLineBreakByTruncatingTail;
	label.textAlignment = NSTextAlignmentCenter;
	label.enabled = YES;
	label.highlighted = NO;
	return label;
}

-(void)initialize {
	[self.class makeRoundedCorners:self];
	
	// Springs
	self.animationDuration = .3;
	self.animationSpringDamping = .75;
	self.animationInitialSpringVelocity = 0.;
	
	self.selectedBackgroundInset = 2.;
	
	// Views
	self.selectedBackgroundView = [self createNewView];
	[self.class makeRoundedCorners:self.selectedBackgroundView];
	[self addSubview:self.selectedBackgroundView];
	
	self.titleMaskView = [self createNewView];
	[self.class makeRoundedCorners:self.titleMaskView];
	self.titleMaskView.backgroundColor = UIColor.blackColor;
	
	self.titleLabelsContentView = [self createNewView];
	self.leftTitleLabel = [self createNewTitleLabel:SwitchSideLeft];
	self.rightTitleLabel = [self createNewTitleLabel:SwitchSideRight];
	
	[self.titleLabelsContentView addSubview:self.leftTitleLabel];
	[self.titleLabelsContentView addSubview:self.rightTitleLabel];
	[self addSubview:self.titleLabelsContentView];
	
	self.selectedTitleLabelsContentView = [self createNewView];
	self.selectedLeftTitleLabel = [self createNewTitleLabel:SwitchSideLeft];
	self.selectedRightTitleLabel = [self createNewTitleLabel:SwitchSideRight];
	
	[self.selectedTitleLabelsContentView addSubview:self.selectedLeftTitleLabel];
	[self.selectedTitleLabelsContentView addSubview:self.selectedRightTitleLabel];
	[self addSubview:self.selectedTitleLabelsContentView];
	
	self.selectedTitleLabelsContentView.layer.mask = self.titleMaskView.layer;
	
	// Default colors
	self.selectedBackgroundColor = UIColor.whiteColor;
	self.titleColor = UIColor.whiteColor;
	self.selectedTitleColor = UIColor.whiteColor;
	
	// Gestures
	UITapGestureRecognizer *const tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	[self addGestureRecognizer:tapGesture];
	
	UIPanGestureRecognizer *const panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
	[self addGestureRecognizer:panGesture];
	
	// Observers
	[self addObserver:self forKeyPath:kObserverPath options:NSKeyValueObservingOptionNew context:nil];
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

-(void)dealloc {
	[self removeObserver:self forKeyPath:kObserverPath context:nil];
}

-(void)layoutSubviews {
	[super layoutSubviews];
	
	const CGFloat selectedBackgroundWidth = (self.bounds.size.width / 2.) - (self.selectedBackgroundInset * 2.);
	self.selectedBackgroundView.frame = CGRectMake(self.selectedBackgroundInset + (self.selectedIndex * (selectedBackgroundWidth + self.selectedBackgroundInset * 2.)),
												   self.selectedBackgroundInset,
												   selectedBackgroundWidth,
												   self.bounds.size.height - (self.selectedBackgroundInset * 2.));
	
	const CGFloat titleLabelMaxWidth = selectedBackgroundWidth;
	const CGFloat titleLabelMaxHeight = self.bounds.size.height - (self.selectedBackgroundInset * 2.);
	
	{ // LEFT
		const CGSize TitleLabelSize = CGSizeMake(titleLabelMaxWidth, titleLabelMaxHeight);

		CGPoint TitleLabelOrigin = CGPointMake(floor((self.bounds.size.width / 2.) - TitleLabelSize.width) / 2.,
											   floor(self.bounds.size.height - TitleLabelSize.height) / 2.);
		
		CGRect TitleLabelFrame = CGMakeRect(TitleLabelOrigin, TitleLabelSize);
		self.leftTitleLabel.frame = TitleLabelFrame;
		self.selectedLeftTitleLabel.frame = TitleLabelFrame;
	}
	
	{ // RIGHT
		const CGSize TitleLabelSize = CGSizeMake(titleLabelMaxWidth, titleLabelMaxHeight);
		
		CGPoint TitleLabelOrigin = CGPointMake(floor((self.bounds.size.width / 2.) + (self.bounds.size.width / 2. - TitleLabelSize.width) / 2.),
											   floor(self.bounds.size.height - TitleLabelSize.height) / 2.);
		
		CGRect TitleLabelFrame = CGMakeRect(TitleLabelOrigin, TitleLabelSize);
		self.rightTitleLabel.frame = TitleLabelFrame;
		self.selectedRightTitleLabel.frame = TitleLabelFrame;
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
	if([keyPath isEqualToString:kObserverPath]) {
		self.titleMaskView.frame = self.selectedBackgroundView.frame;
	}
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if(gestureRecognizer == self.panGesture) {
		return CGRectContainsPoint(self.selectedBackgroundView.frame, [gestureRecognizer locationInView:self]);
	}
	return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

#pragma mark - Actions

-(void)tapped:(UITapGestureRecognizer*)gesture {
	const CGPoint location = [gesture locationInView:self];
	if(location.x < self.bounds.size.width / 2.) {
		self.selectedIndex = 0;
	} else {
		self.selectedIndex = 1;
	}
}

-(void)pan:(UIPanGestureRecognizer*)gesture {
	if(gesture.state == UIGestureRecognizerStateBegan) {
		self.initialSelectedBackgroundViewFrame = self.selectedBackgroundView.frame;
	} else if(gesture.state == UIGestureRecognizerStateChanged) {
		CGRect frame = self.initialSelectedBackgroundViewFrame;
		frame.origin.x += [gesture translationInView:self].x;
		frame.origin.x = fmax(fmin(frame.origin.x, self.bounds.size.width - self.selectedBackgroundInset - frame.size.width), self.selectedBackgroundInset);
		self.selectedBackgroundView.frame = frame;
	} else if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled) {
		const CGPoint center = self.selectedBackgroundView.center;
		const CGFloat velocityX = [gesture velocityInView:self].x;
		if(velocityX > 500.) {
			self.selectedIndex = 1;
		} else if(velocityX < -500.) {
			self.selectedIndex = 0;
		} else if(center.x >= (self.bounds.size.width / 2.)) {
			self.selectedIndex = 1;
		} else if(center.x < (self.bounds.size.width / 2.)) {
			self.selectedIndex = 0;
		}
	}
}

#pragma mark - Properties

-(NSString *)leftTitle {
	return self.leftTitleLabel.text;
}

-(void)setLeftTitle:(NSString *)leftTitle {
	self.leftTitleLabel.text = leftTitle;
	self.selectedLeftTitleLabel.text = leftTitle;
}

-(NSString *)rightTitle {
	return self.rightTitleLabel.text;
}

-(void)setRightTitle:(NSString *)rightTitle {
	self.rightTitleLabel.text = rightTitle;
	self.selectedRightTitleLabel.text = rightTitle;
}

-(UIColor *)selectedBackgroundColor {
	return self.selectedBackgroundView.backgroundColor;
}

-(void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
	self.selectedBackgroundView.backgroundColor = selectedBackgroundColor;
}

-(UIColor *)titleColor {
	return self.leftTitleLabel.tintColor;
}

-(void)setTitleColor:(UIColor *)titleColor {
	self.leftTitleLabel.tintColor = titleColor;
	self.rightTitleLabel.tintColor = titleColor;
	
	self.leftTitleLabel.textColor = titleColor;
	self.rightTitleLabel.textColor = titleColor;
}

-(UIColor *)selectedTitleColor {
	return self.selectedLeftTitleLabel.tintColor;
}

-(void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
	self.selectedLeftTitleLabel.tintColor = selectedTitleColor;
	self.selectedRightTitleLabel.tintColor = selectedTitleColor;
	
	self.selectedLeftTitleLabel.textColor = selectedTitleColor;
	self.selectedRightTitleLabel.textColor = selectedTitleColor;
}

-(UIFont *)titleFont {
	return self.leftTitleLabel.font;
}

-(void)setTitleFont:(UIFont *)titleFont {
	self.leftTitleLabel.font = titleFont;
	self.rightTitleLabel.font = titleFont;
	
	self.selectedLeftTitleLabel.font = titleFont;
	self.selectedRightTitleLabel.font = titleFont;
}

-(NSInteger)selectedIndex {
	return _selectedIndex;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex {
	_selectedIndex = selectedIndex;
	
	[self selectedIndexWillChange:selectedIndex];
	
	[UIView animateWithDuration: self.animationDuration
						  delay: 0.
		 usingSpringWithDamping: self.animationSpringDamping
		  initialSpringVelocity: self.animationInitialSpringVelocity
						options: (UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut)
					 animations: ^{
						 [self layoutSubviews];
					 } completion:^(BOOL finished) {
						 if(finished) {
							 [self sendActionsForControlEvents:UIControlEventValueChanged];
							 [self selectedIndexChanged:_selectedIndex];
						 }
					 }];
}

-(void)selectedIndexWillChange:(NSInteger)selectedIndex {
	if([self.delegate respondsToSelector:@selector(selectedIndexWillChange:toIndex:)])
		[self.delegate selectedIndexWillChange:self toIndex:selectedIndex];
}

-(void)selectedIndexChanged:(NSInteger)selectedIndex {
	[self.delegate selectedIndexChanged:self selectedIndex:selectedIndex];
}

@end
