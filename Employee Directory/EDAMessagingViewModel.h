//
//  EDAMessagingViewModel.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EDAMessagingViewModelGroupType) {
    EDAMessagingViewModelGroupTypeGroup,
    EDAMessagingViewModelGroupTypeTag
};

@interface EDAMessagingViewModel : NSObject

/// An array of EDAGroupCellViewModel objects.
@property (readonly, nonatomic) NSArray *groups;

@end
