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
#import "EDATag+API.h"

@interface EDAEmployeeViewModel ()

@property (nonatomic) EDAEmployee *employee;
@property (nonatomic) EDATag *tag;
@property (nonatomic) RACCommand *saveTagCommand;
@property (nonatomic) RACCommand *deleteTagCommand;

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
    
    RAC(self, businessAddress) = [RACSignal
        combineLatest:@[ RACObserve(self.employee, address), RACObserve(self.employee, city), RACObserve(self.employee, state), RACObserve(self.employee, zipCode) ]
        reduce:^NSString *(NSString *address, NSString *city, NSString *state, NSString *zipCode){
            return [NSString stringWithFormat:@"%@\n%@, %@ %@", address, city, state, zipCode];
        }];
    
    RAC(self, officePhone) = RACObserve(self.employee, workPhone);
    RAC(self, mobilePhone) = RACObserve(self.employee, cellPhone);
    RAC(self, textPhone) = RACObserve(self.employee, cellPhone);
    
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
    
    _callOfficeCommand = [[RACCommand alloc] initWithEnabled:callEnabled signalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        NSString *URLString = [NSString stringWithFormat:@"tel://%@", [self.employee.workPhone stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        NSURL *URL = [NSURL URLWithString:URLString];
        [[UIApplication sharedApplication] openURL:URL];
        
        return [RACSignal empty];
    }];
    
    // Mobile
    _callMobileCommand = [[RACCommand alloc] initWithEnabled:callEnabled signalBlock:^RACSignal *(id input) {
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
    
    // Tag
    RAC(self, tag) = [EDATag tagForEmployee:employee];
    RAC(self, tagName) = [[[RACObserve(self, tag)
        map:^RACSignal *(EDATag *tag) {
            if (tag == nil) return [RACSignal return:nil];
            return RACObserve(tag, tagType);
        }]
        switchToLatest]
        map:^NSString *(NSNumber *type) {
            if (type == nil) return @"None";
            else return [EDATag displayNameForType:type.integerValue];
        }];

    _saveTagCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        return [EDATag saveTag:self.tag];
    }];
    
    _deleteTagCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        if (self.tag) {
            return [EDATag deleteTag:self.tag];
        }
        else {
            return [RACSignal empty];
        }
    }];

    RACSignal *hasTagSignal = [[RACObserve(self, tag)
        skip:1]
        mapReplace:@YES];
    RACSignal *tagEnabledSignal = [RACSignal merge:@[ hasTagSignal, [_saveTagCommand.executing not], [_deleteTagCommand.executing not] ]];
    
    _tagCommand = [[RACCommand alloc] initWithEnabled:tagEnabledSignal signalBlock:^RACSignal *(id input) {
        NSArray *types = @[ @(EDATagTypeColleague), @(EDATagTypeSupervisor), @(EDATagTypeTeam), @(EDATagTypeNone) ];
        NSArray *names = [[types.rac_sequence map:^NSString *(NSNumber *type) {
            if (type.integerValue == EDATagTypeNone) return @"None";
            else return [EDATag displayNameForType:type.integerValue];
        }] array];
        
        return [RACSignal return:RACTuplePack(names, types, @(types.count - 1))];
    }];
    
    return self;
}

- (void)tagWithType:(EDATagType)type {
    if (type == EDATagTypeNone) {
        [self.deleteTagCommand execute:nil];
        self.tag = nil;
        return;
    }
    
    if (self.tag == nil) {
        EDATag *tag = [EDATag new];
        tag.username = [KCSUser activeUser].username;
        tag.taggedUsername = self.employee.username;
        self.tag = tag;
    }
    
    self.tag.tagType = type;
    
    [self.saveTagCommand execute:nil];
}

@end
