//
//  UIView+Recurse.h
//  iOS-util
//
//  Created by Tom Knapen on 11/08/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Recurse)

-(BOOL)isDescendantOfViewOfKind:(Class)kind;
-(UIView *)firstSuperOfKind:(Class)kind;
-(UIView *)lastSuperOfKind:(Class)kind;

@end
