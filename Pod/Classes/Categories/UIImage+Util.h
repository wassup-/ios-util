//
//  UIImage+Util.h
//  iOS-util
//
//  Created by Tom Knapen on 16/07/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface UIImage (Util)

+(instancetype)imageWithColor:(UIColor *)color;

-(instancetype)dw_removeOrientation;

-(instancetype)dw_scaledImage:(CGSize)scale;
-(instancetype)dw_resizedImage:(CGSize)newSize;
-(instancetype)dw_scaleToFit:(CGSize)rect;

-(NSData *)dw_compressForByteCount:(NSUInteger)byteCount;

@end
