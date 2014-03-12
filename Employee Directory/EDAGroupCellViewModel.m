//
//  EDAGroupCellViewModel.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAGroupCellViewModel.h"

#import "EDAGroup.h"

@implementation EDAGroupCellViewModel

- (id)initWithGroup:(EDAGroup *)group {
    self = [super init];
    if (self == nil) return nil;
    
    _group = group;
    
    RAC(self, displayName) = RACObserve(group, displayName);
    
    return self;
}

@end
