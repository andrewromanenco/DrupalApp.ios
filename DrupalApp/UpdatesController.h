//
//  UpdatesController.h
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-02-01.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "DrupalClientController.h"

@interface UpdatesController : DrupalClientController

@property (weak, nonatomic) IBOutlet UILabel *lastCheck;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong) NSArray *updates;

@end
