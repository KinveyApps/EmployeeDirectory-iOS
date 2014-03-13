//
//  EDASelectEmployeesViewModel.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDASelectEmployeesViewModel.h"

#import "EDAEmployee+API.h"
#import "EDAEmployee+Sorting.h"
#import "EDASelectableEmployeeCellViewModel.h"

@interface EDASelectEmployeesViewModel ()

@property (readwrite, nonatomic) NSSet *selectedEmployees;

@end

@implementation EDASelectEmployeesViewModel

- (id)initWithGroup:(EDAGroup *)group {
    self = [super init];
    if (self == nil) return nil;
    
    @weakify(self);
    
    RACSignal *employeesSignal = [[[[EDAEmployee employeesInGroup:group]
        map:^NSArray *(NSArray *employees) {
            return [employees sortedArrayUsingDescriptors:[EDAEmployee standardSortDescriptors]];
        }]
        publish]
        autoconnect];
    
    [employeesSignal subscribeNext:^(NSArray *employees) {
        @strongify(self);
        
        self.selectedEmployees = [NSSet setWithArray:employees];
    }];
    
    RAC(self, employees) = [[RACSignal
        combineLatest:@[ employeesSignal, RACObserve(self, selectedEmployees) ]
        reduce:^NSArray *(NSArray *employees, NSArray *selectedEmployees){
            return [[employees.rac_sequence
                map:^EDASelectableEmployeeCellViewModel *(EDAEmployee *employee) {
                    return [[EDASelectableEmployeeCellViewModel alloc] initWithEmployee:employee selected:[selectedEmployees containsObject:employee]];
                }]
                array];
        }]
        catch:^RACSignal *(NSError *error) {
            return [RACSignal empty];
        }];
    
    RACSignal *enabled = [RACObserve(self, selectedEmployees) map:^NSNumber *(NSSet *selectedEmployees) {
        return @(selectedEmployees.count > 0);
    }];
    
    _nextCommand = [[RACCommand alloc] initWithEnabled:enabled signalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        return [RACSignal return:self.selectedEmployees];
    }];
    
    return self;
}

- (void)selectEmployee:(EDAEmployee *)employee {
    self.selectedEmployees = [self.selectedEmployees setByAddingObject:employee];
}

- (void)deselectEmployee:(EDAEmployee *)employee {
    NSMutableSet *set = self.selectedEmployees.mutableCopy;
    [set removeObject:employee];
    self.selectedEmployees = set;
}

@end
