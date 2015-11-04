//
//  APWPickerViewWithFRC.h
//  SBB
//
//  Created by Tom Knapen on 04/11/15.
//  Copyright © 2015 Appwise. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APWPickerViewWithFRCProtocol <NSObject>

@required
-(NSFetchedResultsController *)newFetchedResultsController;
-(NSString *)titleForRowAtIndexPath:(NSIndexPath *)indexPath withData:(id)data;

@end

@interface APWPickerViewWithFRC : UIPickerView

@property (nonatomic, weak) id<APWPickerViewWithFRCProtocol> apwDelegate;

-(void)reloadData;

@end
