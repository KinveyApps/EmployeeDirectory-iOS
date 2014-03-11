//
//  KCSResourceService+RAC.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/11/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "KCSFileStore+RAC.h"

@implementation KCSFileStore (RAC)

+ (RACSignal *)rac_downloadImageNamed:(NSString *)name {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [KCSFileStore downloadFileByName:name completionBlock:^(NSArray *downloadedResources, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                KCSFile *file = downloadedResources.firstObject;
                UIImage *image = [UIImage imageWithContentsOfFile:[file.localURL path]];
                
                NSLog(@"Image: %@ %@", name, image);
                
                [subscriber sendNext:image];
                [subscriber sendCompleted];
            }
        } progressBlock:NULL];
        
        return nil;
    }]
    deliverOn:[RACScheduler currentScheduler]];
}

@end
