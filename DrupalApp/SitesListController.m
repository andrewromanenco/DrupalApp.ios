//
//  SitesListController.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-28.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "SitesListController.h"
#import "DAO.h"
#import "LoginController.h"

@interface SitesListController () {
    NSArray *sitesCache;
}

@end

@implementation SitesListController

- (void)viewWillAppear:(BOOL)animated {
    [self.table reloadData];
}

//
// UITableView related logic
//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    sitesCache = [[DAO instance] listAllSites];
    return [sitesCache count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SiteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *site = [sitesCache objectAtIndex:indexPath.row];
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [site objectForKey:_SITE_NAME_];
    
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [site objectForKey:_SITE_ADDRESS_];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"gotoLogin" sender:[sitesCache objectAtIndex:indexPath.row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *site  =[sitesCache objectAtIndex:indexPath.row];
        [[DAO instance] deleteSite:[site objectForKey:_SITE_NAME_]];
        [self.table reloadData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"gotoLogin"]) {
        LoginController *lc = [segue destinationViewController];
        NSDictionary *site = sender;
        DrupalClient *drupal = [[DrupalClient alloc] init:[site objectForKey:_SITE_NAME_] url:[site objectForKey:_SITE_ADDRESS_]];
        lc.drupal = drupal;
        lc.savedUsername = [site objectForKey:_SITE_USERNAME_];
        lc.savedPassword = [site objectForKey:_SITE_PASSWORD_];
    }
}

@end
