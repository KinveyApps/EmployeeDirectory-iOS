//
//  UIViewController+RAC.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/25/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "UIViewController+RAC.h"

@implementation UIViewController (RAC)

- (RACSignal *)rac_dismissViewControllerAnimated:(BOOL)animated {
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        [self dismissViewControllerAnimated:animated completion:^{
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

- (RACSignal *)rac_presentViewController:(UIViewController *)viewController animated:(BOOL)animated {
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        [self presentViewController:viewController animated:animated completion:^{
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

@end
