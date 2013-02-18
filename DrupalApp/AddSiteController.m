//
//  AddSiteController.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-19.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AddSiteController.h"
#import "DAO.h"
#import "Utils.h"

@interface AddSiteController ()

- (BOOL)siteNameExists:(NSString*)name;
- (BOOL)siteAddressExists:(NSString*)address;

@end

@implementation AddSiteController

- (void)viewDidLoad {
    UIView *view = [self.view viewWithTag:999];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
}

- (IBAction)addSiteAction:(id)sender {
    [self.siteName resignFirstResponder];
    [self.siteAddress resignFirstResponder];
    NSString *name = [self.siteName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *address = [Utils makeServiceUrl:self.siteAddress.text https:self.httpsOn.on];
    if (([name length] == 0)||([address length] == 0)) {
        [self alert:@"Please, enter both\n name and site address."];
    } else if ([self siteNameExists:name]) {
        [self alert:@"Site with the same name\n already exists."];
    } else if ([self siteAddressExists:address]) {
        [self alert:@"Site with the same address\n already exists."];
    } else {
        self.drupal = [[DrupalClient alloc ]init:name url:address];
        [self.drupal getDrupalInfo:self];
    }
}

- (void)drupal_notFound {
    [self alert:@"This site does not have required module installed. Visit drupal.md to download."];
}

- (void)drupal_info:(NSDictionary*)info {
    NSString *address = [self.siteAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [[DAO instance]
     createSite:self.siteName.text
     address:[Utils makeServiceUrl:address https:self.httpsOn.on]
     ];
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"Site saved");
}

- (BOOL)siteNameExists:(NSString*)name {
    NSString *namelc = [[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    NSArray *list = [[DAO instance] listAllSites];
    for (NSDictionary *site in list) {
        NSString *current = [site objectForKey:_SITE_NAME_];
        NSLog(@"%@ - %@", current, namelc);
        if ([[current lowercaseString] isEqualToString:namelc]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)siteAddressExists:(NSString*)address {
    NSString *addresslc = [[address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    NSArray *list = [[DAO instance] listAllSites];
    for (NSDictionary *site in list) {
        NSString *current = [site objectForKey:_SITE_ADDRESS_];
        if ([[current lowercaseString] isEqualToString:addresslc]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.siteName) {
        [self.siteAddress becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self addSiteAction:nil];
    }
    return NO;
}

@end
