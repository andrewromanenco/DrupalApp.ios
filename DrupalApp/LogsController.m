//
//  LogsController.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-02-03.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "LogsController.h"
#import "LogEventController.h"

@interface LogsController () {
    NSDateFormatter *_dateFormat;
    NSArray *_events;
    int _offset;
    int _selectedIndex;
}

@end

@implementation LogsController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.drupal siteLogs:self offset:0];
    _dateFormat = [[NSDateFormatter alloc] init];
    [_dateFormat setDateFormat:@"hh:mm, MMM dd, yyyy"];

}

// Site logs
- (void)drupal_logs:(NSDictionary*)data {
    NSString *msg = [data objectForKey:@"message"];
    if (![msg isEqualToString:@"ok"]) {
        [self alert:@"Call failed!" title:@"System error!"];
        return;
    }
    _events = [data objectForKey:@"events"];
    
    NSNumber *n_off = [data objectForKey:@"offset"];
    _offset = n_off.intValue;
    
    if (_offset > 0) {
        self.prevBtn.enabled = YES;
    } else {
        self.prevBtn.enabled = NO;
    }
    if ([_events count] >= 20) {//show next if we are showing 20 events, so next page might be empty
        self.nextBtn.enabled = YES;
    } else {
        self.nextBtn.enabled = NO;
    }
    [self.table setContentOffset:CGPointZero animated:YES];
    [self.table reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *event = [_events objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [event objectForKey:@"message"];
    
    NSNumber *timestamp = [event objectForKey:@"timestamp"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp.intValue];
    cell.detailTextLabel.text = [_dateFormat stringFromDate:date];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"gotoLogEvent" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    LogEventController *le = (LogEventController*) segue.destinationViewController;
    NSDictionary *event = [_events objectAtIndex:_selectedIndex];
    NSNumber *eventId = [event objectForKey:@"wid"];
    le.event = eventId.intValue;
}

- (IBAction)prevAction:(id)sender {
    if (_offset >= 20) {
        _offset -= 20;
    } else {
        _offset = 0;
    }
    [self.drupal siteLogs:self offset:_offset];
}

- (IBAction)nextAction:(id)sender {
    _offset += 20;
    [self.drupal siteLogs:self offset:_offset];
}
@end
