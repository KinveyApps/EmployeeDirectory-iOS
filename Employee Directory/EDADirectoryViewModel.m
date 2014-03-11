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

@interface EDADirectoryViewModel ()

@property (readwrite, nonatomic) NSArray *sections;
@property (readwrite, nonatomic) NSArray *sectionTitles;

@property (nonatomic) NSArray *employees;

@end

@implementation EDADirectoryViewModel

- (id)init
{
    self = [super init];
    if (self) {
        RACSignal *employeesSignal = [[EDAEmployee allEmployees] map:^NSArray*(NSArray *employees) {
            return [[employees.rac_sequence map:^EDADirectoryCellViewModel*(EDAEmployee *employee) {
                return [[EDADirectoryCellViewModel alloc] initWithEmployee:employee];
            }] array];
        }];
        
        RAC(self, employees) = [employeesSignal
            catch:^RACSignal *(NSError *error) {
                return [RACSignal empty];
            }];
        
        _errors = [[employeesSignal
            ignoreValues]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal return:error];
            }];
        
        RACSignal *sectionDictionary = [RACSignal
            combineLatest:@[ RACObserve(self, employees), RACObserve(self, sortStyle) ]
            reduce:^NSDictionary *(NSArray *employees, NSNumber *sortStyleNumber){
                EDADirectoryViewModelSortStyle sortStyle = sortStyleNumber.integerValue;
                
                NSDictionary *sections = [employees.rac_sequence foldLeftWithStart:[NSMutableDictionary new] reduce:^id(NSMutableDictionary *dictionary, EDADirectoryCellViewModel *viewModel) {
                    NSString *key;
                    if (sortStyle == EDADirectoryViewModelSortStyleGroup) {
                        key = viewModel.employee.group;
                    }
                    else {
                        key = [[viewModel.employee.lastName substringToIndex:1] uppercaseStringWithLocale:[NSLocale currentLocale]];
                    }
                    
                    if (dictionary[key] == nil) {
                        dictionary[key] = @[];
                    }
                    
                    NSArray *array = dictionary[key];
                    array = [[array arrayByAddingObject:viewModel] sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"employee.lastName" ascending:YES selector:@selector(localizedStandardCompare:)], [NSSortDescriptor sortDescriptorWithKey:@"employee.firstName" ascending:YES selector:@selector(localizedStandardCompare:)] ]];
                    dictionary[key] = array;
                    
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
    }
    
    return self;
}

@end
