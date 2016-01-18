//
//  UIView+Recurse.m
//  iOS-util
//
//  Created by Tom Knapen on 11/08/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import "UIView+Recurse.h"

@implementation UIView (Recurse)

-(BOOL)isSuperOfViewOfClass:(Class)kind {
	return [self firstDescendantOfClass:kind] != nil;
}

-(UIView *)firstDescendantOfClass:(Class)kind {
	for(UIView *subview in self.subviews) {
		if([subview isKindOfClass:kind]) {
			return subview;
		}
		UIView *subsubview = [subview firstDescendantOfClass:kind];
		if(subsubview) return subsubview;
	}
	return nil;
}

-(UIView *)lastDescendantOfClass:(Class)kind {
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

-(BOOL)isDescendantOfViewOfClass:(Class)kind {
	UIView *view = self;
	while(view) {
		if([view isKindOfClass:kind])
			return YES;
		view = view.superview;
	}
	return NO;
}

-(UIView *)firstSuperOfClass:(Class)kind {
	UIView *view = self;
	while(view) {
		if([view isKindOfClass:kind])
			return view;
		view = view.superview;
	}
	return nil;
}

-(UIView *)lastSuperOfClass:(Class)kind {
	UIView *last = nil;
	UIView *view = self;
	while(view) {
		if([view isKindOfClass:kind])
		   last = view;
		view = view.superview;
	}
	return last;
}


-(BOOL)isSuperOfViewOfClassWithName:(NSString *)name {
	return [self isSuperOfViewOfClass:NSClassFromString(name)];
}

-(UIView *)firstDescendantOfClassWithName:(NSString *)name {
	return [self firstDescendantOfClass:NSClassFromString(name)];
}

-(UIView *)lastDescendantOfClassWithName:(NSString *)name {
	return [self lastDescendantOfClass:NSClassFromString(name)];
}


-(BOOL)isDescendantOfViewOfClassWithName:(NSString *)name {
	return [self isDescendantOfViewOfClass:NSClassFromString(name)];
}

-(UIView *)firstSuperOfClassWithName:(NSString *)name {
	return [self firstSuperOfClass:NSClassFromString(name)];
}

-(UIView *)lastSuperOfClassWithName:(NSString *)name {
	return [self lastSuperOfClass:NSClassFromString(name)];
}

@end
