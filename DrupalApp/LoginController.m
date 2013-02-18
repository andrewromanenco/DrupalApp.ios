//
//  LoginController.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-29.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginController.h"
#import "DAO.h"

@interface LoginController() {
    bool _needLogout;
}

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [self.view viewWithTag:999];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    
    _needLogout = false;
    self.title = self.drupal.name;
    NSString *address = self.drupal.address;
    if ([address hasPrefix:@"https"]) {
        self.https.text = @"ON";
    } else {
        self.https.text = @"OFF";
    }
    
    if (self.savedUsername) self.username.text = self.savedUsername;
    if (self.savedPassword) {
        self.password.text = self.savedPassword;
        self.remember.on = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    if (_needLogout) {
        _needLogout = NO;
        [self.drupal logout:self];
    }
}

- (void)drupal_loggedOut {
    [self alert:@"You have been logged out"];
}

- (IBAction)login:(id)sender {
    if (([self.username.text length] > 0)&&(([self.username.text length] > 0))) {
        [self.drupal login:self username:self.username.text password:self.password.text];
    } else {
        [self alert:@"Both username and password\nare required."];
    }
}

- (void)drupal_loggedIn {
    NSLog(@"Logged in");
    _needLogout = YES;
    if (self.remember.on) {
        [[DAO instance] remember:self.drupal.name
                        username:self.username.text
                        password:self.password.text];
    } else {
        [[DAO instance] remember:self.drupal.name
                        username:self.username.text
                        password:nil];
        self.password.text = @"";
    }
    [self performSegueWithIdentifier:@"gotoSite" sender:self];
}

- (void)drupal_unauthorized {
    NSLog(@"Access denied");
    self.password.text = @"";
    [[DAO instance] remember:self.drupal.name
                    username:self.username.text
                    password:nil];
    [self alert:@"Access denied"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.username) {
        [self.password becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self login:nil];
    }
    return NO;
}

@end
