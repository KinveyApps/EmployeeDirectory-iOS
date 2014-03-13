//
//  EDASelectableEmployeeCellViewModel.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDADirectoryCellViewModel.h"

@interface EDASelectableEmployeeCellViewModel : EDADirectoryCellViewModel

@property (nonatomic) BOOL selected;

- (id)initWithEmployee:(EDAEmployee *)employee selected:(BOOL)selected;

@end
