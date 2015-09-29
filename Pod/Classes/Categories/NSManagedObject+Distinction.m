//
//  NSManagedObject+Distinction.m
//  iOS-util
//
//  Created by Tom Knapen on 24/07/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import "NSManagedObject+Distinction.h"

@implementation NSManagedObject (Distinction)

+(instancetype)tk_createWithBlock:(TKSaveBlock)block {
	NSManagedObjectContext *const moc = [NSManagedObjectContext MR_context];
	return [self tk_createWithBlock:block inContext:moc];
}

+(instancetype)tk_createWithBlock:(TKSaveBlock)block inContext:(NSManagedObjectContext *)moc {
	return [self tk_createWithBlock:block inContext:moc completion:nil];
}

+(instancetype)tk_createWithBlock:(TKSaveBlock)block inContext:(NSManagedObjectContext*)moc completion:(MRSaveCompletionHandler)completion {
	NSManagedObjectContext *const savingContext = moc;
	id entity = [self MR_createEntityInContext:savingContext];
	[entity tk_saveWithBlock:^(NSManagedObjectContext *localContext, id localObject) {
		if([localObject respondsToSelector:@selector(construct)])
			[localObject performSelector:@selector(construct)];
		if(block)
			block(localContext, localObject);
	} completion:completion];
	return entity;
}

+(instancetype)tk_createWithBlockAndWait:(TKSaveBlock)block {
	NSManagedObjectContext *const moc = [NSManagedObjectContext MR_context];
	return [self tk_createWithBlockAndWait:block inContext:moc];
}

+(instancetype)tk_createWithBlockAndWait:(TKSaveBlock)block inContext:(NSManagedObjectContext *)moc {
	NSManagedObjectContext *const savingContext = moc;
	id entity = [self MR_createEntityInContext:savingContext];
	
	[entity tk_saveWithBlockAndWait:^(NSManagedObjectContext *localContext, id localObject) {
		if([localObject respondsToSelector:@selector(construct)])
			[localObject performSelector:@selector(construct)];
		if(block)
			block(localContext, localObject);
	}];
	return entity;
}

-(void)tk_saveWithBlock:(TKSaveBlock)block {
	[self tk_saveWithBlock:block completion:nil];
}

-(void)tk_saveWithBlock:(TKSaveBlock)block completion:(MRSaveCompletionHandler)completion {
	[MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
		if(block)
			block(localContext, [self MR_inContext:localContext]);
	} completion:completion];
}

-(void)tk_saveWithBlockAndWait:(TKSaveBlock)block {
	[MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
		if(block)
			block(localContext, [self MR_inContext:localContext]);
	}];
}

-(void)tk_deleteWithBlock:(TKSaveBlock)block {
	[self tk_deleteWithBlock:block completion:nil];
}

-(void)tk_deleteWithBlock:(TKSaveBlock)block completion:(MRSaveCompletionHandler)completion {
	[self tk_saveWithBlock:^(NSManagedObjectContext *localContext, id localObject) {
		if(block)
			block(localContext, localObject);
		if([self respondsToSelector:@selector(destruct)])
			[self performSelector:@selector(destruct)];
		[localObject MR_deleteEntityInContext:localContext];
	} completion:^(BOOL contextDidSave, NSError *error) {
		if(completion)
			completion(contextDidSave, error);
	}];
}

-(void)tk_deleteWithBlockAndWait:(TKSaveBlock)block {
	[self tk_saveWithBlockAndWait:^(NSManagedObjectContext *localContext, id localObject) {
		if(block)
			block(localContext, localObject);
		if([self respondsToSelector:@selector(destruct)])
			[self performSelector:@selector(destruct)];
		[localObject MR_deleteEntityInContext:localContext];
	}];
}

@end
