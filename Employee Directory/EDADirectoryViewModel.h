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
    EDADirectoryViewModelSortStyleGroup,
    EDADirectoryViewModelSortStyleTag
};

@class EDAEmployee;

@interface EDADirectoryViewModel : NSObject

@property (nonatomic) EDADirectoryViewModelSortStyle sortStyle;

@property (readonly, nonatomic) NSArray *sections;
@property (readonly, nonatomic) NSArray *sectionTitles;

@property (readonly, nonatomic) NSArray *filteredSections;
@property (readonly, nonatomic) NSArray *filteredSectionTitles;
@property (nonatomic) NSString *searchString;

@property (readonly, nonatomic) BOOL showInstructions;

@property (readonly, nonatomic) RACSignal *errors;

- (id)initWithAllEmployees;
- (id)initWithDirectReportsOfEmployee:(EDAEmployee *)employee;
- (id)initForSearching;
- (id)initWithFavorites;

@end
