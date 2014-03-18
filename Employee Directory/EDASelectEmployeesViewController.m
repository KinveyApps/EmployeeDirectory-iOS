//
//  EDASelectEmployeesViewController.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDASelectEmployeesViewController.h"

#import "EDASelectEmployeesViewModel.h"
#import "EDASelectableEmployeeCell.h"
#import "EDASelectableEmployeeCellViewModel.h"
#import "EDAGroup.h"
#import "EDANewMessageViewController.h"

@interface EDASelectEmployeesViewController ()

@property (nonatomic) EDASelectEmployeesViewModel *viewModel;

@end

@implementation EDASelectEmployeesViewController

- (id)initWithGroup:(EDAGroup *)group {
    EDASelectEmployeesViewModel *viewModel = [[EDASelectEmployeesViewModel alloc] initWithGroup:group];
    
    self = [super initWithStyle:UITableViewStylePlain bindingToKeyPath:@keypath(viewModel, employees) onObject:viewModel];
    if (self == nil) return nil;
    
    self.title = group.displayName;
    _viewModel = viewModel;
    [self setup];
    
    return self;
}

- (id)initWithTagType:(EDATagType)tagType {
    EDASelectEmployeesViewModel *viewModel = [[EDASelectEmployeesViewModel alloc] initWithTagType:tagType];
    
    self = [super initWithStyle:UITableViewStylePlain bindingToKeyPath:@keypath(viewModel, employees) onObject:viewModel];
    if (self == nil) return nil;
    
    self.title = [EDATag displayNameForType:tagType];;
    _viewModel = viewModel;
    [self setup];
    
    return self;
}

- (void)setup {
    self.animateChanges = NO;
    [self registerCellClass:[EDASelectableEmployeeCell class] forObjectsWithClass:[EDASelectableEmployeeCellViewModel class]];
    
    @weakify(self);
    
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:nil action:nil];
    nextItem.rac_command = self.viewModel.nextCommand;
    [[nextItem.rac_command.executionSignals
        flatten]
        subscribeNext:^(NSSet *selectedEmployees) {
            @strongify(self);
            
            EDANewMessageViewController *viewController = [[EDANewMessageViewController alloc] initWithEmployees:selectedEmployees.allObjects];
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    self.navigationItem.rightBarButtonItem = nextItem;
    
    [self.didSelectRowSignal subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        
        EDASelectableEmployeeCellViewModel *cellViewModel = tuple.first;
        
        if ([self.viewModel.selectedEmployees containsObject:cellViewModel.employee]) {
            [self.viewModel deselectEmployee:cellViewModel.employee];
        }
        else {
            [self.viewModel selectEmployee:cellViewModel.employee];
        }
    }];
}

@end
