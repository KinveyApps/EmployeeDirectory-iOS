//
//  EDADirectoryViewModel.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDADirectoryViewModel.h"

#import "EDADirectoryCellViewModel.h"
#import "EDAEmployee+API.h"

@implementation EDADirectoryViewModel

- (id)init
{
    self = [super init];
    if (self) {
        RAC(self, employees) = [[EDAEmployee allEmployees] map:^NSArray*(NSArray* employees) {
            return [[employees.rac_sequence map:^EDADirectoryCellViewModel*(EDAEmployee* employee) {
                return [[EDADirectoryCellViewModel alloc] initWithEmployee:employee];
            }] array];
        }];
    }
    return self;
}

@end
