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

@interface EDAEmployeeDetailViewController ()

@property (nonatomic) EDAEmployeeDetailView *view;
@property (nonatomic) EDAEmployeeViewModel *viewModel;

@end

@implementation EDAEmployeeDetailViewController

- (id)initWithEmployee:(EDAEmployee *)employee {
    self = [super init];
    if (self) {
        _viewModel = [[EDAEmployeeViewModel alloc] initWithEmployee:employee];
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
}

@end
