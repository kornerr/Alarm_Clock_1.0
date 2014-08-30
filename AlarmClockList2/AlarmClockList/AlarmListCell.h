//
//  AlarmListCell.h
//  Sample
//
//  Created by Admin on 03.08.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *abaut;
@property (retain, nonatomic) IBOutlet UILabel *time;
@property (retain, nonatomic) IBOutlet UISwitch *action;
-(IBAction)switchAlarm:(id)sender;
@end

