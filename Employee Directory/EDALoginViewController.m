//
//  EDALoginViewController.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDALoginViewController.h"

#import "EDALoginViewModel.h"
#import "EDALoginView.h"
#import "EDALinkedInManager.h"

@interface EDALoginViewController ()

@property (nonatomic) EDALoginViewModel *viewModel;
@property (nonatomic) EDALoginView *view;

@end

@implementation EDALoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        _viewModel = [[EDALoginViewModel alloc] initWithViewController:self];
        self.title = @"Employee Directory";
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationItem.rightBarButtonItem = [self loginBarButtonItem];
    }
    return self;
}

- (void)loadView {
    self.view = [[EDALoginView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view.usernameTextField becomeFirstResponder];
    
    RAC(self.viewModel, password) = self.view.passwordTextField.rac_textSignal;
    RAC(self.viewModel, username) = self.view.usernameTextField.rac_textSignal;
    
    RAC(self.view.usernameTextField, enabled) = RACObserve(self.viewModel, acceptInput);
    RAC(self.view.passwordTextField, enabled) = RACObserve(self.viewModel, acceptInput);
    
    @weakify(self);
    
    [[self.viewModel.loginCommand.executionSignals
        flatten]
        subscribeNext:^(KCSUser *user) {
            @strongify(self);
            
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
    
    [self rac_liftSelector:@selector(handleError:) withSignals:self.viewModel.loginCommand.errors, nil];
}

- (UIBarButtonItem *)loginBarButtonItem {
    UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStyleDone target:nil action:nil];
    loginItem.rac_command = self.viewModel.loginCommand;
    
    return loginItem;
}

@end
