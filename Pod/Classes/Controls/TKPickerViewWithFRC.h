//
//  TKPickerViewWithFRC.h
//  iOS-util
//
//  Created by Tom Knapen on 04/11/15.
//  Copyright © 2015 Tom Knapen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class TKPickerViewWithFRC;

@protocol TKPickerViewWithFRCProtocol <NSObject>

@required
-(NSFetchedResultsController *)newFetchedResultsController;
-(NSString *)pickerView:(TKPickerViewWithFRC *)pickerView titleForRowAtIndexPath:(NSIndexPath *)indexPath withData:(id)data;

@optional
-(void)pickerView:(TKPickerViewWithFRC *)pickerView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withData:(id)data;

@end

@interface TKPickerViewWithFRC : UIPickerView

@property (nonatomic, weak) id<TKPickerViewWithFRCProtocol> tkDelegate;

-(void)reloadData;

@end
