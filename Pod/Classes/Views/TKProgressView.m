#import "TKProgressView.h"

#import <Masonry/Masonry.h>

#import <objc/runtime.h>


static NSTimeInterval const kMinOperationDelay = .2;
static NSTimeInterval const kAnimationDuration = .15;

@protocol TKProgressInterface;

typedef void(^TKProgressOperationBlock)(id<TKProgressInterface> impl);

@protocol TKProgressInterface <NSObject>
@required
+(id<TKProgressInterface>)wrap:(id<TKProgressInterface>)impl;
-(id<TKProgressInterface>)unwrap;

-(void)queueOperation:(TKProgressOperationBlock)operation withPriority:(NSOperationQueuePriority)priority onView:(UIView *)view;

-(void)hide;

-(UIView *)view;
-(UIView *)contentView;

@end



@interface UIView (TKProgress)

-(id<TKProgressInterface>)tkProgressImpl;
-(void)setTkProgressImpl:(id<TKProgressInterface>)progressView;

@end

@implementation UIView (TKProgress)

-(id<TKProgressInterface>)tkProgressImpl {
	id<TKProgressInterface> impl = objc_getAssociatedObject(self, @selector(tkProgressImpl));
	if(!impl) {
		impl = (id<TKProgressInterface>)[TKProgress new];
		[self setTkProgressImpl:impl];
	}
	return impl;
}

