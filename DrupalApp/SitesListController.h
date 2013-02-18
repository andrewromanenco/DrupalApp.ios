//
//  SitesListController.h
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-28.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import <UIKit/UIKit.h>

//
// Controller to display available sites
//
@interface SitesListController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;

@end
