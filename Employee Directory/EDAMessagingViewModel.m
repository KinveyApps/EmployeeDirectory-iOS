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
#import "EDATag+API.h"

NSString * const EDAMessagingViewModelGroupTypeKey = @"EDAMessagingViewModelGroupType";

@implementation EDAMessagingViewModel

- (id)init {
    self = [super init];
    if (self == nil) return nil;
    
    RACChannelTerminal *sortChannel = RACChannelTo(self, groupType);
    RACChannelTerminal *userDefaultsChannel = [[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:EDAMessagingViewModelGroupTypeKey];
    [[userDefaultsChannel
        map:^NSNumber *(NSNumber *style) {
            if (style == nil) return @0;
            else return style;
        }]
        subscribe:sortChannel];
    [[sortChannel
        skip:1]
        subscribe:userDefaultsChannel];

    RACSignal *employeesSignal = [[EDAEmployee employeeWithUsername:[[KCSUser activeUser] username]]
        flattenMap:^RACStream *(EDAEmployee *employee) {
            return [EDAEmployee directReportsOfEmployee:employee];
        }];
    RACSignal *groupsSignal = [EDAGroup allGroups];
    RACSignal *tagTypesSignal = [EDATag usedTagTypes];
    
    RAC(self, groups) = [[RACSignal
        combineLatest:@[ employeesSignal, groupsSignal, RACObserve(self, groupType), tagTypesSignal ]
        reduce:^NSArray *(NSArray *employees, NSArray *groups, NSNumber *groupType, NSArray *tagTypes){
            if (groupType.integerValue == EDAMessagingViewModelGroupTypeGroup) {
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
            }
            else {
                return [[tagTypes.rac_sequence
                    map:^EDAGroupCellViewModel *(NSNumber *tagType) {
                        return [[EDAGroupCellViewModel alloc] initWithTagType:tagType.integerValue];
                    }]
                    array];
            }
        }]
        catch:^RACSignal *(NSError *error) {
            return [RACSignal empty];
        }];
    
    return self;
}

@end
