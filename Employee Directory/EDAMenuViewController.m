//
//  EDAMenuViewController.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAMenuViewController.h"

#import "EDASidebarCell.h"

NSString * const EDAMenuViewControllerIdentifierYourInfo = @"Your Info";
NSString * const EDAMenuViewControllerIdentifierDirectory = @"Directory";
NSString * const EDAMenuViewControllerIdentifierTeamMessaging = @"Team Messaging";
NSString * const EDAMenuViewControllerIdentifierAbout = @"About";
NSString * const EDAMenuViewControllerIdentifierLogOut = @"Log Out";

@interface EDAMenuViewController ()

@end

@implementation EDAMenuViewController

- (void)viewDidLoad {
    [self.tableView registerClass:[EDASidebarCell class] forCellReuseIdentifier:NSStringFromClass([EDASidebarCell class])];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.129 green:0.145 blue:0.157 alpha:1.000];
	self.tableView.separatorColor = [UIColor colorWithRed:0.196 green:0.200 blue:0.212 alpha:1.000];
    
    @weakify(self);
    
    [[self rac_signalForSelector:@selector(didSelectRowWithIdentifier:withTableView:)]
        subscribeNext:^(RACTuple *arguments) {
            @strongify(self);
            
            RACTupleUnpack(NSString *identifier, UITableView *tableView) = arguments;
            
            // Do something for `identifier`
            
            NSIndexPath *indexPath = [self indexPathForIdentifier:identifier];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
}

#pragma mark - EPSStaticTableViewController Methods

- (NSArray *)identifiers {
    return @[
             @[ EDAMenuViewControllerIdentifierYourInfo,
                EDAMenuViewControllerIdentifierDirectory,
                EDAMenuViewControllerIdentifierTeamMessaging,
                EDAMenuViewControllerIdentifierAbout ],
             @[ EDAMenuViewControllerIdentifierLogOut ]
             ];
}

- (UITableViewCell *)cellForIdentifier:(NSString *)identifier withTableView:(UITableView *)tableView {
    EDASidebarCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EDASidebarCell class])];
    
    NSString *title;
    if ([identifier isEqualToString:EDAMenuViewControllerIdentifierAbout]) {
        title = @"About";
    }
    else if ([identifier isEqualToString:EDAMenuViewControllerIdentifierDirectory]) {
        title = @"Directory";
    }
    else if ([identifier isEqualToString:EDAMenuViewControllerIdentifierLogOut]) {
        title = @"Log Out";
    }
    else if ([identifier isEqualToString:EDAMenuViewControllerIdentifierTeamMessaging]) {
        title = @"Team Messaging";
    }
    else if ([identifier isEqualToString:EDAMenuViewControllerIdentifierYourInfo]) {
        title = @"Your Info";
    }
    
    cell.textLabel.text = title;
    
    return cell;
}

@end
