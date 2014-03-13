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

@interface EDADirectoryViewController () <UISearchDisplayDelegate>

@property (nonatomic) EDADirectoryViewModel *viewModel;
@property (nonatomic) UISearchDisplayController *searchController;

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
            
            return [self viewModelForIndexPath:indexPath searching:tableView != self.tableView];
        }]
        subscribeNext:^(EDADirectoryCellViewModel *viewModel) {
            @strongify(self);
            
            EDAEmployeeDetailViewController *viewController = [[EDAEmployeeDetailViewController alloc] initWithEmployee:viewModel.employee];
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    
    RAC(self.viewModel, searchString) = [[self rac_signalForSelector:@selector(searchDisplayController:shouldReloadTableForSearchString:) fromProtocol:@protocol(UISearchDisplayDelegate)]
        reduceEach:^NSString *(UISearchDisplayController *controller, NSString *searchString){
            return searchString;
        }];
    
    return self;
}

- (void)viewDidLoad {
    [self.tableView registerClass:[EDADirectoryCell class] forCellReuseIdentifier:NSStringFromClass([EDADirectoryCell class])];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableHeaderView = searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    
    @weakify(self);
    
    [RACObserve(self.viewModel, sections) subscribeNext:^(id x) {
        @strongify(self);
        
        [self.tableView reloadData];
    }];
}

#pragma mark -

- (EDADirectoryCellViewModel *)viewModelForIndexPath:(NSIndexPath *)indexPath searching:(BOOL)searching {
    if (searching == NO) {
        return self.viewModel.sections[indexPath.section][indexPath.row];
    }
    else {
        return self.viewModel.filteredSections[indexPath.section][indexPath.row];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.viewModel.sections.count;
    }
    else {
        return self.viewModel.filteredSections.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [self.viewModel.sections[section] count];
    }
    else {
        return [self.viewModel.filteredSections[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDADirectoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EDADirectoryCell class])];
    if (!cell) {
        cell = [[EDADirectoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([EDADirectoryCell class])];
    }
    cell.object = [self viewModelForIndexPath:indexPath searching:tableView != self.tableView];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.viewModel.sectionTitles[section];
    }
    else {
        return self.viewModel.filteredSectionTitles[section];
    }
}

#pragma mark - UISearchDisplayControllerDelegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    return YES;
}

@end
