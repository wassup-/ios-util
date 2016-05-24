//
//  NSPredicate+Combine.h
//  iOS-util
//
//  Created by Tom Knapen on 04/09/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

@import Foundation;

@interface NSPredicate (Combine)

+(nullable instancetype)combine:(nullable NSPredicate *)left and:(nullable NSPredicate *)right;
+(nullable instancetype)combine:(nullable NSPredicate *)left or:(nullable NSPredicate *)right;

@end
