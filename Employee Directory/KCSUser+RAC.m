//
//  KCSUser+RAC.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "KCSUser+RAC.h"

@implementation KCSUser (RAC)

+ (RACSignal *)rac_loginWithUsername:(NSString *)username password:(NSString *)password {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [KCSUser loginWithUsername:username password:password withCompletionBlock:^(KCSUser *user, NSError *error, KCSUserActionResult result) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}

@end
