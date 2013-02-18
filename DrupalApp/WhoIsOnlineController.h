//
//  WhoIsOnlineController.h
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-02-01.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "DrupalClientController.h"

@interface WhoIsOnlineController : DrupalClientController

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *prevBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBtn;

@property (strong) NSDictionary *data;

- (IBAction)prevAction:(id)sender;
- (IBAction)nextAction:(id)sender;
@end
