//
//  EDADirectoryCellViewModel.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDADirectoryCellViewModel.h"

#import "EDAEmployee+API.h"
#import "EDAEmployeeInfo+API.h"

@interface EDADirectoryCellViewModel ()

@end

@implementation EDADirectoryCellViewModel

- (id)initWithEmployee:(EDAEmployee *)employee {
    self = [super init];
    if (self == nil) return nil;
    
    _employee = employee;
    
    RAC(self, image) = [[[[[EDAEmployeeInfo infoForEmployeeWithID:employee.username]
        flattenMap:^RACStream *(EDAEmployeeInfo *info) {
            if (info) return [info downloadAvatar];
            else return [RACSignal return:nil];
        }]
        startWith:[UIImage imageNamed:@"AvatarLoading"]]
        map:^UIImage *(UIImage *image) {
            if (image == nil) return [UIImage imageNamed:@"NoAvatar"];
            else return image;
        }]
        catch:^RACSignal *(NSError *error) {
            return [RACSignal empty];
        }];
    
    RAC(self, fullName) = [RACSignal
       combineLatest:@[ RACObserve(employee, firstName), RACObserve(employee, lastName) ]
       reduce:^NSString *(NSString *firstName, NSString *lastName){
            return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
       }];
    
    RAC(self, titleAndGroup) = [RACSignal
        combineLatest:@[ RACObserve(employee, title), RACObserve(employee, group) ]
        reduce:^NSString *(NSString *title, NSString *group){
            return [NSString stringWithFormat:@"%@", title];
        }];
    
    return self;
}

@end
