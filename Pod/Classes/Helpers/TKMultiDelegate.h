//
//  TKMultiDelegate.h
//  iOS-util
//
//  Created by Tom Knapen on 03/03/16.
//
//

@import Foundation;

@interface TKMultiDelegate : NSObject

-(void)addDelegate:(id)delegate;
-(void)removeDelegate:(id)delegate;

+(instancetype)delegateWithDelegates:(NSArray<id> *)delegates;

@end
