//
//  EDALinkedInManager.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDALinkedInManager.h"

#import "EDAWebViewController.h"

NSString * const EDALinkedInManagerErrorDomain = @"com.ballastlane.employeedirectory.linkedinmanager";

NSInteger const EDALinkedInManagerErrorCodeUserRejected = 1;
NSInteger const EDALinkedInManagerErrorCodeInsecure = 2;

NSString * const EDALinkedInManagerAPIKey = @"759mgmrody1lwk";
NSString * const EDALinkedInManagerRedirectURL = @"http://www.ballastlane.com/linkedin-auth";

NSString * const EDALinkedInManagerUserDefaultsKey = @"LinkedInToken";

@implementation EDALinkedInManager

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
    [[[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:EDALinkedInManagerUserDefaultsKey] subscribe:terminal];
    
    return self;
}

- (RACSignal *)authorizeWithLinkedInWithRootViewController:(UIViewController *)viewController {
    NSString *UUID = [NSUUID new].UUIDString;
    
    NSString *URLString = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&state=%@&redirect_uri=%@", EDALinkedInManagerAPIKey, UUID, [EDALinkedInManagerRedirectURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    EDAWebViewController *webViewController = [[EDAWebViewController alloc] initWithURL:URL];
    webViewController.title = @"Authorize";
    [viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:NULL];
    
    return [[[[[[webViewController.shouldLoadURLSignal
        filter:^BOOL(NSURL *aURL) {
            NSInteger location = [aURL.absoluteString rangeOfString:EDALinkedInManagerRedirectURL].location;
            return location == 0;
        }]
        flattenMap:^RACStream *(NSURL *aURL) {
            NSDictionary *parameters = [EDALinkedInManager parametersFromAuthURL:aURL];
            
            NSString *code = parameters[@"code"];
            NSString *state = parameters[@"state"];
            
            if ([state isEqualToString:UUID] == NO) {
                NSError *error = [NSError errorWithDomain:EDALinkedInManagerErrorDomain code:EDALinkedInManagerErrorCodeInsecure userInfo:@{ NSLocalizedDescriptionKey: @"UUID doesn't match" }];
                return [RACSignal error:error];
            }
            
            if (code != nil) {
                return [RACSignal return:code];
            }
            else {
                NSString *description = [NSString stringWithFormat:@"%@", parameters[@"error_description"]];
                NSError *error = [NSError errorWithDomain:EDALinkedInManagerErrorDomain code:EDALinkedInManagerErrorCodeUserRejected userInfo:@{ NSLocalizedDescriptionKey: description }];
                return [RACSignal error:error];
            }
        }]
        take:1]
        flattenMap:^RACStream *(NSString *code) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [viewController dismissViewControllerAnimated:YES completion:^{
                    [subscriber sendNext:code];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }]
        doNext:^(NSString *code) {
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:EDALinkedInManagerUserDefaultsKey];
        }]
        doError:^(NSError *error) {
            [viewController dismissViewControllerAnimated:YES completion:NULL];
        }];
}

+ (NSDictionary *)parametersFromAuthURL:(NSURL *)URL {
    NSString *string = URL.absoluteString;
    string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@?", EDALinkedInManagerRedirectURL] withString:@""];
    
    NSArray *components = [string componentsSeparatedByString:@"&"];
    NSDictionary *parameters = [components.rac_sequence foldLeftWithStart:[NSMutableDictionary new] reduce:^id(NSMutableDictionary *dictionary, NSString *component) {
        NSArray *subcomponents = [component componentsSeparatedByString:@"="];
        if (subcomponents.count != 2) return dictionary;
        NSString *parameter = subcomponents.firstObject;
        NSString *value = subcomponents.lastObject;
        
        dictionary[parameter] = value;
        return dictionary;
    }];
    
    return parameters;
}

@end
