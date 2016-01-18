//
//  UIView+Recurse.h
//  iOS-util
//
//  Created by Tom Knapen on 11/08/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Recurse)

-(BOOL)isSuperOfViewOfClass:(Class)kind;
-(UIView *)firstDescendantOfClass:(Class)kind;
-(UIView *)lastDescendantOfClass:(Class)kind;

-(BOOL)isDescendantOfViewOfClass:(Class)kind;
-(UIView *)firstSuperOfClass:(Class)kind;
-(UIView *)lastSuperOfClass:(Class)kind;

-(BOOL)isSuperOfViewOfClassWithName:(NSString *)name;
-(UIView *)firstDescendantOfClassWithName:(NSString *)name;
-(UIView *)lastDescendantOfClassWithName:(NSString *)name;

-(BOOL)isDescendantOfViewOfClassWithName:(NSString *)name;
-(UIView *)firstSuperOfClassWithName:(NSString *)name;
-(UIView *)lastSuperOfClassWithName:(NSString *)name;

@end
