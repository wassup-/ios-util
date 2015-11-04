//
//  TKPickerViewWithFRC.m
//  iOS-util
//
//  Created by Tom Knapen on 04/11/15.
//  Copyright © 2015 Tom Knapen. All rights reserved.
//

#import "TKPickerViewWithFRC.h"

@interface TKPickerViewWithFRC () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TKPickerViewWithFRC

#pragma mark - UIPickerView

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if([self.apwDelegate respondsToSelector:@selector(pickerView:didSelectRowAtIndexPath:withData:)]) {
		NSIndexPath *const indexPath = [NSIndexPath indexPathForRow:row inSection:component];
		id data = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[self.apwDelegate pickerView:self didSelectRowAtIndexPath:indexPath withData:data];
	}
}

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
	return [self.apwDelegate pickerView:self titleForRowAtIndexPath:indexPath withData:data];
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
