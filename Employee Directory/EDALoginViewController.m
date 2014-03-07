//
//  EDALoginViewController.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDALoginViewController.h"

#import "EDALoginModel.h"
#import "EDALoginView.h"

@interface EDALoginViewController ()

@property (nonatomic) EDALoginModel *viewModel;
@property (nonatomic) EDALoginView *view;

@end

@implementation EDALoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        _viewModel = [[EDALoginModel alloc] init];
        
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
    
    RAC(self.viewModel, password) = self.view.passwordTextField.rac_textSignal;
    RAC(self.viewModel, username) = self.view.usernameTextField.rac_textSignal;
}

- (UIBarButtonItem *)loginBarButtonItem {
    UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:nil action:nil];
    loginItem.rac_command = self.viewModel.loginCommand;
    
    return loginItem;
}

@end