-(void)setTkProgressImpl:(id<TKProgressInterface>)progressView {
	objc_setAssociatedObject(self, @selector(tkProgressImpl), progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end



@interface TKProgressOperation : NSOperation

@property (nonatomic, strong) UIView *view;
@property (nonatomic, copy) TKProgressOperationBlock block;

-(void)main;

+(instancetype)operationWithPriority:(NSOperationQueuePriority)priority andBlock:(TKProgressOperationBlock)block onView:(UIView *)view;

@end

@implementation TKProgressOperation
@synthesize block = _block;

+(instancetype)operationWithPriority:(NSOperationQueuePriority)priority andBlock:(TKProgressOperationBlock)block onView:(UIView *)view {
	TKProgressOperation *instance = [self new];
	instance.queuePriority = priority;
	instance.view = view;
	instance.block = block;
	return instance;
}

-(void)main {
	id<TKProgressInterface> impl = self.view.tkProgressImpl;
	self.block(impl);
}

@end



@interface TKProgress () <TKProgressInterface> {
	UIView *_contentView;
}

@property (nonatomic, strong) TKProgressOperation *operation;

@end

@implementation TKProgress

-(instancetype)init {
	if(self = [super init]) {
		UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		//		effectView.backgroundColor = UIColor.grayColor;
		[self addSubview:effectView];
		[effectView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
	}
	return self;
}

+(id<TKProgressInterface>)hideOnView:(UIView *)view {
	id<TKProgressInterface> impl = view.tkProgressImpl;
	[impl hide];
	return impl;
}

#pragma mark - TKProgressInterface

+(id<TKProgressInterface>)wrap:(id<TKProgressInterface>)impl {
	return impl;
}

-(id<TKProgressInterface>)unwrap {
	return self;
}

-(void)queueOperation:(TKProgressOperationBlock)block withPriority:(NSOperationQueuePriority)priority onView:(UIView *)view {
	TKProgressOperation *operation = [TKProgressOperation operationWithPriority: priority
																	   andBlock: block
																		 onView: view];
	self.operation = operation;
	[self performSelector: @selector(executeOperation)
			   withObject: nil
			   afterDelay: kMinOperationDelay];
}

-(void)executeOperation {
	dispatch_async(dispatch_get_main_queue(), ^{
		TKProgressOperation *op = self.operation;
		self.operation = nil;
		[op main];
	});
}

-(UIView *)view {
	return self;
}

-(UIView *)contentView {
	if(!_contentView) {
		UIView *containerView = [UIView new];
		[self addSubview:containerView];
		[containerView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(self);
			make.width.greaterThanOrEqualTo(self.view.mas_width).multipliedBy(.5);
			make.size.lessThanOrEqualTo(self).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
		}];
		containerView.layer.shadowColor = UIColor.blackColor.CGColor;
		containerView.layer.shadowOffset = CGSizeMake(2, 2);
		containerView.layer.shadowRadius = 5;
		containerView.layer.shadowOpacity = .6;

		_contentView = [UIView new];
		_contentView.backgroundColor = UIColor.whiteColor;
		_contentView.layer.cornerRadius = 5;
		_contentView.clipsToBounds = YES;
		[containerView addSubview:_contentView];
		[_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(_contentView.superview).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
		}];
	}
	return _contentView;
}

-(void)hide {
	[self queueOperation:^(id<TKProgressInterface> impl) {
		[impl.view removeFromSuperview];
	} withPriority:NSOperationQueuePriorityNormal onView:self.superview];
}

#pragma mark - UIView

-(void)didMoveToSuperview {
	[super didMoveToSuperview];

	self.frame = self.superview.bounds;
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - Helpers

-(void)beginVisualUpdates {
	[self layoutIfNeeded];
}

-(void)endVisualUpdates {
	[UIView animateWithDuration:kAnimationDuration animations:^{
		[self.contentView.superview layoutIfNeeded];
	}];
}

@end



@interface TKStatusProgress () <TKProgressInterface>

@property (nonatomic, strong) id<TKProgressInterface> inner;
@property (nonatomic, readonly) UILabel *statusLabel;

@end

@implementation TKStatusProgress
@synthesize statusLabel = _statusLabel;

#pragma mark - TKProgressInterface

+(id<TKProgressInterface>)wrap:(id<TKProgressInterface>)impl {
	TKStatusProgress *instance = nil;
	if(![impl isKindOfClass:self]) {
		instance = [self new];
		instance.inner = [impl unwrap];

		for(UIView *subview in instance.contentView.subviews) {
			[subview removeFromSuperview];
		}
	} else {
		instance = (TKStatusProgress *)impl;
	}
	return instance;
}

-(id<TKProgressInterface>)unwrap {
	return [self.inner unwrap];
}

-(void)queueOperation:(TKProgressOperationBlock)block withPriority:(NSOperationQueuePriority)priority onView:(UIView *)view {
	[self.unwrap queueOperation: block
				   withPriority: priority
						 onView: view];
}

-(UIView *)view {
	return [self.unwrap view];
}

-(UIView *)contentView {
	return [self.unwrap contentView];
}

-(void)hide {
	[self.unwrap hide];
}

#pragma mark -

+(id<TKProgressInterface>)showOnView:(UIView *)view withSuccess:(NSString *)success {
	id<TKProgressInterface> impl = view.tkProgressImpl;
	[impl queueOperation:^(id<TKProgressInterface> impl) {
		TKStatusProgress *instance = (TKStatusProgress *)[self wrap:impl];
		[view setTkProgressImpl:instance];
		[instance beginVisualUpdates];
		instance.statusLabel.textColor = UIColor.greenColor;
		instance.statusLabel.text = success;
		[view addSubview:instance.view];
		[instance endVisualUpdates];
	} withPriority:NSOperationQueuePriorityNormal onView: view];
	return impl;
}

+(id<TKProgressInterface>)showOnView:(UIView *)view withSuccess:(NSString *)success hideDelay:(NSTimeInterval)hideDelay {
	id<TKProgressInterface> impl = [self showOnView:view withSuccess:success];
	[impl queueOperation:^(id<TKProgressInterface> impl) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[impl hide];
		});
	} withPriority:NSOperationQueuePriorityNormal onView:view];
	return impl;
}

+(id<TKProgressInterface>)showOnView:(UIView *)view withError:(NSString *)error {
	id<TKProgressInterface> impl = view.tkProgressImpl;
	[impl queueOperation:^(id<TKProgressInterface> impl) {
		TKStatusProgress *instance = (TKStatusProgress *)[self wrap:impl];
		[view setTkProgressImpl:instance];
		[instance beginVisualUpdates];
		instance.statusLabel.textColor = UIColor.redColor;
		instance.statusLabel.text = error;
		[view addSubview:instance.view];
		[instance endVisualUpdates];
	} withPriority:NSOperationQueuePriorityNormal onView: view];
	return impl;
}

