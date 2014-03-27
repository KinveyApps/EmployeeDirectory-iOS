//
//  EDAEmployeeInfo+API.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/27/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployeeInfo+API.h"

#import "EDAImageManager.h"

@implementation EDAEmployeeInfo (API)

+ (KCSAppdataStore *)appdataStore {
    KCSAppdataStore *appdataStore = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName: @"EmployeeInfos",
                                                                         KCSStoreKeyCollectionTemplateClass: [EDAEmployeeInfo class] }];
    return appdataStore;
}

+ (RACSignal *)infoForEmployeeWithID:(NSString *)employeeID {
    if (employeeID.length == 0) return [RACSignal return:nil];
    
    return [[[self appdataStore] rac_queryWithQuery:[KCSQuery queryOnField:@"userID" withExactMatchForValue:employeeID]]
        map:^EDAEmployeeInfo *(NSArray *objects) {
            return objects.firstObject;
        }];
}

- (RACSignal *)downloadAvatar {
    NSURL *avatarURL = [NSURL URLWithString:self.avatarURL];
    
    if (avatarURL == nil) return [RACSignal return:nil];
    
    return [[EDAImageManager sharedManager] imageFromURL:avatarURL];
}

- (RACSignal *)update {
    return [RACSignal return:self];
    
    @weakify(self);
    
    return [[[[EDAEmployeeInfo appdataStore] rac_loadObjectWithID:self.entityID]
        doNext:^(EDAEmployeeInfo *employee) {
            @strongify(self);

            self.headline = employee.headline;
            self.summary = employee.summary;
            self.avatarURL = employee.avatarURL;
            self.linkedInID = employee.linkedInID;
        }]
        map:^EDAEmployeeInfo *(EDAEmployeeInfo *employeeInfo) {
            @strongify(self);

            return self;
        }];
}

@end
