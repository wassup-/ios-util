//
//  SKSpriteNode+Tile.m
//  iOS-util
//
//  Created by Tom Knapen on 16/03/16.
//  Copyright © 2016 Tom Knapen. All rights reserved.
//

#import "SKSpriteNode+Tile.h"

@import CoreGraphics;

//#define SKSPRITENODE_TILE_USE_CIFILTER

@implementation SKSpriteNode (Tile)

#if defined(SKSPRITENODE_TILE_USE_CIFILTER)
+(CIFilter *)tileFilter {
	static CIFilter *filter;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSArray<NSString *> *filters = [CIFilter filterNamesInCategory:kCICategoryTileEffect];
		DDLogDebug(@"available filters: %@", filters);

		const CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
		NSValue *transValue = [NSValue valueWithBytes: &transform
											 objCType: @encode(CGAffineTransform)];
		filter = [CIFilter filterWithName: @"CIAffineTile"
					  withInputParameters: @{kCIInputTransformKey: transValue}];
	});
	return filter;
}
#endif

+(SKTexture *)tiledTextureFromCGImageRef:(CGImageRef)image withSize:(CGSize)size {
	const CGSize imageSize = CGSizeMake(CGImageGetWidth(image),
										CGImageGetHeight(image));
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawTiledImage(context, CGRectMake(0, 0, imageSize.width, imageSize.height), image);
	UIImage *const tiledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return [SKTexture textureWithCGImage:tiledImage.CGImage];
}

+(instancetype)spriteNodeWithTiledImageNamed:(NSString *)name size:(CGSize)size {
	SKTexture *const texture = [SKTexture textureWithImageNamed:name];
	return [self spriteNodeWithTiledTexture:texture size:size];
}

+(instancetype)spriteNodeWithTiledTexture:(SKTexture *)texture size:(CGSize)size {
#if defined(SKSPRITENODE_TILE_USE_CIFILTER)
	CIFilter *filter = [self tileFilter];
	return [self spriteNodeWithTexture: [texture textureByApplyingCIFilter:filter]
								  size: size];
#else
	SKTexture *const tiledTexture = [self tiledTextureFromCGImageRef:texture.CGImage withSize:size];
	SKSpriteNode *instance = [self spriteNodeWithTexture: tiledTexture
													size: size];
	instance.yScale = -1;
	return instance;
#endif
}

@end
