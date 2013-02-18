//
//  SiteStatusController.h
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-02-01.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "DrupalClientController.h"

@interface SiteStatusController : DrupalClientController

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIView *descriptionLayer;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong) NSArray *items;

- (IBAction)closeDescriptionAction:(id)sender;

@end
