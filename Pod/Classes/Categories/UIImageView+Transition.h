//
//  UIImageView+Transition.h
//  iOS-util
//
//  Created by Tom Knapen on 09/03/16.
//  Copyright © 2016 Tom Knapen. All rights reserved.
//

@import UIKit;

@interface UIImageView (Transition)

-(void)transitionToImage:(UIImage * __nullable)image duration:(NSTimeInterval)duration;
-(void)transitionToImage:(UIImage * __nullable)image duration:(NSTimeInterval)duration transition:(UIViewAnimationOptions)options;
-(void)transitionToImage:(UIImage * __nullable)image duration:(NSTimeInterval)duration transition:(UIViewAnimationOptions)options completion:(void(^ __nullable)(BOOL finished))completion;

@end
