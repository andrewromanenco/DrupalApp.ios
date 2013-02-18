//
//  DrupalClientController.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-19.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DrupalClientController.h"

@interface DrupalClientController () {
    UIView *busy;
}

@end

@implementation DrupalClientController

- (void)alert:(NSString*)message {
    [self alert:message title:@""];
}

- (void)alert:(NSString *)message title:(NSString*)title {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];

}

// This is to forward current DrupalClient to children
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id dc = [segue destinationViewController];
    if (self.drupal && [dc isKindOfClass:[DrupalClientController class]]) {
        DrupalClientController *dcc = (DrupalClientController*)dc;
        dcc.drupal = self.drupal;
    }
}

- (void)drupal_call_start {
    NSLog(@"Drupal call start");
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    busy = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 25, 10, 50, 50)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [busy addSubview:view];
    view.backgroundColor = [UIColor blackColor];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.alpha = 0.6f;
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    act.center = CGPointMake(25, 25);
    [busy addSubview:act];
    [self.view addSubview:busy];
    [act startAnimating];
}

- (void)drupal_call_end {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [busy removeFromSuperview];
    busy = nil;
}

@end
