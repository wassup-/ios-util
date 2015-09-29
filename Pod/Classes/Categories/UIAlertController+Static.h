//
//  UIAlertController+Static.h
//  iOS-util
//
//  Created by Tom Knapen on 31/07/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertController (Static)

+(instancetype)dw_alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle andActions:(NSArray *)actions;

@end
