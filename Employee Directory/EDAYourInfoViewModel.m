//
//  EDAYourInfoViewModel.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/11/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAYourInfoViewModel.h"

#import "EDAEmployee+API.h"

@implementation EDAYourInfoViewModel

- (id)init {
    self = [super init];
    if (self == nil) return nil;

    _getYourInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        KCSUser *currentUser = [KCSUser activeUser];
        
        return [EDAEmployee employeeWithUsername:currentUser.username];
    }];
    
    return self;
}

@end
