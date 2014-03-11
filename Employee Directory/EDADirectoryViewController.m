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
    _viewModel = [EDADirectoryViewModel new];
    self = [super initWithStyle:UITableViewStylePlain bindingToKeyPath:@keypath(_viewModel, employees) onObject:self.viewModel];
    if (self == nil) return nil;
    
    self.title = @"Directory";
    self.animateChanges = NO;
    
    [self registerCellClass:[EDADirectoryCell class] forObjectsWithClass:[EDADirectoryCellViewModel class]];
    
    [self.didSelectRowSignal subscribeNext:^(RACTuple *tuple) {
        EDADirectoryCellViewModel *object = tuple.first;
        EDAEmployeeDetailViewController *viewController = [[EDAEmployeeDetailViewController alloc] initWithEmployee:object.employee];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
    return self;
}


@end
