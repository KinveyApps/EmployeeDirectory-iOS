//
//  EDASelectableEmployee.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDASelectableEmployeeCell.h"

#import "EDASelectableEmployeeCellViewModel.h"

@implementation EDASelectableEmployeeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self == nil) return nil;
    
    RAC(self, accessoryType) = [[[RACObserve(self, object)
        map:^RACSignal *(EDASelectableEmployeeCellViewModel *viewModel) {
            return RACObserve(viewModel, selected);
        }]
        switchToLatest]
        map:^NSNumber *(NSNumber *selected) {
            if (selected.boolValue) {
                return @(UITableViewCellAccessoryCheckmark);
            }
            else {
                return @(UITableViewCellAccessoryNone);
            }
        }];
    
    return self;
}

@end
