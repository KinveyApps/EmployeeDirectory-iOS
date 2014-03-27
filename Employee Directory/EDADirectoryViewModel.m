//
//  EDADirectoryViewModel.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDADirectoryViewModel.h"

#import "EDADirectoryCellViewModel.h"
#import "EDAEmployee+API.h"
#import "EDAEmployee+Sorting.h"
#import "EDAFavorite+API.h"
#import "EDATag+API.h"

NSString * const EDADirectoryViewModelSortStyleKey = @"EDADirectoryViewModelSortStyle";

@interface EDADirectoryViewModel ()

@property (readwrite, nonatomic) NSArray *sections;
@property (readwrite, nonatomic) NSArray *sectionTitles;

@property (readwrite, nonatomic) NSArray *filteredSections;
@property (readwrite, nonatomic) NSArray *filteredSectionTitles;

@property (readwrite, nonatomic) BOOL showInstructions;

@property (nonatomic) BOOL searchMode;
@property (nonatomic) NSArray *employees;

@property (nonatomic) NSArray *tags;
@property (nonatomic) NSArray *tagTypes;

@end

@implementation EDADirectoryViewModel

- (id)initWithAllEmployees {
    self = [self init];
    [self setupWithEmployeeSignal:[EDAEmployee allEmployees]];
    return self;
}

- (id)initWithDirectReportsOfEmployee:(EDAEmployee *)employee {
    self = [self init];
    [self setupWithEmployeeSignal:[EDAEmployee directReportsOfEmployee:employee]];
    return self;
}

- (id)initForSearching {
    self = [self init];
    
    self.searchMode = YES;
    
    RACSignal *employeesSignal = [[RACObserve(self, searchString)
        map:^RACSignal *(NSString *string) {
            if (string.length == 0) {
                return [RACSignal return:@[]];
            }
            else {
                return [[EDAEmployee employeesMatchingSearchString:string] catchTo:[RACSignal return:nil]];
            }
        }]
        switchToLatest];
    
    [self setupWithEmployeeSignal:employeesSignal];
    
    return self;
}

- (id)initWithFavorites {
    self = [self init];
    
    RACSignal *favoritesSignal = [[[EDAFavorite allFavorites]
        map:^NSArray *(NSArray *favorites) {
            return [[favorites.rac_sequence map:^NSString *(EDAFavorite *favorite) {
                return favorite.favoriteUsername;
            }] array];
        }]
        flattenMap:^RACStream *(NSArray *usernames) {
            return [EDAEmployee employeesWithUsernames:usernames];
        }];
    
    [self setupWithEmployeeSignal:favoritesSignal];
    
    return self;
}

