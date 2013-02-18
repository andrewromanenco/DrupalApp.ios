//
//  Utils.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-27.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "Utils.h"

@implementation Utils

//
// Remove http/https if it was entered by user
// Adds protocol and slashes
// Result is lowercased
//
+ (NSString*)makeServiceUrl:(NSString*)address https:(BOOL)https {
    address = [[address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    if ((address == nil)||([address length] == 0)) {
        return nil;
    }
    
    address = [address lowercaseString];
    if ([address hasPrefix:@"https://"]) {
        address = [address substringFromIndex:8];
    } else if ([address hasPrefix:@"http://"]) {
        address = [address substringFromIndex:7];
    }
    
    if (![address hasSuffix:@"/"]) {
        address = [NSString stringWithFormat:@"%@/", address];
    }
    if (https) {
        address = [NSString stringWithFormat:@"https://%@", address];
    } else {
        address = [NSString stringWithFormat:@"http://%@", address];
    }
    return address;
}

@end
