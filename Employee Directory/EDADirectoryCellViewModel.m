//
//  EDADirectoryCellViewModel.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDADirectoryCellViewModel.h"

#import "EDAEmployee+API.h"

@interface EDADirectoryCellViewModel ()

@end

@implementation EDADirectoryCellViewModel

- (id)initWithEmployee:(EDAEmployee *)employee {
    self = [super init];
    if (self == nil) return nil;
    
    _employee = employee;
    
    RAC(self, image) = [[employee downloadAvatar]
        catch:^RACSignal *(NSError *error) {
            return [RACSignal empty];
        }];
    
    RAC(self, fullName) = [RACSignal
       combineLatest:@[ RACObserve(employee, firstName), RACObserve(employee, lastName) ]
       reduce:^NSString *(NSString *firstName, NSString *lastName){
            return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
       }];
    
    RAC(self, title) = RACObserve(employee, title);
    
    return self;
}

@end
