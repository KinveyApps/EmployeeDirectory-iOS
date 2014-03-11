//
//  EDAYourInfoViewController.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/11/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAYourInfoViewController.h"

#import "EDAYourInfoView.h"
#import "EDAYourInfoViewModel.h"
#import "EDAEmployee.h"
#import "EDAEmployeeDetailViewController.h"

@interface EDAYourInfoViewController ()

@property (nonatomic) EDAYourInfoView *view;
@property (nonatomic) EDAYourInfoViewModel *viewModel;

@end

@implementation EDAYourInfoViewController

- (id)init
{
    self = [super init];
    if (self) {
        _viewModel = [EDAYourInfoViewModel new];
        
        self.title = @"Your Info";
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)loadView {
    self.view = [[EDAYourInfoView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self);
    
    [[self.viewModel.getYourInfoCommand.executing
        distinctUntilChanged]
        subscribeNext:^(NSNumber *fetching) {
            @strongify(self);
            
            if (fetching.boolValue) {
                [self.view.spinner startAnimating];
            }
            else {
                [self.view.spinner stopAnimating];
            }
        }];
    
    [[self.viewModel.getYourInfoCommand.executionSignals
        flatten]
        subscribeNext:^(EDAEmployee *employee) {
            @strongify(self);
            
            EDAEmployeeDetailViewController *viewController = [[EDAEmployeeDetailViewController alloc] initWithEmployee:employee];
            viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addChildViewController:viewController];
            
            [self.view addSubview:viewController.view];
            
            NSDictionary *views = @{ @"view": viewController.view };
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|" options:0 metrics:nil views:views]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
            
            [viewController didMoveToParentViewController:self];
        }];
    
    [self rac_liftSelector:@selector(handleError:) withSignals:self.viewModel.getYourInfoCommand.errors, nil];
    
    [self.viewModel.getYourInfoCommand execute:nil];
}

@end
