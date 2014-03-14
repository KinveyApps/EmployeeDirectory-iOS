//
//  EDAImageManager.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/14/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAImageManager.h"

#import <SDWebImage/SDImageCache.h>

@implementation EDAImageManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (RACSignal *)imageFromURL:(NSURL *)URL {
    NSString *key = URL.absoluteString;
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    if (image) {
        return [RACSignal return:image];
    }
    else {
        return [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    [subscriber sendError:error];
                }
                else {
                    UIImage *downloadedImage = [UIImage imageWithData:data];
                    if (downloadedImage) {
                        [subscriber sendNext:downloadedImage];
                    }
                    [subscriber sendCompleted];
                }
            }];

            [task resume];

            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }]
        catchTo:[RACSignal empty]]
        deliverOn:[RACScheduler currentScheduler]]
        doNext:^(UIImage *downloadedImage) {
            [[SDImageCache sharedImageCache] storeImage:downloadedImage forKey:key toDisk:YES];
        }];
    }
}

@end
