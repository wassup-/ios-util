//
//  TKDelayedEvent.m
//  iOS-util
//
//  Created by Tom Knapen on 28/01/16.
//
//

#import "TKDelayedEvent.h"

@interface TKDelayedSignal ()

@property (nonatomic, weak) TKDelayedEvent *event;
@property (nonatomic, assign) NSUInteger index;

+(instancetype)signalWithEvent:(TKDelayedEvent *)event andIndex:(NSUInteger)index;

@end

@interface TKDelayedEvent ()

@property (nonatomic, strong) NSMutableArray<NSNumber *> *flags;
@property (nonatomic, strong) NSMutableArray<TKDelayedEventHandler> *handlers;

-(void)setFired:(NSUInteger)index;

@end

@implementation TKDelayedSignal

+(instancetype)signalWithEvent:(TKDelayedEvent *)event andIndex:(NSUInteger)index {
	TKDelayedSignal *instance = TKDelayedSignal.new;
	instance.event = event;
	instance.index = index;
	instance->_fired = NO;
	return instance;
}

-(void)fire {
	_fired = YES;
	[self.event setFired:self.index];
}

@end

@implementation TKDelayedEvent

+(instancetype)event {
	return [TKDelayedEvent new];
}

-(TKDelayedSignal *)delay {
	TKDelayedSignal *signal = [TKDelayedSignal signalWithEvent:self andIndex:self.flags.count];
	[self.flags addObject:@(NO)];
	return signal;
}

-(void)registerEventHandler:(TKDelayedEventHandler)eventHandler {
	[self.handlers addObject:eventHandler];
}

-(void)setFired:(NSUInteger)index {
	self.flags[index] = @(YES);
	[self notifyHandlers];
}

-(void)notifyHandlers {
	for(NSNumber *flag in self.flags) {
		if(![flag boolValue]) return;
	}
	for(TKDelayedEventHandler handler in self.handlers) {
		handler(self);
	}
}

#pragma mark - Properties

-(NSMutableArray<NSNumber *> *)flags {
	if(!_flags) {
		_flags = [NSMutableArray new];
	}
	return _flags;
}

-(NSMutableArray<TKDelayedEventHandler> *)handlers {
	if(!_handlers) {
		_handlers = [NSMutableArray new];
	}
	return _handlers;
}

@end

