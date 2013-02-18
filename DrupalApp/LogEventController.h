//
//  LogEventController.h
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-02-04.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "DrupalClientController.h"

@interface LogEventController : DrupalClientController

@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (assign) int event;

@end
