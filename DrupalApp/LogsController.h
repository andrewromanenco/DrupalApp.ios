//
//  LogsController.h
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-02-03.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "DrupalClientController.h"

@interface LogsController : DrupalClientController

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *prevBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBtn;

- (IBAction)prevAction:(id)sender;
- (IBAction)nextAction:(id)sender;

@end
