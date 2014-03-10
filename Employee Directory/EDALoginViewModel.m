//
//  EDALoginModel.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDALoginViewModel.h"

#import "EDALinkedInManager.h"

@interface EDALoginViewModel ()

@property (weak, nonatomic) UIViewController *viewController;
@property (readwrite, nonatomic) RACCommand *loginCommand;

@end

@implementation EDALoginViewModel

- (id)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self == nil) return nil;

    _viewController = viewController;
    
    @weakify(self);
    
    RACSignal *enabled = [RACSignal
        combineLatest:@[ RACObserve(self, username), RACObserve(self, password) ]
        reduce:^NSNumber *(NSString *username, NSString *password){
            return @(username.length > 0 && password.length > 0);
        }];
    _loginCommand = [[RACCommand alloc] initWithEnabled:enabled signalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        return [[KCSUser rac_loginWithUsername:self.username password:self.password]
            flattenMap:^RACStream *(KCSUser *user) {
                return [[EDALinkedInManager sharedManager] authorizeWithLinkedInWithRootViewController:self.viewController];
            }];
    }];
    
    RAC(self, acceptInput) = [self.loginCommand.executing not];
    
    return self;
}

@end
