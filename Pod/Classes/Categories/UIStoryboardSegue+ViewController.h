//
//  UIStoryboardSegue+ViewController.h
//  SBB
//
//  Created by Tom Knapen on 03/12/15.
//  Copyright © 2015 Appwise. All rights reserved.
//

@import UIKit;

@interface UIStoryboardSegue (ViewController)

- (UIViewController * __nullable)tk_destinationViewController;
- (UIViewController * __nullable)destinationViewControllerOfKind:(__nonnull Class)kind;

@end
