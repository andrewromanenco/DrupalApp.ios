//
//  SiteStatusController.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-02-01.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "SiteStatusController.h"

@interface SiteStatusController ()

@end

@implementation SiteStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.drupal siteStatus:self];
}

- (void)drupal_status:(NSDictionary *)data {
    NSString *msg = [data objectForKey:@"message"];
    if (![msg isEqualToString:@"ok"]) {
        [self alert:@"Call failed!" title:@"System error!"];
        return;
    }
    self.items = [data objectForKey:@"items"];
    [self.table reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SiteStatusCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    
    if ([item objectForKey:@"description"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [item objectForKey:@"title"];
    
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [item objectForKey:@"value"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    NSString *description = [item objectForKey:@"description"];
    if (description) {
        self.descriptionTextView.text = description;
        self.descriptionLayer.hidden = NO;
    }
}

- (IBAction)closeDescriptionAction:(id)sender {
    self.descriptionLayer.hidden = YES;
}

@end
