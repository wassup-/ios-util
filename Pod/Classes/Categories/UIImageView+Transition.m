//
//  UIImageView+Transition.m
//  iOS-util
//
//  Created by Tom Knapen on 09/03/16.
//  Copyright © 2016 Tom Knapen. All rights reserved.
//

#import "UIImageView+Transition.h"

@implementation UIImageView (Transition)

-(void)transitionToImage:(UIImage * __nullable)image duration:(NSTimeInterval)duration {
	[self transitionToImage: image
				   duration: duration
				 transition: UIViewAnimationOptionTransitionCrossDissolve];
}

-(void)transitionToImage:(UIImage * __nullable)image duration:(NSTimeInterval)duration transition:(UIViewAnimationOptions)options {
	[self transitionToImage: image
				   duration: duration
				 transition: options
				 completion: nil];
}

-(void)transitionToImage:(UIImage * __nullable)image duration:(NSTimeInterval)duration transition:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion {
	__weak __typeof(self) self_weak_ = self;
	void(^animations)() = ^{
		__strong __typeof(self) self_strong_ = self_weak_;
		self_strong_.image = image;
	};

	[UIView transitionWithView: self
					  duration: duration
					   options: options
					animations: animations
					completion: completion];
}

@end
