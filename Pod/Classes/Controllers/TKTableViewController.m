//
//  TKTableViewController.m
//  iOS-util
//
//  Created by Tom Knapen on 14/09/15.
//  Copyright (c) 2015 Tom Knapen. All rights reserved.
//

#import "TKTableViewController.h"

@import DZNEmptyDataSet;

@interface TKTableViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource>

@end

@implementation TKTableViewController

#pragma mark - UITableViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	self.tableView.emptyDataSetSource = self;
	
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
}

#pragma mark - DZNEmptyDataSetSource

-(UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[indicator startAnimating];
	return indicator;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.tkDataSource numberOfSectionsForTableView:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tkDataSource tableView:tableView numberOfItemsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	id data = [self.tkDataSource tableView:tableView dataForRowAtIndexPath:indexPath];
	
	id identifier = nil;
	if([self.tkDataSource respondsToSelector:@selector(tableView:classOrIdentifierForRowAtIndexPath:withData:)]) {
		identifier = [self.tkDataSource tableView: tableView
					 classOrIdentifierForRowAtIndexPath: indexPath
										 withData: data];
	} else {
		identifier = @"Cell";
	}
	
	UITableViewCell *cell = nil;
	if([identifier isKindOfClass:NSString.class]) {
		cell = [tableView dequeueReusableCellWithIdentifier: identifier
											   forIndexPath: indexPath];
	} else {
		cell = [[UINib nibWithNibName: NSStringFromClass(identifier)
							   bundle: [NSBundle bundleForClass:identifier]] instantiateWithOwner:self options:nil].firstObject;
	}
	
	if(data && [self.tkDataSource respondsToSelector:@selector(tableView:configureCell:atIndexPath:withData:)]) {
		[self.tkDataSource tableView: tableView
					   configureCell: cell
						 atIndexPath: indexPath
							withData: data];
	}
	return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if([self.tkDelegate respondsToSelector:@selector(tableView:didSelectRow:atIndexPath:withData:)]) {
		[self.tkDelegate tableView: tableView
					  didSelectRow: [tableView cellForRowAtIndexPath:indexPath]
					   atIndexPath: indexPath
						  withData: [self.tkDataSource tableView:tableView dataForRowAtIndexPath:indexPath]];
	}
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	if([self.tkDelegate respondsToSelector:@selector(tableView:didDeselectRow:atIndexPath:withData:)]) {
		[self.tkDelegate tableView: tableView
					didDeselectRow: [tableView cellForRowAtIndexPath:indexPath]
					   atIndexPath: indexPath
						  withData: [self.tkDataSource tableView:tableView dataForRowAtIndexPath:indexPath]];
	}
}

@end
