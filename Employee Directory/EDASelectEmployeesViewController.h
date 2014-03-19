//
//  EDASelectEmployeesViewController.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EPSReactiveTableViewController.h"

#import "EDATag.h"

@class EDAGroup;

@interface EDASelectEmployeesViewController : EPSReactiveTableViewController

- (id)initWithGroup:(EDAGroup *)group;
- (id)initWithTagType:(EDATagType)tagType;

@end
