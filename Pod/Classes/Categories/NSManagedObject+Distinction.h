//
//  NSManagedObject+Distinction.h
//  iOS-util
//
//  Created by Tom Knapen on 24/07/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

@import MagicalRecord;

/**
 * Function prototype for blocks, localObject = [self MR_inContext: localContext]
 */
typedef void(^TKSaveBlock)(NSManagedObjectContext *localContext, id localObject);

@protocol TKManagedObjectProtocol <NSObject>

@optional
/**
 * Convenience function that gets called by tk_createWithBlock(AndWait) right after creating the entity
 */
-(void)construct;
/**
 * Convenience function that gets called by tk_deleteWithBlock(AndWait) right before deleting the entity
 */
-(void)destruct;

@end


@interface NSManagedObject (Distinction)

/**
 * Creates an entity in an MR_context and returns it immediately
 */
+(instancetype)tk_createWithBlock:(TKSaveBlock)block;
/**
 * Creates an entity in `moc` and returns it immediately
 */
+(instancetype)tk_createWithBlock:(TKSaveBlock)block inContext:(NSManagedObjectContext*)moc;
/**
 * Creates an entity in `moc` and returns it immediately
 */
+(instancetype)tk_createWithBlock:(TKSaveBlock)block inContext:(NSManagedObjectContext*)moc completion:(MRSaveCompletionHandler)completion;
/**
 * Creates an entity in an MR_context and returns it when finished
 */
+(instancetype)tk_createWithBlockAndWait:(TKSaveBlock)block;
/**
 * Creates an entity in `moc` and returns it when finished
 */
+(instancetype)tk_createWithBlockAndWait:(TKSaveBlock)block inContext:(NSManagedObjectContext*)moc;

/**
 * Modifies an entity and returns immediately
 */
-(void)tk_saveWithBlock:(TKSaveBlock)block;
/**
 * Modifies an entity and returns immediately
 */
-(void)tk_saveWithBlock:(TKSaveBlock)block completion:(MRSaveCompletionHandler)completion;
/**
 * Modifies an entity and returns when finished
 */
-(void)tk_saveWithBlockAndWait:(TKSaveBlock)block;

/**
 * Deletes an entity in an MR_context and returns immediately
 */
-(void)tk_deleteWithBlock:(TKSaveBlock)block;
/**
 * Deletes an entity and returns immediately
 */
-(void)tk_deleteWithBlock:(TKSaveBlock)block completion:(MRSaveCompletionHandler)completion;
/**
 * Deletes an entity and returns when finished
 */
-(void)tk_deleteWithBlockAndWait:(TKSaveBlock)block;

@end
