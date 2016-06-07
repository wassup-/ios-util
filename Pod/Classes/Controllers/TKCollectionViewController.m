//
//  TKCollectionViewController.m
//  iOS-util
//
//  Created by Tom Knapen on 14/09/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import "TKCollectionViewController.h"

@import DZNEmptyDataSet;

@interface TKCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource>

@end

@implementation TKCollectionViewController

#pragma mark - UICollectionViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	self.collectionView.emptyDataSetSource = self;
	
	self.collectionView.dataSource = self;
	self.collectionView.delegate = self;
}

#pragma mark - DZNEmptyDataSetSource

-(UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[indicator startAnimating];
	return indicator;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return [self.tkDataSource numberOfSectionsForCollectionView:collectionView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.tkDataSource collectionView:collectionView numberOfItemsInSection:section];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	id data = [self.tkDataSource collectionView:collectionView dataForCellAtIndexPath:indexPath];
	
	id identifier = nil;
	if([self.tkDataSource respondsToSelector:@selector(collectionView:classOrIdentifierForCellAtIndexPath:withData:)]) {
		identifier = [self.tkDataSource collectionView: collectionView
				   classOrIdentifierForCellAtIndexPath: indexPath
											  withData: data];
	} else {
		identifier = @"Cell";
	}
	
	UICollectionViewCell *cell = nil;
	if([identifier isKindOfClass:NSString.class]) {
		cell = [collectionView dequeueReusableCellWithReuseIdentifier: identifier
														 forIndexPath: indexPath];
	} else {
		cell = [[UINib nibWithNibName: NSStringFromClass(identifier)
							   bundle: [NSBundle bundleForClass:identifier]] instantiateWithOwner:self options:nil].firstObject;
	}
	
	
	[self.tkDataSource collectionView: collectionView
						configureCell: cell
						  atIndexPath: indexPath
							 withData: data];
	
	return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if([self.tkDelegate respondsToSelector:@selector(collectionView:didSelectCell:atIndexPath:withData:)]) {
		[self.tkDelegate collectionView: collectionView
						  didSelectCell: [collectionView cellForItemAtIndexPath:indexPath]
							atIndexPath: indexPath
							   withData: [self.tkDataSource collectionView:collectionView dataForCellAtIndexPath:indexPath]];
	}
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	if([self.tkDelegate respondsToSelector:@selector(collectionView:didDeselectCell:atIndexPath:withData:)]) {
		[self.tkDelegate collectionView: collectionView
						didDeselectCell: [collectionView cellForItemAtIndexPath:indexPath]
							atIndexPath: indexPath
							   withData: [self.tkDataSource collectionView:collectionView dataForCellAtIndexPath:indexPath]];
	}
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGSize size = CGSizeMake(100, 100);
	if([self.tkDataSource respondsToSelector:@selector(collectionView:sizeForCellAtIndexPath:withData:)]) {
		size = [self.tkDataSource collectionView: collectionView
						  sizeForCellAtIndexPath: indexPath
										withData: [self.tkDataSource collectionView:collectionView dataForCellAtIndexPath:indexPath]];
	}
	return size;
}

@end
