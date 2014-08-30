//
//  TableViewController.h
//  Sample
//
//  Created by Michael Kapelko on 23/07/14.
//  Copyright (c) 2014 Michael Kapelko. All rights reserved.
//


#import "AlarmListCell.h"
#import "CreateAlarmViewController.h"
#import <UIKit/UIKit.h>

@protocol EditDataDelegate;


@interface TableViewController : UITableViewController <EditDataDelegate>

@property (retain, nonatomic) CreateAlarmViewController *child;
@property (assign, nonatomic) NSInteger idRow;
@property (strong, nonatomic) NSString * check;

@end

