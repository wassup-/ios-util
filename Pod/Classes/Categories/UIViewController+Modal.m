//
//  UIViewController+Modal.m
//  iOS-util
//
//  Created by Tom Knapen on 08/03/16.
//  Copyright © 2016 Tom Knapen. All rights reserved.
//

#import "UIViewController+Modal.h"

@implementation UIViewController (Modal)

#pragma mark - UIPopoverPresentationControllerDelegate

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPopoverPresentationController *)controller {
	const CGRect sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds) - 2, CGRectGetMidY(self.view.bounds) - 2, 4, 4);
	controller.sourceRect = sourceRect;
	controller.sourceView = self.view;
	controller.permittedArrowDirections = 0;
	return UIModalPresentationNone;
}

#pragma mark - Helpers

-(void)presentViewController:(UIViewController *)controller asPopoverWithSize:(CGSize)size animated:(BOOL)animated {
	controller.modalPresentationStyle = UIModalPresentationPopover;
	controller.preferredContentSize = size;
	controller.popoverPresentationController.delegate = self;
	[self presentViewController: controller
					   animated: animated
					 completion: nil];
}

#pragma mark -

-(BOOL)isBeingPresentedModally {
	/**
	 * source: https://stackoverflow.com/questions/2798653/is-it-possible-to-determine-whether-viewcontroller-is-presented-as-modal
	 */
	return (self.presentingViewController.presentedViewController == self)
	|| ((self.navigationController != nil) && (self.navigationController.presentingViewController.presentedViewController == self.navigationController))
	|| [self.tabBarController.presentingViewController isKindOfClass:UITabBarController.class];
}

@end
