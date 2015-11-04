//
//  APWPickerViewWithFRC.m
//  SBB
//
//  Created by Tom Knapen on 04/11/15.
//  Copyright © 2015 Appwise. All rights reserved.
//

#import "APWPickerViewWithFRC.h"

@interface APWPickerViewWithFRC () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation APWPickerViewWithFRC

#pragma mark - UIPickerView

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return self.fetchedResultsController.sections.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.fetchedResultsController.sections[component].numberOfObjects;
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSIndexPath *const indexPath = [NSIndexPath indexPathForRow:row inSection:component];
	id data = [self.fetchedResultsController objectAtIndexPath:indexPath];
	return [self.apwDelegate titleForRowAtIndexPath:indexPath withData:data];
}

#pragma mark - Helpers

-(void)reloadData {
	NSError *error = nil;
	if(![self.fetchedResultsController performFetch:&error]) {
		DDLogError(@"[%@ %@] %@", THIS_FILE, THIS_METHOD, error);
	} else {
		[self reloadAllComponents];
	}
}

#pragma mark - Properties

-(void)setApwDelegate:(id<APWPickerViewWithFRCProtocol>)apwDelegate {
	_apwDelegate = apwDelegate;
	[self reloadData];
	self.dataSource = self;
	self.delegate = self;
}

-(NSFetchedResultsController *)fetchedResultsController {
	if(!_fetchedResultsController) {
		_fetchedResultsController = [self.apwDelegate newFetchedResultsController];
	}
	return _fetchedResultsController;
}

@end
