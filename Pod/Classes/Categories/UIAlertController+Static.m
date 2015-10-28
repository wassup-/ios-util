//
//  UIAlertController+Static.m
//  iOS-util
//
//  Created by Tom Knapen on 31/07/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import "UIAlertController+Static.h"

@implementation UIAlertController (Static)

+(instancetype)dw_alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle andActions:(NSArray *)actions {
	UIAlertController *const controller = [self alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
	for(UIAlertAction *action in actions) {
		[controller addAction:action];
	}
	return controller;
}

@end
