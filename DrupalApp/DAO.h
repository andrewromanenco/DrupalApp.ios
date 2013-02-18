//
//  DAO.h
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-28.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _SITE_NAME_             @"name"
#define _SITE_ADDRESS_          @"address"
#define _SITE_USERNAME_         @"username"
#define _SITE_PASSWORD_         @"password"


//
// DAO layer is based on UserDefaults as data volume to store is small
//
@interface DAO : NSObject

// Get instance
+ (DAO*)instance;

// Returns list of sites
// Each site is represented with NSDictionary[name, address]
- (NSArray*)listAllSites;

// Create site
// Address is full url (e.g. https://www.google.com/)
// This implementation requires name and address to be checked for duplication
// before create call
- (void)createSite:(NSString*)name address:(NSString*)address;

// Remove site by name
- (void)deleteSite:(NSString*)name;

// Remember username and password (nil to forget)
- (void)remember:(NSString*)siteName username:(NSString*)username password:(NSString*)password;

@end
