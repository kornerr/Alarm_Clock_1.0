//
//  CreateAlarmViewController.h
//  Sample
//
//  Created by Admin on 03.08.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TableViewController.h"

//pat
@protocol EditDataDelegate;

@interface CreateAlarmViewController : UIViewController
    @property (retain, nonatomic) IBOutlet UIDatePicker *pickerTime;
    @property (retain, nonatomic) IBOutlet UITextField *about;
    @property (retain, nonatomic) IBOutlet UILabel *labelDescription;
    @property (strong, nonatomic) NSManagedObject * idAlarm;
    @property (strong, nonatomic) NSString * check;
    @property (retain, nonatomic) id <EditDataDelegate> delegate1;
    -(IBAction)keybordHide:(id)sender;
@end

@protocol EditDataDelegate
    @required
    - (NSManagedObject *) parentDataEdit:(CreateAlarmViewController*) parent;
@end