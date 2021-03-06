//
//  EDAEmployee+API.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployee.h"

@class EDAGroup;
@class EDAFavorite;

extern NSString * const EDAEmployeeErrorDomain;

extern NSInteger const EDAEmployeeErrorCodeUserNotFound;

@interface EDAEmployee (API)

+ (KCSAppdataStore *)appdataStore;

/// @return A signal which sends an array of all employees.
+ (RACSignal *)allEmployees;

/// @return A signal which sends an EDAEmployee object with the given username.
+ (RACSignal *)employeeWithUsername:(NSString *)username;

/// @return A signal which sends an array of employees who are direct reports of the given employee.
+ (RACSignal *)directReportsOfEmployee:(EDAEmployee *)employee;

/// @return A signal which sends an array of employees in the given group.
+ (RACSignal *)employeesInGroup:(EDAGroup *)group;

/// @return A signal which sends an array of employees matching the search string.
+ (RACSignal *)employeesMatchingSearchString:(NSString *)searchString;

/// @return A signal which sends an array of employee objects for the given usernames
+ (RACSignal *)employeesWithUsernames:(NSArray *)usernames;

+ (RACSignal *)employeeMatchingFavorite:(EDAFavorite *)favorite;

+ (RACSignal *)employeesMatchingFavorites:(NSArray *)favorites;

@end
