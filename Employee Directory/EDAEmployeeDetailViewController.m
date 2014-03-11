//
//  EDAEmployeeDetailViewController.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployeeDetailViewController.h"

#import "EDAEmployeeDetailView.h"
#import "EDAEmployeeModel.h"
#import "EDAEmployeeModel.h"

@interface EDAEmployeeDetailViewController ()

@property (nonatomic) EDAEmployeeDetailView *view;
@property (nonatomic) EDAEmployeeModel *viewModel;

@end

@implementation EDAEmployeeDetailViewController

- (id)initWithEmployee:(EDAEmployee *)employee {
    self = [super init];
    if (self) {
        _viewModel = [[EDAEmployeeModel alloc] initWithEmployee:employee];
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
    RAC(self.view.titleLabel, text) = RACObserve(self.viewModel, title);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
