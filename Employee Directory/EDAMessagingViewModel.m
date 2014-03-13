//
//  EDAMessagingViewModel.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAMessagingViewModel.h"

#import "EDAGroup+API.h"
#import "EDAGroup+Sorting.h"
#import "EDAEmployee+API.h"
#import "EDAGroupCellViewModel.h"

@implementation EDAMessagingViewModel

- (id)init {
    self = [super init];
    if (self == nil) return nil;
    
    RACSignal *employeesSignal = [[EDAEmployee employeeWithUsername:[[KCSUser activeUser] username]]
        flattenMap:^RACStream *(EDAEmployee *employee) {
            return [EDAEmployee directReportsOfEmployee:employee];
        }];
    RACSignal *groupsSignal = [EDAGroup allGroups];
    
    RAC(self, groups) = [[RACSignal
        combineLatest:@[ employeesSignal, groupsSignal ]
        reduce:^NSArray *(NSArray *employees, NSArray *groups){
            NSSet *usedIdentifiers = [NSSet setWithArray:[[employees.rac_sequence map:^NSString *(EDAEmployee *employee) {
                return employee.hierarchy;
            }] array]];
            NSArray *usedGroups = [[[groups.rac_sequence
                filter:^BOOL(EDAGroup *group) {
                    return [usedIdentifiers containsObject:group.identifier];
                }]
                map:^EDAGroupCellViewModel *(EDAGroup *group) {
                    return [[EDAGroupCellViewModel alloc] initWithGroup:group];
                }]
                array];
            NSArray *sortedGroups = [usedGroups sortedArrayUsingDescriptors:[EDAGroup standardSortDescriptors]];
            return sortedGroups;
        }]
        catch:^RACSignal *(NSError *error) {
            return [RACSignal empty];
        }];
    
    return self;
}

@end
