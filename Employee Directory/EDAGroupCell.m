//
//  EDAGroupCell.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAGroupCell.h"

#import "EDAGroupCellViewModel.h"

@implementation EDAGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.textColor = CVTDarkTextColor;
        
        RAC(self.textLabel, text) = [[RACObserve(self, object)
            map:^RACSignal *(EDAGroupCellViewModel *viewModel) {
                return RACObserve(viewModel, displayName);
            }]
            switchToLatest];
    }
    return self;
}


@end
