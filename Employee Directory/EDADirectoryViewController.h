//
//  EDADirectoryViewController.h
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EPSReactiveTableViewController.h"

@class EDAEmployee;

@interface EDADirectoryViewController : UITableViewController

- (id)initWithAllEmployees;
- (id)initWithDirectReportsOfEmployee:(EDAEmployee *)employee;
- (id)initForSearching;
- (id)initWithFavorites;

@end
