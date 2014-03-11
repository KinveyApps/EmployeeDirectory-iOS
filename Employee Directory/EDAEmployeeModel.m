//
//  EDAEmployeeModel.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployeeModel.h"

#import "EDAEmployee.h"

@interface EDAEmployeeModel ()

@property (nonatomic) EDAEmployee *employee;

@end

@implementation EDAEmployeeModel

- (id)initWithEmployee:(EDAEmployee *)employee {
    self = [super init];
    if (self == nil) return nil;
    
    _employee = employee;
    
    RAC(self, fullName) = [RACSignal
        combineLatest:@[ RACObserve(employee, firstName), RACObserve(employee, lastName) ]
        reduce:^NSString *(NSString *firstName, NSString *lastName){
            return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        }];
    RAC(self, title) = RACObserve(employee, title);
    
    return self;
}

@end
