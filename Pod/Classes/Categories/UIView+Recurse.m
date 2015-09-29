//
//  UIView+Recurse.m
//  iOS-util
//
//  Created by Tom Knapen on 11/08/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import "UIView+Recurse.h"

@implementation UIView (Recurse)

-(BOOL)isDescendantOfViewOfKind:(Class)kind {
	UIView *view = self;
	while(view) {
		if([view isKindOfClass:kind])
			return YES;
		view = view.superview;
	}
	return NO;
}

-(UIView *)firstSuperOfKind:(Class)kind {
	UIView *view = self;
	while(view) {
		if([view isKindOfClass:kind])
			return view;
		view = view.superview;
	}
	return nil;
}

-(UIView *)lastSuperOfKind:(Class)kind {
	UIView *last = nil;
	UIView *view = self;
	while(view) {
		if([view isKindOfClass:kind])
		   last = view;
		view = view.superview;
	}
	return last;
}

@end
