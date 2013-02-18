//
//  Utils.h
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-27.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

//Format valid url from user input according
+ (NSString*)makeServiceUrl:(NSString*)address https:(BOOL)https;

@end
