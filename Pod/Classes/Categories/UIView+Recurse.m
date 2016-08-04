//
//  UIView+Recurse.m
//  iOS-util
//
//  Created by Tom Knapen on 11/08/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import "UIView+Recurse.h"

@implementation UIView (Recurse)

-(BOOL)isSuperOfClass:(__nonnull Class)kind {
	return [self firstDescendantOfClass:kind] != nil;
}

-(UIView * __nullable)firstDescendantOfClass:(__nonnull Class)kind {
	for(UIView *subview in self.subviews) {
		if([subview isKindOfClass:kind]) {
			return subview;
		}
		UIView *subsubview = [subview firstDescendantOfClass:kind];
		if(subsubview) return subsubview;
	}
	return nil;
}

-(UIView * __nullable)lastDescendantOfClass:(__nonnull Class)kind {
	UIView *last = nil;
	for(UIView *subview in self.subviews) {
		if([subview isKindOfClass:kind]) {
			last = subview;
		}
		UIView *subsubview = [subview firstDescendantOfClass:kind];
		if(subsubview) last = subsubview;
	}
	return last;
}

-(BOOL)isDescendantOfClass:(__nonnull Class)kind {
	UIView *view = self;
	while(view) {
		if([view isKindOfClass:kind])
			return YES;
		view = view.superview;
	}
	return NO;
}

-(UIView * __nullable)firstSuperOfClass:(__nonnull Class)kind {
	UIView *view = self;
	while(view) {
		if([view isKindOfClass:kind])
			return view;
		view = view.superview;
	}
	return nil;
}

-(UIView * __nullable)lastSuperOfClass:(__nonnull Class)kind {
	UIView *last = nil;
	UIView *view = self;
	while(view) {
		if([view isKindOfClass:kind])
		   last = view;
		view = view.superview;
	}
	return last;
}


-(BOOL)isSuperOfClassWithName:(NSString * __nonnull)name {
	return [self isSuperOfClass:NSClassFromString(name)];
}

-(UIView * __nullable)firstDescendantOfClassWithName:(NSString * __nonnull)name {
	return [self firstDescendantOfClass:NSClassFromString(name)];
}

-(UIView * __nullable)lastDescendantOfClassWithName:(NSString * __nonnull)name {
	return [self lastDescendantOfClass:NSClassFromString(name)];
}


-(BOOL)isDescendantOfClassWithName:(NSString * __nonnull)name {
	return [self isDescendantOfClass:NSClassFromString(name)];
}

-(UIView * __nullable)firstSuperOfClassWithName:(NSString * __nonnull)name {
	return [self firstSuperOfClass:NSClassFromString(name)];
}

-(UIView * __nullable)lastSuperOfClassWithName:(NSString * __nonnull)name {
	return [self lastSuperOfClass:NSClassFromString(name)];
}

@end
