//
//  EDALoginModel.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDALoginViewModel.h"

#import "EDALinkedInManager.h"
#import "EDACitrixManager.h"

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
    
    _loginCommand = [[RACCommand alloc] initWithEnabled:[RACSignal return:@YES] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[[EDACitrixManager sharedManager] authorizeWithCitrixWithRootViewController:self.viewController]
            flattenMap:^RACStream *(RACTuple *tuple) {
                NSDictionary *accessDictionary = @{ @"_socialIdentity": @{ @"citrix": @{ @"access_token": tuple.first } } };
                return [KCSUser rac_loginWithSocialIdentity:KCSSocialIDOther accessDictionary:accessDictionary];
            }]
            flattenMap:^RACStream *(KCSUser *user) {
                return [[EDALinkedInManager sharedManager] authorizeWithLinkedInWithRootViewController:self.viewController];
            }];
    }];
    
    RAC(self, acceptInput) = [self.loginCommand.executing not];
    
    return self;
}

@end
