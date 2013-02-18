//
//  UpdatesController.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-02-01.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "UpdatesController.h"

@interface UpdatesController ()

@end

@implementation UpdatesController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.drupal siteUpdates:self];
}

- (void)drupal_updates:(NSDictionary *)data {
    NSString *msg = [data objectForKey:@"message"];
    if (![msg isEqualToString:@"ok"]) {
        [self alert:@"Call failed!" title:@"System error!"];
        return;
    }
    //NSDate *d = [NSDate dateWithTimeIntervalSince1970:100];
    NSNumber *lastCheck_date = [data objectForKey:@"last_check"];
    if (lastCheck_date) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:lastCheck_date.intValue];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM dd, yyyy"];
        self.lastCheck.text = [NSString stringWithFormat:@"Last check: %@",
                               [dateFormat stringFromDate:date]];
    } else {
        self.lastCheck.text = @"Last update: never";
    }
    self.updates = [data objectForKey:@"updates"];
    if (self.updates && ([self.updates count] > 0)) {
        [self.table reloadData];
    } else {
        self.table.hidden = YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.updates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UpdateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *item = [self.updates objectAtIndex:indexPath.row];
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:1];
    label.text = item;
    
    return cell;
}


@end
