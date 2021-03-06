//
//  TKPickerViewWithFRC.m
//  iOS-util
//
//  Created by Tom Knapen on 04/11/15.
//  Copyright © 2015 Tom Knapen. All rights reserved.
//

#import "TKPickerViewWithFRC.h"

#ifndef THIS_FILE
#define THIS_FILE @"TKPickerViewWithFRC"
#endif
#ifndef THIS_METHOD
#define THIS_METHOD NSStringFromSelector(_cmd)
#endif

@interface TKPickerViewWithFRC () <UIPickerViewDelegate, UIPickerViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableSet<NSNumber *> *modifiedSections;

@end

@implementation TKPickerViewWithFRC

#pragma mark - UIPickerView

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  if([self.tkDelegate respondsToSelector:@selector(pickerView:didSelectRowAtIndexPath:withData:)]) {
    NSIndexPath *const indexPath = [NSIndexPath indexPathForRow:row inSection:component];
    id data = [self dataForRowAtIndexPath:indexPath];
    [self.tkDelegate pickerView:self didSelectRowAtIndexPath:indexPath withData:data];
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
  id data = [self dataForRowAtIndexPath:indexPath];
  return [self.tkDelegate pickerView:self titleForRowAtIndexPath:indexPath withData:data];
}

#pragma mark - Helpers

-(id)dataForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self.fetchedResultsController objectAtIndexPath: indexPath];
}

-(void)reloadData {
  NSError *error = nil;
  if(![self.fetchedResultsController performFetch:&error]) {
    NSLog(@"[%@ %@] %@", THIS_FILE, THIS_METHOD, error);
  } else {
    [self reloadAllComponents];
  }
}

-(void)performBatchUpdates {
  NSSet<NSNumber *> *const sections = self.modifiedSections;
  for(NSNumber *section in sections) {
    [self reloadComponent:[section integerValue]];
  }
}

#pragma mark - Properties

-(void)setTkDelegate:(id<TKPickerViewWithFRCProtocol>)tkDelegate {
  _tkDelegate = tkDelegate;
  if(_tkDelegate) {
    self.dataSource = self;
    self.delegate = self;
    [self reloadData];
  }
}

-(NSFetchedResultsController *)fetchedResultsController {
  if(!_fetchedResultsController) {
    _fetchedResultsController = [self.tkDelegate newFetchedResultsController];
    _fetchedResultsController.delegate = self;
  }
  return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  self.modifiedSections = NSMutableSet.set;
}

-(void)controller:(NSFetchedResultsController *)controller
  didChangeObject:(id)anObject
    atIndexPath:(NSIndexPath *)indexPath
  forChangeType:(NSFetchedResultsChangeType)type
   newIndexPath:(NSIndexPath *)newIndexPath
{
  [self.modifiedSections addObject:@(indexPath.section)];
  [self.modifiedSections addObject:@(newIndexPath.section)];
}

-(void)controller:(NSFetchedResultsController *)controller
 didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
      atIndex:(NSUInteger)sectionIndex
  forChangeType:(NSFetchedResultsChangeType)type
{
  [self.modifiedSections addObject:@(sectionIndex)];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self performBatchUpdates];
}

@end
