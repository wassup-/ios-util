//
//  UIImage+Util.m
//  iOS-util
//
//  Created by Tom Knapen on 16/07/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

-(instancetype)dw_removeOrientation {	
	CGImageRef        imgRef    = self.CGImage;
	CGFloat           width     = CGImageGetWidth(imgRef);
	CGFloat           height    = CGImageGetHeight(imgRef);
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect            bounds    = CGRectMake( 0, 0, width, height );
	
	CGFloat            scaleRatio   = bounds.size.width / width;
	CGSize             imageSize    = CGSizeMake(width, height);
	UIImageOrientation orient       = self.imageOrientation;
	CGFloat            boundHeight;
	
	switch(orient)
	{
		case UIImageOrientationUp:                                        //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored:                                //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown:                                      //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored:                              //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored:                              //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft:                                      //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored:                             //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight:                                     //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise: NSInternalInconsistencyException
						format: @"Invalid image orientation"];
			
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if ( orient == UIImageOrientationRight || orient == UIImageOrientationLeft )
	{
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else
	{
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0., 0., width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

-(instancetype)dw_scaledImage:(CGSize)scale {
	const CGSize newSize = CGSizeApplyAffineTransform(self.size, CGAffineTransformScale(CGAffineTransformIdentity, scale.width, scale.height));
	return [self dw_resizedImage:newSize];
}

-(instancetype)dw_resizedImage:(CGSize)newSize {
	const CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
	UIGraphicsBeginImageContext(rect.size);
	[self drawInRect:rect];
	UIImage *resized = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resized;
}

-(instancetype)dw_scaleToFit:(CGSize)rect {
	CGFloat scale;
	if(self.size.width >= self.size.height) {
		scale = 1. / (self.size.width / rect.width);
	} else {
		scale = 1. / (self.size.height / rect.height);
	}
	return [self dw_scaledImage:CGSizeMake(scale, scale)];
}

-(NSData*)dw_compressForByteCount:(NSUInteger)byteCount {
	// NOTE: the lowest quality we accept is 0.8 (to keep everything readable)
	static const NSInteger kNumChannels = 3;
	static const float kMinQuality = 0.8;
	static const size_t kQualitySteps = 10;
	static const float kQualityStepSize = ((1. - kMinQuality) / kQualitySteps);
	
	NSData *compressed_data = nil;
	// Best case scenario: we can fit the bytecount by lowering the quality
	for(size_t i = 0; i < kQualitySteps; ++i) {
		compressed_data = UIImageJPEGRepresentation(self, 1. - ((i + 1) * kQualityStepSize));
		if(compressed_data.length <= byteCount)
			return compressed_data;
	}
	// Worst case scenario: we need to resize + compress the image to fit the bytecount
	const size_t max_pixel_count = (byteCount / kNumChannels);
	const CGSize max_size = calculateMaxSizeForPixelCount(max_pixel_count, self.size);
	const CGSize mean_size = sizeGetMeanSize(self.size, max_size);
	return [[self dw_resizedImage:mean_size] dw_compressForByteCount:byteCount];
}

+(instancetype)imageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0., 0., 1., 1.);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

#pragma mark - Utility functions

CGSize sizeGetMeanSize(CGSize max, CGSize min) {
	const CGFloat mean_width = (min.width + max.width) / 2.;
	const CGFloat mean_height = (min.height + max.height) / 2.;
	return CGSizeMake(mean_width, mean_height);
}

CGSize calculateMaxSizeForPixelCount(size_t max_pixels, CGSize cur_size) {
	const CGFloat scale_x = (cur_size.width / cur_size.height);
	const CGFloat scale_y = (cur_size.height / cur_size.width);
	const CGFloat max_x = sqrt(max_pixels * scale_x);
	const CGFloat max_y = sqrt(max_pixels * scale_y);
	return CGSizeMake(max_x, max_y);
}

@end
