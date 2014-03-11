//
//  EDAEmployeeModel.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployeeViewModel.h"

#import "EDAEmployee+API.h"

@interface EDAEmployeeViewModel ()

@property (nonatomic) EDAEmployee *employee;

@end

@implementation EDAEmployeeViewModel

- (id)initWithEmployee:(EDAEmployee *)employee {
    self = [super init];
    if (self == nil) return nil;
    
    _employee = employee;
    
    RAC(self, image) = [[employee downloadAvatar]
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
    
    @weakify(self);
    
    // Supervisor
    RACSignal *supervisorEnabled = [RACObserve(employee, supervisor)
                                    map:^NSNumber *(NSString *supervisor) {
                                        return @(supervisor.length > 0);
                                    }];

    _showSupervisorCommand = [[RACCommand alloc] initWithEnabled:supervisorEnabled signalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        return [EDAEmployee employeeWithUsername:self.employee.supervisor];
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
    
    return self;
}

@end