//
//  EDAEmployee+API.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployee+API.h"

NSString * const EDAEmployeeErrorDomain = @"com.ballastlane.employeedirectory.employee";

NSInteger const EDAEmployeeErrorCodeUserNotFound = 1;

@implementation EDAEmployee (API)

+ (KCSAppdataStore *)appdataStore {
    return [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName: @"Employees",
                                                KCSStoreKeyCollectionTemplateClass: [EDAEmployee class] }];
}

+ (RACSignal *)allEmployees {
    return [[self appdataStore] rac_queryWithQuery:[KCSQuery query]];
}

+ (RACSignal *)employeeWithUsername:(NSString *)username {
    KCSQuery *query = [KCSQuery queryOnField:@"username" withExactMatchForValue:username];
    return [[[self appdataStore] rac_queryWithQuery:query]
        flattenMap:^RACStream *(NSArray *users) {
            if (users.count == 0) {
                NSError *error = [NSError errorWithDomain:EDAEmployeeErrorDomain code:EDAEmployeeErrorCodeUserNotFound userInfo:@{ NSLocalizedDescriptionKey: @"No matching users found" }];
                return [RACSignal error:error];
            }
            else {
                return [RACSignal return:users.firstObject];
            }
        }];
}

- (RACSignal *)downloadAvatar {
    NSURL *avatarURL = [NSURL URLWithString:self.avatarURL];
    
    if (avatarURL == nil) return [RACSignal return:nil];
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:avatarURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                UIImage *image = [UIImage imageWithData:data];
                [subscriber sendNext:image];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }]
    deliverOn:[RACScheduler currentScheduler]];
}

@end
