//
//  EDAEmployeeModel.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployeeViewModel.h"

#import "EDAEmployee+API.h"
#import "EDALinkedInManager.h"
#import "EDAFavorite+API.h"

@interface EDAEmployeeViewModel ()

@property (nonatomic) EDAEmployee *employee;

@end

@implementation EDAEmployeeViewModel

- (id)initWithEmployee:(EDAEmployee *)employee {
    self = [super init];
    if (self == nil) return nil;
    
    _employee = employee;
    
    [[employee update] subscribeError:^(NSError *error) {
        NSLog(@"Error updating employee: %@", error);
    }];
    
    RAC(self, image) = [[[[employee downloadAvatar]
        startWith:[UIImage imageNamed:@"AvatarLoading"]]
        map:^UIImage *(UIImage *image) {
            if (image == nil) return [UIImage imageNamed:@"NoAvatar"];
            else return image;
        }]
        catch:^RACSignal *(NSError *error) {
            return [RACSignal empty];
        }];
    
    RAC(self, fullName) = [RACSignal
        combineLatest:@[ RACObserve(employee, firstName), RACObserve(employee, lastName) ]
        reduce:^NSString *(NSString *firstName, NSString *lastName){
            return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        }];
    
    RAC(self, titleAndGroup) = [RACSignal
        combineLatest:@[ RACObserve(employee, title), RACObserve(employee, group) ]
        reduce:^NSString *(NSString *title, NSString *group){
            return [NSString stringWithFormat:@"%@, %@", title, group];
        }];
    
    RAC(self, linkedInHeadline) = RACObserve(self.employee, headline);
    RAC(self, linkedInSummary) = RACObserve(self.employee, summary);
    
    @weakify(self);
    
    // Supervisor
    RACSignal *supervisorEnabled = [RACObserve(employee, supervisor)
        map:^NSNumber *(NSString *supervisor) {
            return @(supervisor.length > 0);
        }];

    _showSupervisorCommand = [[RACCommand alloc] initWithEnabled:supervisorEnabled signalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        return [[EDAEmployee employeeWithUsername:self.employee.supervisor] take:1];
    }];
    
    // Call
    BOOL canOpenTelURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    RACSignal *callEnabled = [RACSignal return:@(canOpenTelURL)];
    
    _callCommand = [[RACCommand alloc] initWithEnabled:callEnabled signalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        NSString *URLString = [NSString stringWithFormat:@"tel://%@", [self.employee.cellPhone stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        NSURL *URL = [NSURL URLWithString:URLString];
        [[UIApplication sharedApplication] openURL:URL];
        
        return [RACSignal empty];
    }];
    
    // Text
    RACSignal *hasPhoneNumber = [RACObserve(self.employee, cellPhone) map:^NSNumber *(NSString *phoneNumber) {
        return @(phoneNumber.length > 0);
    }];
    BOOL canSendText = [MFMessageComposeViewController canSendText];
    RACSignal *textEnabled = [[RACSignal
        combineLatest:@[ hasPhoneNumber, [RACSignal return:@(canSendText)] ]]
        and];
    
    _textCommand = [[RACCommand alloc] initWithEnabled:textEnabled signalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        return [RACSignal return:self.employee.cellPhone];
    }];
    
    // Email
    RACSignal *hasEmailAddress = [RACObserve(self.employee, email) map:^NSNumber *(NSString *email) {
        return @(email.length > 0);
    }];
    BOOL canSendEmail = [MFMailComposeViewController canSendMail];
    RACSignal *emailEnabled = [[RACSignal
        combineLatest:@[ hasEmailAddress, [RACSignal return:@(canSendEmail)] ]]
        and];
    
    _emailCommand = [[RACCommand alloc] initWithEnabled:emailEnabled signalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        RACTuple *tuple = RACTuplePack(@[ self.employee.email ], @"Subject", @"Message");
        return [RACSignal return:tuple];
    }];
    
    // Show LinkedIn Profile
    RACSignal *hasLinkedInID = [RACObserve(self.employee, linkedInID) map:^NSNumber *(NSString *ID) {
        return @(ID.length > 0);
    }];
    
    _showLinkedInProfileCommand = [[RACCommand alloc] initWithEnabled:hasLinkedInID signalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        return [[[EDALinkedInManager sharedManager] linkedInProfileURLForEmployee:self.employee]
            doNext:^(NSURL *URL) {
                [[UIApplication sharedApplication] openURL:URL];
            }];
    }];
    
    // Show Direct Reports
    RACSignal *directReportsEnabled = [[[EDAEmployee directReportsOfEmployee:employee]
        map:^NSNumber *(NSArray *directReports) {
            return @(directReports.count > 0);
        }]
        startWith:@NO];
    
    _showDirectReports = [[RACCommand alloc] initWithEnabled:directReportsEnabled signalBlock:^RACSignal *(id input) {
        return [RACSignal return:employee];
    }];
    
    // Message
    _messageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:employee];
    }];
    
    // Favorite
    _favoriteCommand = [[RACCommand alloc] initWithEnabled:[RACSignal return:@YES] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        if (self.favorite) {
            return [EDAFavorite deleteFavoriteForEmployee:self.employee];
        }
        else {
            return [EDAFavorite createFavoriteForEmployee:self.employee];
        }
    }];
    
    RAC(self, favorite) = [[RACSignal merge:@[ [_favoriteCommand.executionSignals flatten], [EDAFavorite favoriteForEmployee:employee] ]]
        map:^NSNumber *(EDAFavorite *favorite) {
            return @(favorite != nil);
        }];
    
    return self;
}

@end
