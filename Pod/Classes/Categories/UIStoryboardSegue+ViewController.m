//
//  UIStoryboardSegue+ViewController.m
//  SBB
//
//  Created by Tom Knapen on 03/12/15.
//  Copyright © 2015 Appwise. All rights reserved.
//

#import "UIStoryboardSegue+ViewController.h"

@implementation UIStoryboardSegue (ViewController)

-(UIViewController *)tk_destinationViewController {
	UIViewController *destination = self.destinationViewController;
	if([destination isKindOfClass:UINavigationController.class]) {
		UINavigationController *navCon = (UINavigationController *)destination;
		destination = navCon.viewControllers.firstObject;
	}
	return destination;
}

@end