+(id<TKProgressInterface>)showOnView:(UIView *)view withError:(NSString *)error hideDelay:(NSTimeInterval)hideDelay {
	id<TKProgressInterface> impl = [self showOnView:view withError:error];
	[impl queueOperation:^(id<TKProgressInterface> impl) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[impl hide];
		});
	} withPriority:NSOperationQueuePriorityNormal onView:view];
	return impl;
}

#pragma mark - Properties

-(UILabel *)statusLabel {
	if(!_statusLabel) {
		_statusLabel = [UILabel new];
		_statusLabel.textAlignment = NSTextAlignmentCenter;
		_statusLabel.numberOfLines = 2;
		[self.contentView addSubview:_statusLabel];
		[_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(_statusLabel.superview.mas_leading).with.offset(16);
			make.trailing.equalTo(_statusLabel.superview.mas_trailing).with.offset(-16);
			make.top.equalTo(_statusLabel.superview.mas_top).with.offset(16);
			make.bottom.equalTo(_statusLabel.superview.mas_bottom).with.offset(-16);
		}];
	}
	return _statusLabel;
}

@end



@interface TKDeterminateProgress () <TKProgressInterface>

@property (nonatomic, strong) id<TKProgressInterface> inner;

@property (nonatomic, readonly) UIProgressView *progressView;
@property (nonatomic, readonly) UILabel *messageLabel;

@end

@implementation TKDeterminateProgress
@synthesize progressView = _progressView;
@synthesize messageLabel = _messageLabel;

#pragma mark - TKProgressInterface

+(id<TKProgressInterface>)wrap:(id<TKProgressInterface>)impl {
	TKDeterminateProgress *instance = nil;
	if(![impl isKindOfClass:self]) {
		instance = [self new];
		instance.inner = [impl unwrap];

		for(UIView *subview in instance.contentView.subviews) {
			[subview removeFromSuperview];
		}
	} else {
		instance = (TKDeterminateProgress *)impl;
	}
	return instance;
}

-(id<TKProgressInterface>)unwrap {
	return [self.inner unwrap];
}

-(void)queueOperation:(TKProgressOperationBlock)block withPriority:(NSOperationQueuePriority)priority onView:(UIView *)view {
	[self.unwrap queueOperation: block
				   withPriority: priority
						 onView: view];
}

-(UIView *)view {
	return [self.unwrap view];
}

-(UIView *)contentView {
	return [self.unwrap contentView];
}

-(void)hide {
	[self.unwrap hide];
}

#pragma mark -

+(id<TKProgressInterface>)showOnView:(UIView *)view withProgress:(CGFloat)progress {
	return [self showOnView: view
				withMessage: nil
				andProgress: progress];
}

+(id<TKProgressInterface>)showOnView:(UIView *)view withMessage:(NSString *)message andProgress:(CGFloat)progress {
	id<TKProgressInterface> impl = view.tkProgressImpl;
	[impl queueOperation:^(id<TKProgressInterface> impl) {
		TKDeterminateProgress *instance = (TKDeterminateProgress *)[self wrap:impl];
		[view setTkProgressImpl:instance];
		[instance beginVisualUpdates];
		instance.progressView.progress = progress;
		instance.messageLabel.text = message;
		[view addSubview:instance.view];
		[instance endVisualUpdates];
	} withPriority:NSOperationQueuePriorityNormal onView: view];
	return impl;
}

#pragma mark - Properties

-(UIProgressView *)progressView {
	if(!_progressView) {
		_progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
		[self.contentView addSubview:_progressView];
		[_progressView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(_progressView.superview.mas_top).with.offset(16);
			make.leading.equalTo(_progressView.superview.mas_leading).with.offset(16);
			make.trailing.equalTo(_progressView.superview.mas_trailing).with.offset(-16);
			make.bottom.equalTo(self.messageLabel.mas_top).with.offset(-16);
		}];
	}
	return _progressView;
}

