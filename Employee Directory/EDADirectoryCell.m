//
//  EDADirectoryCell.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDADirectoryCell.h"

#import "EDADirectoryCellViewModel.h"

@interface EDADirectoryCell ()

@end

@implementation EDADirectoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self == nil) return nil;
    
    RAC(self.textLabel, text) = [[RACObserve(self, object)
        map:^RACSignal *(EDADirectoryCellViewModel *viewModel){
            return RACObserve(viewModel, fullName);
        }]
        switchToLatest];
    
    RAC(self.detailTextLabel, text) = [[RACObserve(self, object)
        map:^RACSignal *(EDADirectoryCellViewModel *viewModel) {
            return RACObserve(viewModel, title);
        }]
        switchToLatest];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
