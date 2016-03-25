//
//  SKSpriteNode+Tile.h
//  iOS-util
//
//  Created by Tom Knapen on 16/03/16.
//  Copyright © 2016 Tom Knapen. All rights reserved.
//

@import Foundation;
@import SpriteKit;

@interface SKSpriteNode (Tile)

+(instancetype)spriteNodeWithTiledImageNamed:(NSString *)name size:(CGSize)size;
+(instancetype)spriteNodeWithTiledTexture:(SKTexture *)texture size:(CGSize)size;

@end
