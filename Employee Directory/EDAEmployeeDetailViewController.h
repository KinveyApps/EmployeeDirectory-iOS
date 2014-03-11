//
//  EDAEmployeeDetailViewController.h
//  Employee Directory
//
//  Created by Justin Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EDAEmployeeModel, EDAEmployee;

@interface EDAEmployeeDetailViewController : UIViewController

- (id)initWithEmployee:(EDAEmployee *)employee;

@end
