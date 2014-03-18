//
//  EDAGroupCellViewModel.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EDATag.h"

@class EDAGroup;

@interface EDAGroupCellViewModel : NSObject

@property (readonly, nonatomic) EDAGroup *group;
@property (readonly, nonatomic) EDATagType tagType;
@property (readonly, nonatomic) NSString *displayName;

- (id)initWithGroup:(EDAGroup *)group;
- (id)initWithTagType:(EDATagType)tagType;

@end
