//
//  EDASelectableEmployeeCellViewModel.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDASelectableEmployeeCellViewModel.h"

@implementation EDASelectableEmployeeCellViewModel

- (id)initWithEmployee:(EDAEmployee *)employee selected:(BOOL)selected {
    self = [super initWithEmployee:employee];
    if (self == nil) return nil;
    
    _selected = selected;
    
    return self;
}

@end
