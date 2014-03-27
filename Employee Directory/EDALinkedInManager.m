//
//  EDALinkedInManager.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDALinkedInManager.h"

#import "EDAWebViewController.h"
#import "EDAEmployee+API.h"
#import "EDAAppearanceManager.h"
#import "NSString+URL.h"
#import "EDAEmployeeInfo+API.h"

NSString * const EDALinkedInManagerErrorDomain = @"com.ballastlane.employeedirectory.linkedinmanager";

NSInteger const EDALinkedInManagerErrorCodeUserRejected = 1;
NSInteger const EDALinkedInManagerErrorCodeInsecure = 2;
NSInteger const EDALinkedInManagerErrorCodeFailed = 3;

NSString * const EDALinkedInManagerAPIKey = @"759mgmrody1lwk";
NSString * const EDALinkedInManagerAPISecret = @"O2w8tGRGFRjKHqPX";
NSString * const EDALinkedInManagerRedirectURL = @"http://www.ballastlane.com/linkedin-auth";

NSString * const EDALinkedInManagerUserDefaultsKey = @"LinkedInToken";

@interface EDALinkedInManager ()

@property (nonatomic) NSString *oauthToken;

@end

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
    
    RAC(self, canMakeRequests) = [RACObserve(self, oauthToken)
        map:^NSNumber *(NSString *token) {
            return @(token.length > 0);
        }];
    
    return self;
}

- (void)startUpdating {
    /*
    @weakify(self);
    
    RACSignal *notifications = [RACSignal merge:@[ [[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil], [[NSNotificationCenter defaultCenter] rac_addObserverForName:KCSActiveUserChangedNotification object:nil], RACObserve(self, oauthToken) ]];
    [[[notifications
        flattenMap:^RACStream *(id value) {
            @strongify(self);
            
            return [self updateUserInfoWithLinkedInProfile];
        }]
        catch:^RACSignal *(NSError *error) {
            return [RACSignal empty];
        }]
        subscribeNext:^(EDAEmployee *employee) {
            NSLog(@"Updated %@ with info from LinkedIn.", employee.username);
        }
        error:^(NSError *error) {
            NSLog(@"Error updating employee with info from LinkenIn: %@", error);
        }];
     */
}

- (RACSignal *)authorizeWithLinkedInWithRootViewController:(UIViewController *)viewController {
    NSString *UUID = [NSUUID new].UUIDString;
    
    NSString *URLString = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&state=%@&redirect_uri=%@", EDALinkedInManagerAPIKey, UUID, [EDALinkedInManagerRedirectURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    EDAWebViewController *webViewController = [[EDAWebViewController alloc] initWithURL:URL];
    webViewController.title = @"Authorize";
    
    UIBarButtonItem *skipItem = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:nil action:nil];
    skipItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:nil];
    }];
    webViewController.navigationItem.leftBarButtonItem = skipItem;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [EDAAppearanceManager customizeAppearanceOfNavigationBar:navigationController.navigationBar];
    
    [viewController presentViewController:navigationController animated:YES completion:NULL];
    
    RACSignal *webViewControllerSignal = [[[[[webViewController.shouldLoadURLSignal
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
            NSDictionary *parameters = @{ @"client_id": EDALinkedInManagerAPIKey,
                                          @"client_secret": EDALinkedInManagerAPISecret,
                                          @"code": code,
                                          @"grant_type": @"authorization_code",
                                          @"redirect_uri": EDALinkedInManagerRedirectURL };
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [manager GET:@"https://www.linkedin.com/uas/oauth2/accessToken" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
                    NSString *token = response[@"access_token"];
                    [subscriber sendNext:token];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                }];
                
                return nil;
            }];
        }]
        catch:^RACSignal *(NSError *error) {
            if ([error.domain isEqualToString:EDALinkedInManagerErrorDomain] && error.code == EDALinkedInManagerErrorCodeUserRejected) {
                return [RACSignal return:nil];
            }
            else {
                return [RACSignal error:error];
            }
        }];
    
    return [[[[RACSignal merge:@[ webViewControllerSignal, [skipItem.rac_command.executionSignals flatten] ]]
        flattenMap:^RACStream *(NSString *code) {
            return [[viewController rac_dismissViewControllerAnimated:YES] mapReplace:code];
        }]
        doNext:^(NSString *code) {
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:EDALinkedInManagerUserDefaultsKey];
        }]
        doError:^(NSError *error) {
            [viewController dismissViewControllerAnimated:YES completion:NULL];
        }];
}

+ (NSDictionary *)parametersFromAuthURL:(NSURL *)URL {
    return [NSURL parametersFromAuthURL:URL ignoringString:EDALinkedInManagerRedirectURL];
}

- (RACSignal *)updateUserInfoWithLinkedInProfile:(EDAEmployee *)employee {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:EDALinkedInManagerUserDefaultsKey];
    
    if (accessToken.length == 0 || [KCSUser activeUser] == nil) return [RACSignal empty];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{ @"format": @"json",
                                  @"oauth2_access_token": accessToken };
    
    return [[[RACSignal
        createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [manager GET:@"https://api.linkedin.com/v1/people/~:(first-name,last-name,summary,headline,id,picture-url)" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [subscriber sendError:error];
            }];
            
            return nil;
        }]
        zipWith:[EDAEmployeeInfo infoForEmployeeWithID:employee.username]]
        flattenMap:^RACStream *(RACTuple *tuple) {
            RACTupleUnpack(NSDictionary *dictionary, EDAEmployeeInfo *employeeInfo) = tuple;
            
            if (employeeInfo == nil) {
                employeeInfo = [EDAEmployeeInfo new];
                employeeInfo.userID = employee.username;
            }
            
            NSString *headline = dictionary[@"headline"];
            NSString *summary = dictionary[@"summary"];
            NSString *avatarURL = dictionary[@"pictureUrl"];
            NSString *ID = dictionary[@"id"];
            
            if (headline.length > 0) employeeInfo.headline = headline;
            if (summary.length > 0) employeeInfo.summary = summary;
            if (avatarURL.length > 0) employeeInfo.avatarURL = avatarURL;
            if (ID.length > 0) employeeInfo.linkedInID = ID;
            
            return [[EDAEmployeeInfo appdataStore] rac_saveObject:employeeInfo];
        }];
}

- (RACSignal *)linkedInProfileURLForEmployee:(EDAEmployee *)employee {
    return [[EDAEmployeeInfo infoForEmployeeWithID:employee.username]
        flattenMap:^RACStream *(EDAEmployeeInfo *info) {
            if (info.linkedInID.length == 0) return [RACSignal empty];
            
            NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:EDALinkedInManagerUserDefaultsKey];
            NSString *URLString = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/id=%@", info.linkedInID];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSDictionary *parameters = @{ @"format": @"json",
                                          @"oauth2_access_token": accessToken };

            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                    NSString *profileURLString = responseObject[@"siteStandardProfileRequest"][@"url"];
                    if (profileURLString.length == 0) {
                        NSError *error = [NSError errorWithDomain:EDAEmployeeErrorDomain code:EDALinkedInManagerErrorCodeFailed userInfo:nil];
                        [subscriber sendError:error];
                    }
                    else {
                        NSURL *URL = [NSURL URLWithString:profileURLString];
                        [subscriber sendNext:URL];
                        [subscriber sendCompleted];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                }];
                
                return nil;
            }];;
        }];
}

@end
