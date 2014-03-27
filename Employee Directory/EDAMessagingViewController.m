//
//  EDAMessagingViewController.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAMessagingViewController.h"

#import "EDAMessagingViewModel.h"
#import "EDAGroupCell.h"
#import "EDAGroupCellViewModel.h"
#import "EDASelectEmployeesViewController.h"

@interface EDAMessagingViewController ()

@property (nonatomic) EDAMessagingViewModel *viewModel;

@end

@implementation EDAMessagingViewController

- (id)init
{
    EDAMessagingViewModel *viewModel = [EDAMessagingViewModel new];
    
    self = [super initWithStyle:UITableViewStylePlain bindingToKeyPath:@keypath(viewModel, groups) onObject:viewModel];
    if (self == nil) return nil;
    
    _viewModel = viewModel;
    
    self.title = @"Messaging";
    self.animateChanges = NO;
    
    [self registerCellClass:[EDAGroupCell class] forObjectsWithClass:[EDAGroupCellViewModel class]];
    
    @weakify(self);
    
    [self.didSelectRowSignal subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        EDAGroupCellViewModel *aViewModel = tuple.first;
        
        EDASelectEmployeesViewController *viewController;
        
        if (aViewModel.group != nil) {
            EDAGroup *group = aViewModel.group;
            viewController = [[EDASelectEmployeesViewController alloc] initWithGroup:group];
        }
        else {
            viewController = [[EDASelectEmployeesViewController alloc] initWithTagType:aViewModel.tagType];
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
    UISegmentedControl *sortControl = [[UISegmentedControl alloc] initWithItems:@[ @"Group", @"Tag" ]];
    RACChannelTerminal *controlTerminal = [sortControl rac_newSelectedSegmentIndexChannelWithNilValue:@0];
    RACChannelTerminal *modelTerminal = RACChannelTo(self.viewModel, groupType);
    [modelTerminal subscribe:controlTerminal];
    [controlTerminal subscribe:modelTerminal];
    //self.navigationItem.titleView = sortControl;
    
    return self;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.viewModel.groupType == EDAMessagingViewModelGroupTypeGroup) {
        return @"Groups";
    }
    else {
        return @"Tags";
    }
}

@end
