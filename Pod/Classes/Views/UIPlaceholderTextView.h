//
//  UIPlaceholderTextView.h
//  iOS-util
//
//  Created by Tom Knapen on 27/10/15.
//  Copyright © 2015 Appwise. All rights reserved.
//

@import UIKit;

@interface UIPlaceholderTextView : UITextView

@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) IBInspectable NSString *placeholderText;

@end
