//
//  UIViewController+Modal.h
//  iOS-util
//
//  Created by Tom Knapen on 08/03/16.
//  Copyright © 2016 Tom Knapen. All rights reserved.
//

@import UIKit;

@interface UIViewController (Modal) <UIPopoverPresentationControllerDelegate>

-(void)presentViewController:(UIViewController * __nonnull)controller asPopoverWithSize:(CGSize)size animated:(BOOL)animated;

-(BOOL)isBeingPresentedModally;

@end
