//
//  UIStoryboardSegue+ViewController.m
//  SBB
//
//  Created by Tom Knapen on 03/12/15.
//  Copyright © 2015 Appwise. All rights reserved.
//

#import "UIStoryboardSegue+ViewController.h"

@implementation UIStoryboardSegue (ViewController)

+ (UIViewController *)nextViewControllerIn:(UIViewController *)vc ofKind:(Class)kind {
	if ([vc isKindOfClass:UINavigationController.class]) {
		UINavigationController *nc = (UINavigationController *)vc;
		for (UIViewController *candidate in nc.viewControllers) {
			if ([candidate isKindOfClass:kind]) {
				return candidate
			}
		}
		return nc.visibleViewController;
	}
	else if ([vc isKindOfClass:UITabBarController.class]) {
		UITabBarController *tc = (UITabBarController *)vc;
		for (UIViewController *candidate in tc.viewControllers) {
			if ([candidate isKindOfClass:kind]) {
				return candidate;
			}
		}
		return tc.selectedViewController;
	}
	else if ([vc isKindOfClass:UIPageViewController.class]) {
		UIPageViewController *pc = (UIPageViewController *)vc;
		for (UIViewController *candidate in pc.viewControllers) {
			if ([candidate isKindOfClass:kind]) {
				return candidate;
			}
		}
		return pc.presentedViewController;
	}
	
	return nil;
}

- (UIViewController *)tk_destinationViewController {
	UIViewController *destination = self.destinationViewController;
	if ([destination isKindOfClass:UINavigationController.class]) {
		UINavigationController *navCon = (UINavigationController *)destination;
		destination = navCon.viewControllers.firstObject;
	}
	return destination;
}

- (UIViewController *)destinationViewControllerOfKind:(Class)kind {
	UIViewController *destination = self.destinationViewController;
	while (![destination isKindOfClass:kind]) {
		destination = [self.class nextViewControllerIn:destination ofKind:kind];
	}
	return destination;
}

@end
