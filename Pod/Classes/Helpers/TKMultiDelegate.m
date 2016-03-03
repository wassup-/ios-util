//
//  TKMultiDelegate.m
//  Pods
//
//  Created by Tom Knapen on 03/03/16.
//
//

#import "TKMultiDelegate.h"

@interface TKMultiDelegate ()

@property (nonatomic, strong) NSPointerArray *delegates;

@end

@implementation TKMultiDelegate

#pragma mark -

+(instancetype)delegateWithDelegates:(NSArray<id> *)delegates {
	TKMultiDelegate *instance = [self new];
	for(id delegate in delegates) {
		if(delegate) {
			[instance addDelegate:delegate];
		}
	}
	return instance;
}

#pragma mark - NSObject

-(instancetype)init {
	self = [super init];
	self.delegates = [NSPointerArray weakObjectsPointerArray];
	return self;
}

#pragma mark - Passthrough

-(BOOL)respondsToSelector:(SEL)aSelector {
	if([super respondsToSelector:aSelector]) {
		return YES;
	}
	
	for(id delegate in self.delegates) {
		if(delegate && [delegate respondsToSelector:aSelector]) {
			return YES;
		}
	}
	
	return NO;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
	if(signature) {
		return signature;
	}
	
	[self.delegates compact];
	
	for(id delegate in self.delegates) {
		if(!delegate) {
			continue;
		}
		
		signature = [delegate methodSignatureForSelector:aSelector];
		if(signature) {
			break;
		}
	}
	return signature;
}

-(void)forwardInvocation:(NSInvocation *)anInvocation {
	SEL selector = [anInvocation selector];
	for(id delegate in self.delegates) {
		if(delegate && [delegate respondsToSelector:selector]) {
			[anInvocation invokeWithTarget:delegate];
			return;
		}
	}
	[self doesNotRecognizeSelector:selector];
}

#pragma mark - Methods

-(void)addDelegate:(id)delegate {
	void *ptr = (__bridge void*)delegate;
	[self.delegates addPointer:ptr];
}

-(void)removeDelegate:(id)delegate {
	NSUInteger index = [self indexOfDelegate:delegate];
	if(index != NSNotFound) {
		[self.delegates removePointerAtIndex:index];
	}
}

#pragma mark - Helpers

-(NSUInteger)indexOfDelegate:(id)delegate {
	void *subject = (__bridge void*)delegate;
	for(NSUInteger i = 0; i < self.delegates.count; ++i) {
		void *candidate = [self.delegates pointerAtIndex:i];
		if(candidate == subject) {
			return i;
		}
	}
	return NSNotFound;
}

@end
