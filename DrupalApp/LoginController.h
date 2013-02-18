//
//  LoginController.h
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-29.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrupalClientController.h"

@interface LoginController : DrupalClientController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UISwitch *remember;
@property (weak, nonatomic) IBOutlet UILabel *https;

@property (strong) NSString *savedUsername;
@property (strong) NSString *savedPassword;

- (IBAction)login:(id)sender;

@end