-(UILabel *)messageLabel {
	if(!_messageLabel) {
		_messageLabel = [UILabel new];
		_messageLabel.textAlignment = NSTextAlignmentCenter;
		_messageLabel.numberOfLines = 2;
		[self.contentView addSubview:_messageLabel];
		[_messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(_messageLabel.superview.mas_leading).with.offset(16);
			make.trailing.equalTo(_messageLabel.superview.mas_trailing).with.offset(-16);
			make.bottom.equalTo(_messageLabel.superview.mas_bottom).with.offset(-16);
		}];
	}
	return _messageLabel;
}

@end



@interface TKIndeterminateProgress () <TKProgressInterface>

@property (nonatomic, strong) id<TKProgressInterface> inner;

@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, readonly) UILabel *messageLabel;

@end

@implementation TKIndeterminateProgress
@synthesize activityIndicator = _activityIndicator;
@synthesize messageLabel = _messageLabel;

#pragma mark - TKProgressInterface

+(id<TKProgressInterface>)wrap:(id<TKProgressInterface>)impl {
	TKIndeterminateProgress *instance = nil;
	if(![impl isKindOfClass:self]) {
		instance = [self new];
		instance.inner = [impl unwrap];

		for(UIView *subview in instance.contentView.subviews) {
			[subview removeFromSuperview];
		}
	} else {
		instance = (TKIndeterminateProgress *)impl;
	}
	return instance;
}

-(id<TKProgressInterface>)unwrap {
	return [self.inner unwrap];
}

-(void)queueOperation:(TKProgressOperationBlock)block withPriority:(NSOperationQueuePriority)priority onView:(UIView *)view {
	[self.unwrap queueOperation: block
				   withPriority: priority
						 onView: view];
}

-(UIView *)view {
	return [self.unwrap view];
}

-(UIView *)contentView {
	return [self.unwrap contentView];
}

-(void)hide {
	[self.unwrap hide];
}

#pragma mark -

+(id<TKProgressInterface>)showOnView:(UIView *)view {
	return [self showOnView: view
				withMessage: nil];
}

+(id<TKProgressInterface>)showOnView:(UIView *)view withMessage:(NSString *)message {
	id<TKProgressInterface> impl = view.tkProgressImpl;
	[impl queueOperation:^(id<TKProgressInterface> impl) {
		TKIndeterminateProgress *instance = (TKIndeterminateProgress *)[self wrap:impl];
		[view setTkProgressImpl:instance];
		[instance beginVisualUpdates];
		[instance.activityIndicator startAnimating];
		instance.messageLabel.text = message;
		[view addSubview:instance.view];
		[instance endVisualUpdates];
	} withPriority:NSOperationQueuePriorityNormal onView:view];
	return impl;
}

#pragma mark - Properties

-(UIActivityIndicatorView *)activityIndicator {
	if(!_activityIndicator) {
		_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self.contentView addSubview:_activityIndicator];
		[_activityIndicator mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(_activityIndicator.superview.mas_top).with.offset(16);
			make.leading.equalTo(_activityIndicator.superview.mas_leading).with.offset(16);
			make.trailing.equalTo(_activityIndicator.superview.mas_trailing).with.offset(-16);
			make.bottom.equalTo(self.messageLabel.mas_top).with.offset(-16);
		}];
	}
	return _activityIndicator;
}

-(UILabel *)messageLabel {
	if(!_messageLabel) {
		_messageLabel = [UILabel new];
		_messageLabel.textAlignment = NSTextAlignmentCenter;
		_messageLabel.numberOfLines = 2;
		[self.contentView addSubview:_messageLabel];
		[_messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(_messageLabel.superview.mas_leading).with.offset(16);
			make.trailing.equalTo(_messageLabel.superview.mas_trailing).with.offset(-16);
			make.bottom.equalTo(_messageLabel.superview.mas_bottom).with.offset(-16);
		}];
	}
	return _messageLabel;
}

@end
