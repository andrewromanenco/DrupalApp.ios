//
//  AboutController.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-02-05.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()

@end

@implementation AboutController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        NSURL *url = [NSURL URLWithString:@"http://www.drupal.md/"];
        [[UIApplication sharedApplication] openURL:url];
    } else if (indexPath.row == 2) {
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setToRecipients:@[@"Andrew Romanenco <andrew@romanenco.com>"]];
            [controller setSubject:@"Drupal.ios"];
            [controller setMessageBody:@"Type in support or feature request. Tnx" isHTML:NO];
            if (controller) [self presentViewController:controller animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Mail is not available"
                                  message:@"Please, send email to andrew@romanenco.com"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    } else if (indexPath.row == 3) {
        NSURL *url = [NSURL URLWithString:@"https://github.com/AndrewRomanenco/DrupalApp.ios/issues"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
