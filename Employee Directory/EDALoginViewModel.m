//
//  EDALoginModel.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDALoginViewModel.h"

@interface EDALoginViewModel ()

@property (readwrite, nonatomic) RACCommand *loginCommand;

@end

@implementation EDALoginViewModel

- (id)init {
    self = [super init];
    if (self == nil) return nil;

    RACSignal *enabled = [RACSignal
        combineLatest:@[ RACObserve(self, username), RACObserve(self, password) ]
        reduce:^NSNumber *(NSString *username, NSString *password){
            return @(username.length > 0 && password.length > 0);
        }];
    _loginCommand = [[RACCommand alloc] initWithEnabled:enabled signalBlock:^RACSignal *(id input) {
        return [KCSUser rac_loginWithUsername:self.username password:self.password];
    }];
    
    RAC(self, acceptInput) = [self.loginCommand.executing not];
    
    return self;
}

@end
