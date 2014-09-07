//
//  CreateAlarmViewController.m
//  Sample
//
//  Created by Admin on 03.08.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "CreateAlarmViewController.h"

@interface CreateAlarmViewController ()

@end

@implementation CreateAlarmViewController

@synthesize idAlarm;
// REVIEW Что это? Зачем оно тут?

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = NSLocalizedString(@"TitleCreateAlarm", nil);
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    self.pickerTime.date = [NSDate date];
    self.about.text = @"";
    self.idAlarm = [self.delegate1 parentDataEdit:self];
    if(self.check)
    {
        self.about.text = [self.idAlarm valueForKey:@"about"];
        self.pickerTime.date = [self.idAlarm valueForKey:@"time"];
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.labelDescription.text = NSLocalizedString(@"LabelDescription", nil);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"RightItemBar", nil)
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(createAlarm)];
    [item autorelease];
    self.navigationItem.rightBarButtonItem = item;
}

-(NSManagedObjectContext *) managedObjectContext
{
    NSManagedObjectContext * context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

-(void)createAlarm
{
    NSManagedObjectContext * context = [self managedObjectContext];
    if(self.check)
    {
        if([self.about.text  isEqual: @""]) self.about.text = NSLocalizedString(@"DefaultTitle", nil);
        [self.idAlarm setValue:self.about.text forKey: @"about"];
        [self.idAlarm setValue:self.pickerTime.date forKey: @"time"];
        [self.idAlarm setValue:[self.idAlarm valueForKey:@"activate"] forKey: @"activate"];
    }
    else
    {
    NSManagedObject * newAlarm  = [NSEntityDescription insertNewObjectForEntityForName:@"DataAlarm" inManagedObjectContext:context];
        if([self.about.text  isEqual: @""]) self.about.text = NSLocalizedString(@"DefaultTitle", nil);
    [newAlarm setValue:self.about.text forKeyPath:@"about"];
    [newAlarm setValue:self.pickerTime.date forKeyPath:@"time"];
    [newAlarm setValue: false forKeyPath:@"activate"];
    }
    NSError * error = nil;
    if(![context save:&error])
    {
        NSLog(@"No save %@  %@", error, [error localizedDescription]);
    }
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}



-(IBAction)keybordHide:(id)sender
{
    [sender resignFirstResponder];
    // REVIEW Как иначе можно скрыть клавиатуру?
}

- (void)dealloc {
    // REVIEW Почему в одних местах { с новой строки,
    // REVIEW а в других нет? Откуда разночтение?
    [_pickerTime release];
    [_about release];
    [_labelDescription release];
    [_check release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
