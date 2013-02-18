//
//  DAO.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-28.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "DAO.h"

#define _SITES_             @"drupal_sites"

@implementation DAO

static DAO *dao;

+ (DAO*)instance {
    if (!dao) {
        dao = [[DAO alloc] init];
    }
    return dao;
}

- (NSArray*)listAllSites {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *list = [defaults objectForKey:_SITES_];
    if (!list) {
        return [NSArray array];
    } else {
        return list;
    }
}

- (void)createSite:(NSString*)name address:(NSString*)address {
    NSMutableDictionary *site = [NSMutableDictionary dictionary];
    [site setObject:name forKey:_SITE_NAME_];
    [site setObject:address forKey:_SITE_ADDRESS_];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *list = [[defaults objectForKey:_SITES_] mutableCopy];
    if (!list) {
        list = [NSMutableArray array];
    }
    [list addObject:site];
    [defaults setObject:list forKey:_SITES_];
    [defaults synchronize];
}

- (void)deleteSite:(NSString*)name {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *list = [[defaults objectForKey:_SITES_] mutableCopy];
    if (!list) return;
    int item = 0;
    for (NSDictionary *site in list) {
        NSString *str = [site objectForKey:_SITE_NAME_];
        if ([str isEqualToString:name]) {
            break;
        }
        item++;
    }
    if (item < [list count]) {
        [list removeObjectAtIndex:item];
        [defaults setObject:list forKey:_SITES_];
        [defaults synchronize];
    }
}

- (void)remember:(NSString*)siteName username:(NSString*)username password:(NSString*)password {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *list = [[defaults objectForKey:_SITES_] mutableCopy];
    if (!list) return;
    int index = 0;
    NSDictionary *site;
    for (site in list) {
        NSString *str = [site objectForKey:_SITE_NAME_];
        if ([str isEqualToString:siteName]) {
            NSMutableDictionary *msite = [site mutableCopy];
            if (username) {
                [msite setObject:username forKey:_SITE_USERNAME_];
            } else {
                [msite removeObjectForKey:_SITE_USERNAME_];
            }
            if (password) {
                [msite setObject:password forKey:_SITE_PASSWORD_];
            } else {
                [msite removeObjectForKey:_SITE_PASSWORD_];
            }
            [list replaceObjectAtIndex:index withObject:msite];
            [defaults setObject:list forKey:_SITES_];
            [defaults synchronize];
            break;
        }
        index++;
    }
}

@end
