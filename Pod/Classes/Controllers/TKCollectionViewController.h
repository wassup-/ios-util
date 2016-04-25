//
//  TKCollectionViewController.h
//  iOS-util
//
//  Created by Tom Knapen on 14/09/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

@import UIKit;

@class TKCollectionViewController;

@protocol TKCollectionViewControllerDataSource <NSObject>

@required
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

-(id)collectionView:(UICollectionView *)collectionView dataForCellAtIndexPath:(NSIndexPath *)indexPath;
-(id)collectionView:(UICollectionView *)collectionView classOrIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath withData:(id)data;
-(void)collectionView:(UICollectionView *)collectionView configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withData:(id)data;
-(CGSize)collectionView:(UICollectionView *)collectionView sizeForCellAtIndexPath:(NSIndexPath *)indexPath withData:(id)data;

@end

@protocol TKCollectionViewControllerDelegate <NSObject>

@optional
-(void)collectionView:(UICollectionView *)collectionView didSelectCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withData:(id)data;
-(void)collectionView:(UICollectionView *)collectionView didDeselectCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withData:(id)data;

@end

@interface TKCollectionViewController : UICollectionViewController

@property (nonatomic, weak) id<TKCollectionViewControllerDataSource> tkDataSource;
@property (nonatomic, weak) id<TKCollectionViewControllerDelegate> tkDelegate;

@end
