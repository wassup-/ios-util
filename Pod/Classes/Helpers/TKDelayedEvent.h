//
//  TKDelayedEvent.h
//  iOS-util
//
//  Created by Tom Knapen on 28/01/16.
//
//

@import Foundation;

@class TKDelayedEvent;
@class TKDelayedSignal;

typedef void(^TKDelayedEventHandler)(TKDelayedEvent *);

@interface TKDelayedSignal : NSObject

-(void)fire;

@property (nonatomic, assign, readonly) BOOL fired;

@end

@interface TKDelayedEvent : NSObject

-(TKDelayedSignal *)delay;
-(void)registerEventHandler:(TKDelayedEventHandler)eventHandler;

+(instancetype)event;

@end
