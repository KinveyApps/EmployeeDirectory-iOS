//
//  EDADirectoryViewModel.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDADirectoryViewModel.h"

#import "EDADirectoryCellViewModel.h"

@implementation EDADirectoryViewModel

- (id)init
{
    self = [super init];
    if (self) {
        EDADirectoryCellViewModel *cellViewModel1 = [EDADirectoryCellViewModel new];
        EDADirectoryCellViewModel *cellViewModel2 = [EDADirectoryCellViewModel new];
        EDADirectoryCellViewModel *cellViewModel3 = [EDADirectoryCellViewModel new];
        
        self.employees = @[ cellViewModel1, cellViewModel2, cellViewModel3 ];

    }
    return self;
}

@end