- (id)init {
    self = [super init];
    if (self == nil) return nil;
    
    RACChannelTerminal *sortChannel = RACChannelTo(self, sortStyle);
    RACChannelTerminal *userDefaultsChannel = [[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:EDADirectoryViewModelSortStyleKey];
    [[userDefaultsChannel
        map:^NSNumber *(NSNumber *style) {
            if (style == nil) return @0;
            else return style;
        }]
        subscribe:sortChannel];
    [[sortChannel
        skip:1]
        subscribe:userDefaultsChannel];
    
    RAC(self, showInstructions) = [RACSignal
        combineLatest:@[ RACObserve(self, searchMode), RACObserve(self, searchString) ]
        reduce:^NSNumber *(NSNumber *searchMode, NSString *searchString){
            return @(searchMode.boolValue && searchString.length == 0);
        }];
    
    return self;
}

- (void)setupWithEmployeeSignal:(RACSignal *)signal
{
    RACSignal *employeesSignal = [[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:KCSActiveUserChangedNotification object:nil]
        startWith:nil]
        flattenMap:^RACStream *(id value) {
            if ([KCSUser activeUser]) {
                return signal;
            }
            else {
                return [RACSignal return:@[]];
            }
        }]
        map:^NSArray*(NSArray *employees) {
            NSArray *sortedEmployees = [employees sortedArrayUsingDescriptors:[EDAEmployee standardSortDescriptors]];
            
            return [[sortedEmployees.rac_sequence map:^EDADirectoryCellViewModel*(EDAEmployee *employee) {
                return [[EDADirectoryCellViewModel alloc] initWithEmployee:employee];
            }] array];
        }];
    
    RACSignal *tagsSignal = [[[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:KCSActiveUserChangedNotification object:nil]
        startWith:nil]
        flattenMap:^RACStream *(id value) {
            return [EDATag allTags];
        }]
        publish]
        autoconnect];
    
    RAC(self, tags) = tagsSignal;
    RAC(self, tagTypes) = [tagsSignal
        map:^NSArray *(NSArray *tags) {
            NSArray *sortedTags = [tags sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES selector:@selector(localizedStandardCompare:)] ]];
            NSSet *usedTagTypes = [sortedTags.rac_sequence foldLeftWithStart:[NSSet set] reduce:^NSSet *(NSSet *accumulator, EDATag *tag) {
                return [accumulator setByAddingObject:@(tag.tagType)];
            }];
            return [usedTagTypes allObjects];
        }];
    
    RACSignal *employeesAndTagsSignal = [[[RACSignal combineLatest:@[ employeesSignal, tagsSignal ]]
        publish]
        autoconnect];
    
    RAC(self, employees) = [[employeesAndTagsSignal
        map:^NSArray *(RACTuple *tuple) {
            return tuple.first;
        }]
        catch:^RACSignal *(NSError *error) {
            return [RACSignal return:nil];
        }];
    
    _errors = [[employeesAndTagsSignal
        ignoreValues]
        catch:^RACSignal *(NSError *error) {
            return [RACSignal return:error];
        }];
    
    RACSignal *sectionDictionary = [RACSignal
        combineLatest:@[ RACObserve(self, employees), RACObserve(self, sortStyle), RACObserve(self, tagTypes), RACObserve(self, tags) ]
        reduce:^NSDictionary *(NSArray *employees, NSNumber *sortStyleNumber, NSArray *tagTypes, NSArray *tags){
            EDADirectoryViewModelSortStyle sortStyle = sortStyleNumber.integerValue;
            
            NSDictionary *sections = [employees.rac_sequence foldLeftWithStart:[NSMutableDictionary new] reduce:^id(NSMutableDictionary *dictionary, EDADirectoryCellViewModel *viewModel) {
                NSString *key;
                if (sortStyle == EDADirectoryViewModelSortStyleGroup) {
                    key = viewModel.employee.department;
                }
                else if (sortStyle == EDADirectoryViewModelSortStyleName) {
                    key = [[viewModel.employee.lastName substringToIndex:1] uppercaseStringWithLocale:[NSLocale currentLocale]];
                }
                else {
                    EDATag *tag = [[tags.rac_sequence
                        filter:^BOOL(EDATag *aTag) {
                            return [aTag.taggedUsername isEqualToString:viewModel.employee.username];
                        }]
                        head];
                    if (tag == nil) key = [EDATag displayNameForType:EDATagTypeNone];
                    else key = tag.displayName;
                }
                
                if (key != nil) {
                    if (dictionary[key] == nil) {
                        dictionary[key] = @[];
                    }
                    
                    NSArray *array = dictionary[key];
                    array = [array arrayByAddingObject:viewModel];
                    dictionary[key] = array;
                }
                
                return dictionary;
            }];
            return sections;
        }];
    
    RAC(self, sectionTitles) = [sectionDictionary
        map:^NSArray *(NSDictionary *dictionary) {
            NSArray *keys = [dictionary.allKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
            return keys;
        }];
    
    RAC(self, sections) = [RACSignal
        combineLatest:@[ sectionDictionary, RACObserve(self, sectionTitles) ]
        reduce:^NSArray *(NSDictionary *sections, NSArray *titles){
            return [[titles.rac_sequence
                map:^NSArray *(NSString *title) {
                    return sections[title];
                }]
                array];
        }];
    
    RACSignal *filteredSectionDictionary = [RACSignal
        combineLatest:@[ sectionDictionary, RACObserve(self, searchString) ]
        reduce:^NSDictionary *(NSDictionary *dictionary, NSString *searchString){
            if (searchString.length == 0) return @{};
            
            NSMutableDictionary *filteredDictionary = [NSMutableDictionary new];
            
            for (id key in dictionary.allKeys) {
                NSArray *values = dictionary[key];
                NSArray *filteredValues = [[values.rac_sequence filter:^BOOL(EDADirectoryCellViewModel *viewModel) {
                    NSInteger location = [viewModel.fullName rangeOfString:searchString options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location;
                    return location != NSNotFound;
                }] array];
                if (filteredValues.count > 0) {
                    filteredDictionary[key] = filteredValues;
                }
            }
            
            return filteredDictionary;
        }];
    
    RAC(self, filteredSectionTitles) = [filteredSectionDictionary
        map:^NSArray *(NSDictionary *dictionary) {
            NSArray *keys = [dictionary.allKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        return keys;
        }];
    
    RAC(self, filteredSections) = [RACSignal
        combineLatest:@[ filteredSectionDictionary, RACObserve(self, filteredSectionTitles) ]
        reduce:^NSArray *(NSDictionary *sections, NSArray *titles){
            return [[titles.rac_sequence
                map:^NSArray *(NSString *title) {
                    return sections[title];
                }]
                array];
        }];
}

@end
