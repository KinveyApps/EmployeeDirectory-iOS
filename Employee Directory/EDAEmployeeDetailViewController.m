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
#import "EDADirectoryViewController.h"
#import "EDANewMessageViewController.h"

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
    
    RAC(self.view.imageView, image) = RACObserve(self.viewModel, image);
    RAC(self.view.nameLabel, text) = RACObserve(self.viewModel, fullName);
    RAC(self.view.titleLabel, text) = RACObserve(self.viewModel, titleAndGroup);
    RAC(self.view.linkedInHeadlineLabel, text) = RACObserve(self.viewModel, linkedInHeadline);
    RAC(self.view.linkedInSummaryLabel, text) = RACObserve(self.viewModel, linkedInSummary);
    
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
            viewController.messageComposeDelegate = (id <MFMessageComposeViewControllerDelegate>)self;
            
            [self presentViewController:viewController animated:YES completion:NULL];
        }];
    
    [[self rac_signalForSelector:@selector(messageComposeViewController:didFinishWithResult:) fromProtocol:@protocol(MFMessageComposeViewControllerDelegate)]
        subscribeNext:^(id x) {
            @strongify(self);
            
            [self dismissViewControllerAnimated:YES completion:NULL];
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
    
    self.view.linkedinButton.rac_command = self.viewModel.showLinkedInProfileCommand;
    [self rac_liftSelector:@selector(handleError:) withSignals:self.view.linkedinButton.rac_command.errors, nil];
    
    self.view.reportsButton.rac_command = self.viewModel.showDirectReports;
    [[self.view.reportsButton.rac_command.executionSignals
        flatten]
        subscribeNext:^(EDAEmployee *employee) {
            @strongify(self);
            
            EDADirectoryViewController *viewController = [[EDADirectoryViewController alloc] initWithDirectReportsOfEmployee:employee];
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    
    self.view.messageButton.rac_command = self.viewModel.messageCommand;
    [[self.view.messageButton.rac_command.executionSignals
        flatten]
        subscribeNext:^(EDAEmployee *employee) {
            @strongify(self);
            
            EDANewMessageViewController *viewController = [[EDANewMessageViewController alloc] initWithEmployees:@[ employee ]];
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    
    self.view.favoriteButton.rac_command = self.viewModel.favoriteCommand;
    RACSignal *titleSignal = [RACObserve(self.viewModel, favorite)
        map:^NSString *(NSNumber *favorite){
            NSString *title;
            if (favorite.boolValue) {
                title = @"Un-Favorite";
            }
            else {
                title = @"Favorite";
            }
            return title;
        }];
    [self.view.favoriteButton rac_liftSelector:@selector(setTitle:forState:) withSignals:titleSignal, [RACSignal return:@(UIControlStateNormal)], nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view.scrollView flashScrollIndicators];
}

@end
