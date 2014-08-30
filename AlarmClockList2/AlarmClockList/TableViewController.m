//
//  TableViewController.m
//  Sample
//
//  Created by Michael Kapelko on 23/07/14.
//  Copyright (c) 2014 Michael Kapelko. All rights reserved.
//

#import "TableViewController.h"
#import "AlarmListCell.h"

@interface TableViewController ()
@property (strong) NSMutableArray * alarm;
@end

@implementation TableViewController

- (void)dealloc
{
    [_child release];
    [_check release];
    [super dealloc];
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

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    NSFetchRequest * fetchReques = [[NSFetchRequest alloc]initWithEntityName:@"DataAlarm"];
    [fetchReques autorelease];
    self.alarm = [[managedObjectContext executeFetchRequest:fetchReques error:nil] mutableCopy];
    [self.tableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(onNextPage)];
    [item autorelease];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.title = NSLocalizedString(@"TitleAlarmList", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)onNextPage
{
    self.check = nil;
    [self.navigationController pushViewController:self.child animated:YES];
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [context deleteObject:[self.alarm objectAtIndex:indexPath.row]];
        NSError * error = nil;
        if(![context save:&error])
        {
            NSLog(@"No delete %@ %@", error, [ error localizedDescription]);
            return;
        }
        [self.alarm removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.alarm.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AlarmListCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if(self.alarm.count > 0)
    {
        NSManagedObject * a = [self.alarm objectAtIndex: indexPath.row];
        cell.abaut.text = [a valueForKey:@"about"];
        NSDate * date = [a valueForKey:@"time"];
        NSDateFormatter * dateForm = [[NSDateFormatter alloc] init];
        [dateForm setDateFormat:@"HH:mm"];
        cell.time.text = [NSString stringWithFormat:@"%@", [dateForm stringFromDate:date]];
        cell.action.on = (BOOL)[a valueForKey:@"activate"];
        cell.action.tag = indexPath.row;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.alarm.count > 0)
    {
        self.idRow = [[self.tableView indexPathForSelectedRow] row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:self.child animated:YES];
    self.check = @"Update";
}


- (NSManagedObject *) parentDataEdit:(CreateAlarmViewController*) parent
{
    parent.check = self.check;
    NSManagedObject *selectedAlarm = nil;
    if(self.alarm.count > 0)
    {
        selectedAlarm = [self.alarm objectAtIndex:self.idRow];
    }
    return selectedAlarm;
}


@end
