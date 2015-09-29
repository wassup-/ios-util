//
//  NSPredicate+Combine.m
//  iOS-util
//
//  Created by Tom Knapen on 04/09/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import "NSPredicate+Combine.h"

@implementation NSPredicate (Combine)

+(instancetype)combine:(NSPredicate *)left and:(NSPredicate *)right {
	if(left && right)
		return [NSCompoundPredicate andPredicateWithSubpredicates:@[left, right]];
	else if(left)
		return left;
	else if(right)
		return right;
	else
		return nil;
}

+(instancetype)combine:(NSPredicate *)left or:(NSPredicate *)right {
	if(left && right)
		return [NSCompoundPredicate orPredicateWithSubpredicates:@[left, right]];
	else if(left)
		return left;
	else if(right)
		return right;
	else
		return nil;
}

@end
