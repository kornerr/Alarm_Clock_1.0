//
//  AlarmListCell.m
//  Sample
//
//  Created by Admin on 03.08.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "AlarmListCell.h"

@interface AlarmListCell ()
@property (strong) NSMutableArray * alarm;
@end

@implementation AlarmListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(NSManagedObjectContext *) managedObjectContext
{
    NSManagedObjectContext * context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    // REVIEW Неявное получение NSManagedObjectContext у UIApplication.
    // REVIEW (пользователь AlarmListCell нигде в своём коде не 
    // REVIEW указывает, что нужен экземпляр UIApplication и тем
    // REVIEW более NSManagedObjectContext).
    // REVIEW Как можно изменить AlarmListCell, чтобы использование
    // REVIEW NSManagedObjectContext было явным?

    
    return context;
}

-(void) startAlarm:(NSDate *)fireDate : (NSInteger) idn
//REVIEW Почему нет имени перед idn? У fireDate - это startAlarm, а тут пусто.
{
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    [notification autorelease];
    notification.fireDate = fireDate;
    notification.alertAction = @"Alarm clock";
    notification.alertBody = self.abaut.text;
    notification.soundName = @"clock1.caf";
    notification.repeatInterval =  NSDayCalendarUnit;
    notification.userInfo = [NSDictionary dictionaryWithObject: [NSString stringWithFormat:@"%d", idn] forKey:@"id"];
    NSLog(@"Test %@", notification.userInfo);
    [[UIApplication sharedApplication] scheduleLocalNotification: notification] ;
    // REVIEW Неявное использование UIApplication (пользователь AlarmListCell
    // REVIEW нигде в своём коде не указывает, что нужен экземпляр UIApplication).
    // REVIEW Как можно изменить AlarmListCell, чтобы использование
    // REVIEW UIApplication было явным?
}

-(IBAction)switchAlarm:(id)sender
{
    NSDate *time;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter autorelease];
    [dateFormatter setDateFormat:@"HH:mm"];
    time = [dateFormatter dateFromString:self.time.text];
    // REVIEW Почему нет autorelease/release?
    
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    NSFetchRequest * fetchReques = [[NSFetchRequest alloc]initWithEntityName:@"DataAlarm"];
    [fetchReques autorelease];
    self.alarm = [[managedObjectContext executeFetchRequest:fetchReques error:nil] mutableCopy];
    NSManagedObject *selectedAlarm = [self.alarm objectAtIndex:self.action.tag];
    if(self.action.on)
    {
        [selectedAlarm setValue:@1 forKey: @"activate"];
        
        [self startAlarm: time : self.action.tag];
    }
    else
    {
            /*
            UIApplication* app = [UIApplication sharedApplication];
            [app cancelAllLocalNotifications];
        */
        
        UIApplication * app = [UIApplication sharedApplication];
        NSArray * old = [app scheduledLocalNotifications];
        for(UILocalNotification * anf in old)
        {
            if([[anf.userInfo objectForKey:@"id"] isEqualToString:[NSString stringWithFormat:@"%d", self.action.tag]])
            {
                [app cancelLocalNotification:anf];
            }
        }
        [selectedAlarm setValue:false forKey: @"activate"];
    }
    NSError * error = nil;
    if(![managedObjectContext save:&error])
    {
        NSLog(@"No save %@  %@", error, [error localizedDescription]);
        // REVIEW Необходимо сообщать с помощью AlertView.
    }
    else
    {
        
        NSLog(@"Good update");
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_abaut release];
    [_time release];
    [_action release];
    [super dealloc];
}
@end
