//
//  WhoIsOnlineController.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-02-01.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "WhoIsOnlineController.h"

@interface WhoIsOnlineController () {
    NSArray *_users;
}

@end

@implementation WhoIsOnlineController

-(void)viewDidAppear:(BOOL)animated {
    [self.drupal whoisonline:self offset:0];
}

- (void)drupal_online_users:(NSDictionary*)users {
    NSString *msg = [users objectForKey:@"message"];
    if (![msg isEqualToString:@"ok"]) {
        [self alert:@"Call failed!" title:@"System error!"];
        return;
    }
    self.data = users;

    NSNumber *n_off = [users objectForKey:@"offset"];
    NSNumber *n_count = [users objectForKey:@"authenticated"];
    int off = n_off.intValue;
    int count = n_count.intValue;
    
    if (off > 0) {
        self.prevBtn.enabled = YES;
    } else {
        self.prevBtn.enabled = NO;
    }
    if (count - off > 20) {
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
    _users = [self.data objectForKey:@"users"];
    self.total.text = [NSString stringWithFormat:@"Total: %@", [self.data objectForKey:@"authenticated"]];
    return [_users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"OnlineUserCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:1];
    NSDictionary *u = [_users objectAtIndex:indexPath.row];
    label.text = [u objectForKey:@"name"];
    
    return cell;
}

- (IBAction)prevAction:(id)sender {
    NSNumber *n_off = [self.data objectForKey:@"offset"];
    [self.drupal whoisonline:self offset:(n_off.intValue - 20)];
}

- (IBAction)nextAction:(id)sender {
    NSNumber *n_off = [self.data objectForKey:@"offset"];
    [self.drupal whoisonline:self offset:(n_off.intValue + 20)];
}
@end
