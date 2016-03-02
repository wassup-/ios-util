#import "TKProgressView.h"

#import <objc/runtime.h>


typedef void(^TKProgressOperationBlock)(TKProgress *progress);

@protocol TKProgressInterface
@required
+(id<TKProgressInterface>)wrap:(id<TKProgressInterface>)progress;
-(id<TKProgressInterface>)unwrap;
-(void)queueOperation:(TKProgressOperationBlock) withPriority:(NSInteger)priority;
@end



static char kAssociatedProgressViewKey;

@interface UIView (TKProgress)

-(TKProgress *)tkProgressView;
-(void)setTkProgressView:(TKProgress *)progressView;

@end

@implementation UIView (TKProgress)

-(TKProgress *)tkProgressView {
    return objc_getAssociatedObject(self, &kAssociatedProgressViewKey);
}

-(void)setTkProgressView:(TKProgress *)progressView {
    objc_setAssociatedObject(self, &kAssociatedProgressViewKey, progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end



@interface TKProgressOperation : NSObject

@property (nonatomic, weak) TKProgress *progress;
@property (nonatomic, copy) TKProgressOperationBlock block;

-(void)main;

+(instancetype)operationWithPriority:(NSInteger)priority progress:(TKProgress *)progress andBlock:(TKProgressOperationBlock)block;

@end

@implementation TKProgressOperation
@synthesize progress = _progress;
@synthesize block = _block;

+(instancetype)operationWithPriority:(NSInteger)priority progress:(TKProgress *)progress andBlock:(TKProgressOperationBlock)block {
    TKProgressOperation *instance = [self new];
    self->_priority = priority;
    self->_progress = progress;
    self->_block = block;
    return self;
}

-(void)main {
    self.operation(self.progress);
}

@end



@interface TKProgress () <TKProgressInterface>

@property (nonatomic, readonly) NSOperationQueue *operationQueue;

@end

@implementation TKProgress

-(instancetype)unwrap {
    return self;
}

-(void)queueOperation:(TKProgressOperationBlock)block withPriority:(NSInteger)priority {
    TKProgressOperation *operation = [TKProgressOperation operationWithPriority: priority
                                                                       progress: self
                                                                       andBlock: block];
    [self.queue addOperation:operation];
}

@end



@interface TKDeterminateProgress () <TKProgressInterface>

@property (nonatomic, weak) TKProgress *inner;

@end

@implementation TKDeterminateProgress

#pragma mark - TKProgressInterface

-(TKProgress *)unwrap {
    return [self.inner unwrap];
}

-(void)queueOperation:(TKProgressOperationBlock)block withPriority:(NSInteger)priority {
    [self.unwrap queueOperation: block
                   withPriority: priority];
}

#pragma mark -

+(instancetype)wrap:(TKProgress *)progress {
    TKDeterminateProgress *instance = nil;
    if(![progress isKindOfClass:TKDeterminateProgress.class]) {
        instance = [TKDeterminateProgress new];
        instance.inner = [progress unwrap];
    } else {
        instance = progress;
    }
    return instance;
}

+(instancetype)showOnView:(UIView *)view withProgress:(CGFloat)progress {
    return [self showOnView: view
                withMessage: nil
                andProgress: progress];
}

+(instancetype)showOnView:(UIView *)view withMessage:(NSString *)message andProgress:(CGFloat)progress {
    TKProgress *progressView = view.tkProgressView;
    TKDeterminateProgress *instance = [self wrap:progressView];
    // TODO
    if(message.length > 0) {

    } else {

    }
    [view setTkProgressView:instance];
    return instance;
}

@end



@interface TKIndeterminateProgress () <TKProgressInterface>

@property (nonatomic, weak) TKProgress *inner;

@end

@implementation TKIndeterminateProgress

#pragma mark - TKProgressInterface

-(TKProgress *)unwrap {
    return [self.inner unwrap];
}

-(void)queueOperation:(TKProgressOperationBlock)block withPriority:(NSInteger)priority {
    [self.unwrap queueOperation: block
                   withPriority: priority];
}

@end
