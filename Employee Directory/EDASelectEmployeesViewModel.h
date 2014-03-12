//
//  EDASelectEmployeesViewModel.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EDAGroup;
@class EDAEmployee;

@interface EDASelectEmployeesViewModel : NSObject

/// An array of EDASelectableEmployeeCellViewModel objects.
@property (readonly, nonatomic) NSArray *employees;

/// A set of EDAEmployee objects
@property (readonly, nonatomic) NSSet *selectedEmployees;

/// Sends a set of employees to message
@property (readonly, nonatomic) RACCommand *nextCommand;

- (id)initWithGroup:(EDAGroup *)group;

- (void)selectEmployee:(EDAEmployee *)employee;
- (void)deselectEmployee:(EDAEmployee *)employee;

@end
