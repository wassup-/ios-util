//
//  UIView+Recurse.h
//  iOS-util
//
//  Created by Tom Knapen on 11/08/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

@import UIKit;

@interface UIView (Recurse)

-(BOOL)isSuperOfClass:(__nonnull Class)kind;
-( UIView * _Nullable )firstDescendantOfClass:(__nonnull Class)kind;
-(UIView * __nullable)lastDescendantOfClass:(__nonnull Class)kind;

-(BOOL)isDescendantOfClass:(__nonnull Class)kind;
-(UIView * __nullable)firstSuperOfClass:(__nonnull Class)kind;
-(UIView * __nullable)lastSuperOfClass:(__nonnull Class)kind;

-(BOOL)isSuperOfClassWithName:(NSString * __nonnull)name;
-(UIView * __nullable)firstDescendantOfClassWithName:(NSString * __nonnull)name;
-(UIView * __nullable)lastDescendantOfClassWithName:(NSString * __nonnull)name;

-(BOOL)isDescendantOfClassWithName:(NSString * __nonnull)name;
-(UIView * __nullable)firstSuperOfClassWithName:(NSString * __nonnull)name;
-(UIView * __nullable)lastSuperOfClassWithName:(NSString * __nonnull)name;

@end
