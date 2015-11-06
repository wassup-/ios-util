//
//  NSNotificationCenter+Shared.m
//  iOS-util
//
//  Created by Tom Knapen on 06/11/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import "NSNotificationCenter+Shared.h"

@implementation NSNotificationCenter (Shared)

+(instancetype)shared {
	static NSNotificationCenter *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [self defaultCenter];
	});
	return instance;
}

@end
