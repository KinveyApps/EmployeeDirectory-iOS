//
//  EDAEmployeeDetailViewController.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployeeDetailViewController.h"

#import "EDAEmployeeDetailView.h"
#import "EDAEmployeeViewModel.h"
#import "EDAEmployeeViewModel.h"

@interface EDAEmployeeDetailViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic) EDAEmployeeDetailView *view;
@property (nonatomic) EDAEmployeeViewModel *viewModel;

@end

@implementation EDAEmployeeDetailViewController

- (id)initWithEmployee:(EDAEmployee *)employee {
    self = [super init];
    if (self) {
        _viewModel = [[EDAEmployeeViewModel alloc] initWithEmployee:employee];
        
        RAC(self, title) = RACObserve(self.viewModel, fullName);
    }
    return self;
}

- (void)loadView {
    self.view = [[EDAEmployeeDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RAC(self.view.nameLabel, text) = RACObserve(self.viewModel, fullName);
    RAC(self.view.titleLabel, text) = RACObserve(self.viewModel, titleAndGroup);
    
    @weakify(self);
    
    self.view.supervisorButton.rac_command = self.viewModel.showSupervisorCommand;
    [[self.view.supervisorButton.rac_command.executionSignals
        flatten]
        subscribeNext:^(EDAEmployee *employee) {
            @strongify(self);
            
            EDAEmployeeDetailViewController *viewController = [[EDAEmployeeDetailViewController alloc] initWithEmployee:employee];
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    
    self.view.callButton.rac_command = self.viewModel.callCommand;
    
    self.view.textButton.rac_command = self.viewModel.textCommand;
    [[self.view.textButton.rac_command.executionSignals
        flatten]
        subscribeNext:^(NSString *phoneNumber) {
            @strongify(self);
            
            MFMessageComposeViewController *viewController = [[MFMessageComposeViewController alloc] init];
            [viewController setRecipients:@[ phoneNumber ]];
            
            [self presentViewController:viewController animated:YES completion:NULL];
        }];
    
    self.view.emailButton.rac_command = self.viewModel.emailCommand;
    [[self.view.emailButton.rac_command.executionSignals flatten]
        subscribeNext:^(RACTuple *tuple) {
            @strongify(self);
            
            RACTupleUnpack(NSArray *recipients, NSString *subject, NSString *message) = tuple;
            
            MFMailComposeViewController *viewController = [[MFMailComposeViewController alloc] init];
            [viewController setToRecipients:recipients];
            [viewController setSubject:subject];
            [viewController setMessageBody:message isHTML:NO];
            [viewController setMailComposeDelegate:self];
            
            [self presentViewController:viewController animated:YES completion:NULL];
        }];
    
    [[self rac_signalForSelector:@selector(mailComposeController:didFinishWithResult:error:) fromProtocol:@protocol(MFMailComposeViewControllerDelegate)]
        subscribeNext:^(id x) {
            @strongify(self);
            
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
}

@end
