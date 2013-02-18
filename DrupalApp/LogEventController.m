//
//  LogEventController.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-02-04.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "LogEventController.h"

@interface LogEventController () {
    NSMutableArray *_eventData;
}

@end

@implementation LogEventController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.drupal siteLogEvent:self event:self.event];
}

- (void)drupal_log_event:(NSDictionary *)data {
    NSDictionary *ed = [data objectForKey:@"event"];
    self.message.text = [ed objectForKey:@"message"];
    _eventData = [@[
        @[@"username", [ed objectForKey:@"name"]?[ed objectForKey:@"name"]: @""],
        @[@"type", [ed objectForKey:@"type"]?[ed objectForKey:@"type"]: @""],
        @[@"hostname", [ed objectForKey:@"hostname"]?[ed objectForKey:@"hostname"]: @""],
        @[@"location", [ed objectForKey:@"location"]?[ed objectForKey:@"location"]: @""],
        @[@"referer", [ed objectForKey:@"referer"]?[ed objectForKey:@"referer"]: @""]
    ] mutableCopy];
    
    NSNumber *tms = [ed objectForKey:@"timestamp"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tms.intValue];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm, MMM dd, yyyy"];
    [_eventData insertObject:@[
        @"DateTime", [dateFormat stringFromDate:date]
     ] atIndex:0];
    [self.table reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_eventData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *line = [_eventData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [line objectAtIndex:1]];//just in case
    cell.detailTextLabel.text = [line objectAtIndex:0];
    
    return cell;
}

@end
