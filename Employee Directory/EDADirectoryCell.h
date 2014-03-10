//
//  EDADirectoryCell.h
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EPSReactiveTableViewController.h"

@class EDADirectoryCellViewModel;

@interface EDADirectoryCell : UITableViewCell <EPSReactiveTableViewCell>

@property (nonatomic) EDADirectoryCellViewModel *object;

@end
