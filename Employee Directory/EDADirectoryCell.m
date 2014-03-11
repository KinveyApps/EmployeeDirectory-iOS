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
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.textLabel.textColor = CVTDarkTextColor;
    self.detailTextLabel.textColor = CVTDarkTextColor;
    
    @weakify(self);
    
    RAC(self.imageView, image) = [[[RACObserve(self, object)
        map:^RACSignal *(EDADirectoryCellViewModel *viewModel) {
            return RACObserve(viewModel, image);
        }]
        switchToLatest]
        doNext:^(UIImage *image) {
            @strongify(self);
            
            [self setNeedsLayout];
        }];

    RAC(self.textLabel, text) = [[RACObserve(self, object)
        map:^RACSignal *(EDADirectoryCellViewModel *viewModel){
            return RACObserve(viewModel, fullName);
        }]
        switchToLatest];
    
    RAC(self.detailTextLabel, text) = [[RACObserve(self, object)
        map:^RACSignal *(EDADirectoryCellViewModel *viewModel) {
            return RACObserve(viewModel, titleAndGroup);
        }]
        switchToLatest];
    
    return self;
}

@end
