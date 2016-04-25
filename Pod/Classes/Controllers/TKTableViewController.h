//
//  TKTableViewController.h
//  iOS-util
//
//  Created by Tom Knapen on 14/09/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

@import UIKit;

@class TKTableViewController;

@protocol TKTableViewControllerDataSource <NSObject>

@required
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView*)tableView numberOfItemsInSection:(NSInteger)section;

-(id)tableView:(UITableView*)tableView dataForRowAtIndexPath:(NSIndexPath *)indexPath;
-(id)tableView:(UITableView*)tableView classOrIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath withData:(id)data;
-(void)tableView:(UITableView*)tableView configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withData:(id)data;

@end

@protocol TKTableViewControllerDelegate <NSObject>

@optional
-(void)tableView:(UITableView*)tableView didSelectRow:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withData:(id)data;
-(void)tableView:(UITableView*)tableView didDeselectRow:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withData:(id)data;

@end

@interface TKTableViewController : UITableViewController

@property (nonatomic, weak) id<TKTableViewControllerDataSource> tkDataSource;
@property (nonatomic, weak) id<TKTableViewControllerDelegate> tkDelegate;

@end
