//
//  EDACitrixManager.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/25/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDACitrixManager.h"

#import "EDAWebViewController.h"
#import "NSString+URL.h"

NSString * const EDACitrixManagerClientID = @"kid_PTOd12xcS9";
NSString * const EDACitrixManagerScope = @"http://localhost:8081/";
NSString * const EDACitrixManagerRedirect = @"blemployeedirectory://";
NSString * const EDACitrixManagerSecret = @"ed7b5090ecd442a3a1dd917ee540cf76";
NSString * const EDACitrixManagerUserDefaultsKey = @"EDACitrixManagerUserDefaultsKey";

@implementation EDACitrixManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self == nil) return nil;
    
    RACChannelTerminal *terminal = RACChannelTo(self, oauthToken);
    [[[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:EDACitrixManagerUserDefaultsKey] subscribe:terminal];
    
    return self;
}

- (RACSignal *)authorizeWithCitrixWithRootViewController:(UIViewController *)viewController {
    NSString *URLString = [NSString stringWithFormat:@"https://auth.kinvey.com/oauth/auth?client_id=%@&redirect_uri=%@&scope=%@&response_type=code", EDACitrixManagerClientID, [EDACitrixManagerRedirect stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], [EDACitrixManagerScope stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    EDAWebViewController *webViewController = [[EDAWebViewController alloc] initWithURL:URL];
    webViewController.title = @"Logon";
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [EDAAppearanceManager customizeAppearanceOfNavigationBar:navigationController.navigationBar];
    
    [viewController presentViewController:navigationController animated:YES completion:NULL];
    
    RACSignal *webViewControllerSignal = [[[[[[webViewController.shouldLoadURLSignal
        filter:^BOOL(NSURL *aURL) {
            NSString *redirectToLookFor = [EDACitrixManagerRedirect substringToIndex:EDACitrixManagerRedirect.length - 1]; // Works around a bug where the second '/' of the url scheme is dropped
            NSInteger location = [aURL.absoluteString rangeOfString:redirectToLookFor].location;
            return location == 0;
        }]
        flattenMap:^RACStream *(NSURL *aURL) {
            NSDictionary *parameters = [EDACitrixManager parametersFromAuthURL:aURL];
            NSString *code = parameters[@"blemployeedirectory://?code"];

            if (code != nil) {
                return [RACSignal return:code];
            }
            else {
                // Can this happen?
                return [RACSignal error:nil];
            }
        }]
        flattenMap:^RACStream *(NSString *code) {
            NSDictionary *parameters = @{ @"client_id": EDACitrixManagerClientID,
                                          @"client_secret": EDACitrixManagerSecret,
                                          @"code": code,
                                          @"grant_type": @"authorization_code",
                                          @"redirect_uri": EDACitrixManagerRedirect };
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [manager POST:@"https://auth.kinvey.com/oauth/token" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                    NSString *token = responseObject[@"access_token"];
                    [subscriber sendNext:token];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                }];
                
                return nil;
            }];
        }]
        flattenMap:^RACStream *(NSString *token) {
            RACTuple *tuple = RACTuplePack(token, EDACitrixManagerSecret);
            return [[viewController rac_dismissViewControllerAnimated:YES] mapReplace:tuple];
        }]
        doNext:^(RACTuple *tuple) {
            [[NSUserDefaults standardUserDefaults] setObject:tuple.first forKey:EDACitrixManagerUserDefaultsKey];
        }]
        doError:^(NSError *error) {
            [viewController dismissViewControllerAnimated:YES completion:NULL];
        }];
    
    return webViewControllerSignal;
}

+ (NSDictionary *)parametersFromAuthURL:(NSURL *)URL {
    NSString *redirectToLookFor = [EDACitrixManagerRedirect substringToIndex:EDACitrixManagerRedirect.length - 1]; // Works around a bug where the second '/' of the url scheme is dropped
    return [NSURL parametersFromAuthURL:URL ignoringString:redirectToLookFor];
}

@end
