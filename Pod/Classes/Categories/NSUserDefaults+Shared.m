//
//  NSUserDefaults.m
//  iOS-util
//
//  Created by Tom Knapen on 06/11/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import "NSUserDefaults+Shared.h"

@implementation NSUserDefaults (Shared)

+(instancetype)shared {
	static NSUserDefaults *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [self standardUserDefaults];
	});
	return instance;
}

@end
