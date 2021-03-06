//
//  KCSAppdataStore+RAC.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "KCSAppdataStore+RAC.h"

@implementation KCSAppdataStore (RAC)

- (RACSignal *)rac_saveObject:(id)object {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self saveObject:object withCompletionBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:objects.firstObject];
                [subscriber sendCompleted];
            }
        } withProgressBlock:NULL];
        
        return nil;
    }];
}

- (RACSignal *)rac_deleteObject:(id)object {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self removeObject:object withCompletionBlock:^(unsigned long count, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        } withProgressBlock:NULL];
        
        return nil;
    }];
}

- (RACSignal *)rac_queryWithQuery:(KCSQuery *)query {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self queryWithQuery:query withCompletionBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error with query: %@", query);
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:objects];
                // Don't call `sendCompleted` here because completion block can be called more than once for cached data stores
            }
        } withProgressBlock:NULL];
        
        return nil;
    }]
    retry:5];
}

- (RACSignal *)rac_loadObjectWithID:(NSString *)identifier {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self loadObjectWithID:identifier withCompletionBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                if (objects.count > 0) {
                    [subscriber sendNext:objects.firstObject];
                }
                [subscriber sendCompleted];
            }
        } withProgressBlock:NULL];
        
        return nil;
    }];
}

@end

@implementation KCSCachedStore (RAC)

- (RACSignal *)rac_queryWithQuery:(KCSQuery *)query {
    return [[super rac_queryWithQuery:query]
        catch:^RACSignal *(NSError *error) {
            if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorNotConnectedToInternet) {
                return [RACSignal empty];
            }
            else {
                return [RACSignal error:error];
            }
        }];
}

@end
