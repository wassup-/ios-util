//
//  NSPredicate+Combine.h
//  iOS-util
//
//  Created by Tom Knapen on 04/09/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate (Combine)

+(instancetype)combine:(NSPredicate *)left and:(NSPredicate *)right;
+(instancetype)combine:(NSPredicate *)left or:(NSPredicate *)right;

@end
