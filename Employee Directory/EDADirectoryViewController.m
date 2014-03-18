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
#import "EDADirectoryView.h"

@interface EDADirectoryViewController () <UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) EDADirectoryViewModel *viewModel;
@property (nonatomic) UISearchDisplayController *searchController;
@property (nonatomic) BOOL forSearching;
@property (nonatomic) UIView *instructionsView;
@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic) EDADirectoryView *view;

@end

@implementation EDADirectoryViewController

- (id)initWithAllEmployees {
    self = [self initWithViewModel:[[EDADirectoryViewModel alloc] initWithAllEmployees]];
    self.title = @"Directory";
    return self;
}

- (id)initWithDirectReportsOfEmployee:(id)employee {
    self = [self initWithViewModel:[[EDADirectoryViewModel alloc] initWithDirectReportsOfEmployee:employee]];
    self.title = @"Reports";
    return self;
}

- (id)initForSearching {
    self = [self initWithViewModel:[[EDADirectoryViewModel alloc] initForSearching]];
    self.title = @"Directory";
    _forSearching = YES;
    return self;
}

- (id)initWithFavorites {
    self = [self initWithViewModel:[[EDADirectoryViewModel alloc] initWithFavorites]];
    self.title = @"My Directory";
    return self;
}

- (id)initWithViewModel:(EDADirectoryViewModel *)viewModel
{
    self = [super init];
    if (self == nil) return nil;
    
    _viewModel = viewModel;

    UISegmentedControl *sortControl = [[UISegmentedControl alloc] initWithItems:@[ @"Name", @"Dept." ]];
    RACChannelTerminal *controlTerminal = [sortControl rac_newSelectedSegmentIndexChannelWithNilValue:@0];
    RACChannelTerminal *modelTerminal = RACChannelTo(self.viewModel, sortStyle);
    [modelTerminal subscribe:controlTerminal];
    [controlTerminal subscribe:modelTerminal];
    self.navigationItem.titleView = sortControl;
    
    [self rac_liftSelector:@selector(handleError:) withSignals:self.viewModel.errors, nil];
    
    @weakify(self);
    
    [[[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)]
        reduceEach:^EDADirectoryCellViewModel *(UITableView *tableView, NSIndexPath *indexPath){
            @strongify(self);
            
            return [self viewModelForIndexPath:indexPath searching:tableView != self.tableView];
        }]
        subscribeNext:^(EDADirectoryCellViewModel *cellViewModel) {
            @strongify(self);
            
            EDAEmployeeDetailViewController *viewController = [[EDAEmployeeDetailViewController alloc] initWithEmployee:cellViewModel.employee];
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    
    return self;
}

- (void)loadView {
    EDADirectoryView *view = [[EDADirectoryView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tableView = view.tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.view = view;
}

- (void)viewDidLoad {
    [self.tableView registerClass:[EDADirectoryCell class] forCellReuseIdentifier:NSStringFromClass([EDADirectoryCell class])];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.placeholder = @"Search";
    self.tableView.tableHeaderView = searchBar;
    
    if (self.forSearching) {
        searchBar.delegate = self;
        
        RAC(self.viewModel, searchString) = [[self rac_signalForSelector:@selector(searchBar:textDidChange:) fromProtocol:@protocol(UISearchBarDelegate)]
            reduceEach:^NSString *(UISearchBar *aSearchBar, NSString *text){
                return text;
            }];
    }
    else {
        self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        self.searchController.delegate = self;
        self.searchController.searchResultsDataSource = self;
        self.searchController.searchResultsDelegate = self;
        
        RAC(self.viewModel, searchString) = [[self rac_signalForSelector:@selector(searchDisplayController:shouldReloadTableForSearchString:) fromProtocol:@protocol(UISearchDisplayDelegate)]
            reduceEach:^NSString *(UISearchDisplayController *controller, NSString *searchString){
                return searchString;
            }];
    }
    
    @weakify(self);
    
    [RACObserve(self.viewModel, sections) subscribeNext:^(id x) {
        @strongify(self);
        
        [self.tableView reloadData];
    }];
    
    RAC(self.view.instructionsView, hidden) = [RACObserve(self.viewModel, showInstructions) not];
    RAC(self.view.tableView, separatorColor) = [RACObserve(self.viewModel, showInstructions)
        map:^UIColor *(NSNumber *show) {
            if (show.boolValue) {
                return [UIColor clearColor];
            }
            else {
                return nil;
            }
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
