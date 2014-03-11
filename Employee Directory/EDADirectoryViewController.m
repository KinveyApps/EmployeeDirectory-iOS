//
//  EDADirectoryViewController.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDADirectoryViewController.h"

#import "EDADirectoryViewModel.h"
#import "EDADirectoryCellViewModel.h"
#import "EDADirectoryCell.h"
#import "EDAEmployeeDetailViewController.h"

@interface EDADirectoryViewController ()

@property (nonatomic) EDADirectoryViewModel *viewModel;

@end

@implementation EDADirectoryViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self == nil) return nil;
    
    self.title = @"Directory";

    _viewModel = [EDADirectoryViewModel new];

    UISegmentedControl *sortControl = [[UISegmentedControl alloc] initWithItems:@[ @"Name", @"Group" ]];
    RACChannelTerminal *controlTerminal = [sortControl rac_newSelectedSegmentIndexChannelWithNilValue:@0];
    RACChannelTerminal *modelTerminal = RACChannelTo(self.viewModel, sortStyle);
    [modelTerminal subscribe:controlTerminal];
    [controlTerminal subscribe:modelTerminal];
    self.navigationItem.titleView = sortControl;
    
    @weakify(self);
    
    [self rac_liftSelector:@selector(handleError:) withSignals:self.viewModel.errors, nil];
    
    [[[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)]
        reduceEach:^EDADirectoryCellViewModel *(UITableView *tableView, NSIndexPath *indexPath){
            @strongify(self);
            
            return [self viewModelForIndexPath:indexPath];
        }]
        subscribeNext:^(EDADirectoryCellViewModel *viewModel) {
            @strongify(self);
            
            EDAEmployeeDetailViewController *viewController = [[EDAEmployeeDetailViewController alloc] initWithEmployee:viewModel.employee];
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    
    return self;
}

- (void)viewDidLoad {
    [self.tableView registerClass:[EDADirectoryCell class] forCellReuseIdentifier:NSStringFromClass([EDADirectoryCell class])];
    
    @weakify(self);
    
    [RACObserve(self.viewModel, sections) subscribeNext:^(id x) {
        @strongify(self);
        
        [self.tableView reloadData];
    }];
}

#pragma mark -

- (EDADirectoryCellViewModel *)viewModelForIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.sections[indexPath.section][indexPath.row];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.sections[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDADirectoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EDADirectoryCell class])];
    cell.object = [self viewModelForIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.viewModel.sectionTitles[section];
}

@end
