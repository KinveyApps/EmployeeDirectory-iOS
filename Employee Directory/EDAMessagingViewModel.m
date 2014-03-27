//
//  EDAMessagingViewModel.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAMessagingViewModel.h"

#import "EDAGroup+API.h"
#import "EDAGroup+Sorting.h"
#import "EDAEmployee+API.h"
#import "EDAGroupCellViewModel.h"
#import "EDATag+API.h"
#import "EDAFavorite+API.h"

NSString * const EDAMessagingViewModelGroupTypeKey = @"EDAMessagingViewModelGroupType";

@implementation EDAMessagingViewModel

- (id)init {
    self = [super init];
    if (self == nil) return nil;
    
    RACSignal *tagTypesSignal = [EDATag usedTagTypes];
    
    RAC(self, groups) = [[RACSignal
        combineLatest:@[ tagTypesSignal ]
        reduce:^NSArray *(NSArray *tagTypes){
            return [[tagTypes.rac_sequence
                map:^EDAGroupCellViewModel *(NSNumber *tagType) {
                    return [[EDAGroupCellViewModel alloc] initWithTagType:tagType.integerValue];
                }]
                array];
        }]
        catch:^RACSignal *(NSError *error) {
            return [RACSignal empty];
        }];
    
    return self;
}

@end
