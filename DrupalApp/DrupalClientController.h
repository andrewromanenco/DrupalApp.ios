//
//  DrupalClientController.h
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-19.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrupalClient.h"

// Common controller for Drupal Api callers
@interface DrupalClientController : UIViewController <DrupalResponseHandler>

@property (nonatomic, strong) DrupalClient *drupal;

- (void)alert:(NSString*)message;
- (void)alert:(NSString *)message title:(NSString*)title;

@end
