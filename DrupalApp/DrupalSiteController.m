//
//  DrupalSiteController.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-29.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "DrupalSiteController.h"

@interface DrupalSiteController () {
    NSArray *_features;
}

@end

@implementation DrupalSiteController

- (void)viewDidLoad {
    // Hardcode for now
    // Should read from /info/
    _features = @[
        @[@"Site status", @"Logs", @"Updates", @"Who is online"],
        @[@"LOGOUT"],
        @[@"Support & Feature request"]
    ];
    self.title = self.drupal.name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_features count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_features objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ServiceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [[_features objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"gotoSiteStatus" sender:self];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"gotoLogs" sender:self];
                    break;
                case 2:
                    [self performSegueWithIdentifier:@"gotoUpdates" sender:self];
                    break;
                case 3:
                    [self performSegueWithIdentifier:@"gotoWhoIsOnline" sender:self];
                    break;
            }
            break;
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2:
            [self performSegueWithIdentifier:@"gotoAbout" sender:self];
            break;
    }
    
}

@end
