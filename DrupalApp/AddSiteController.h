//
//  AddSiteController.h
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-19.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrupalClientController.h"

@interface AddSiteController : DrupalClientController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *siteName;
@property (weak, nonatomic) IBOutlet UITextField *siteAddress;
@property (weak, nonatomic) IBOutlet UISwitch *httpsOn;

- (IBAction)addSiteAction:(id)sender;
@end
