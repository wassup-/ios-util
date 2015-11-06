//
//  UIPlaceholderTextView.m
//  SBB
//
//  Created by Tom Knapen on 27/10/15.
//  Copyright © 2015 Appwise. All rights reserved.
//

#import "UIPlaceholderTextView.h"

static NSInteger const kPlaceholderLabelTag = 999;

@implementation UIPlaceholderTextView

@synthesize placeholderLabel = _placeholderLabel;

#pragma mark - UIView

-(void)awakeFromNib {
	[super awakeFromNib];
	
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(textChanged:)
												 name: UITextViewTextDidChangeNotification
											   object: nil];
}

-(void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect rect = CGRectMake(4, 8, self.bounds.size.width - 16, 0);
	self.placeholderLabel.frame = rect;
}

#pragma mark - Actions

-(void)textChanged:(id)sender {
	self.placeholderLabel.hidden = ![self shouldShowPlaceholder];
}

-(void)updatePlaceholderVisibility {
	if([self shouldShowPlaceholder]) {
		self.placeholderLabel.alpha = 1.;
	} else {
		self.placeholderLabel.alpha = 0.;
	}
}

#pragma mark - Properties

-(UILabel *)placeholderLabel {
	if(!_placeholderLabel) {
		CGRect rect = CGRectMake(4, 8, self.bounds.size.width - 16, 0);
		_placeholderLabel = [[UILabel alloc] initWithFrame: rect];
		_placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
		_placeholderLabel.numberOfLines = 0;
		_placeholderLabel.backgroundColor = UIColor.clearColor;
		_placeholderLabel.textColor = [UIColor colorWithWhite:.71 alpha:1.];
		_placeholderLabel.tag = kPlaceholderLabelTag;
		_placeholderLabel.font = self.font;
		
		[self addSubview:_placeholderLabel];
	}
	return _placeholderLabel;
}

-(NSString *)placeholderText {
	return self.placeholderLabel.text;
}

-(void)setPlaceholderText:(NSString *)placeholderText {
	self.placeholderLabel.text = placeholderText;

	[self.placeholderLabel sizeToFit];
}

#pragma mark - Overrides

-(void)setFont:(UIFont *)font {
	[super setFont:font];
	self.placeholderLabel.font = self.font;
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment {
	[super setTextAlignment:textAlignment];
	self.placeholderLabel.textAlignment = self.textAlignment;
}

-(id)insertDictationResultPlaceholder {
	id placeholder = [super insertDictationResultPlaceholder];
	self.placeholderLabel.hidden = YES;
	return placeholder;
}

-(void)removeDictationResultPlaceholder:(id)placeholder willInsertResult:(BOOL)willInsertResult {
	[super removeDictationResultPlaceholder:placeholder willInsertResult:willInsertResult];
	self.placeholderLabel.hidden = NO;
}

-(void)setText:(NSString *)text {
	[super setText:text];
	
	[self updatePlaceholderVisibility];
}

#pragma mark - Helpers

-(BOOL)shouldShowPlaceholder {
	if(self.text.length > 0) return NO;
	if(self.placeholderText.length == 0) return NO;
	return YES;
}

@end
