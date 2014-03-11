//
//  EDADirectoryViewModel.h
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EDADirectoryViewModelSortStyle) {
    EDADirectoryViewModelSortStyleName,
    EDADirectoryViewModelSortStyleGroup
};

@interface EDADirectoryViewModel : NSObject

@property (nonatomic) EDADirectoryViewModelSortStyle sortStyle;

@property (readonly, nonatomic) NSArray *sections;
@property (readonly, nonatomic) NSArray *sectionTitles;

@property (readonly, nonatomic) RACSignal *errors;

@end
