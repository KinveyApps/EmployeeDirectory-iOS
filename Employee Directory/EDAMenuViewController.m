//
//  EDAMenuViewController.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAMenuViewController.h"

#import "BLAPaneController.h"
#import "EDADirectoryViewController.h"
#import "EDALoginViewController.h"
#import "EDASidebarCell.h"
#import "EDAYourInfoViewController.h"
#import "EDAMessagingViewController.h"

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
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    @weakify(self);
    
    [[self rac_signalForSelector:@selector(didSelectRowWithIdentifier:withTableView:)]
        subscribeNext:^(RACTuple *arguments) {
            @strongify(self);
            
            RACTupleUnpack(NSString *identifier, UITableView *tableView) = arguments;
            
            NSIndexPath *indexPath = [self indexPathForIdentifier:identifier];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
    
    RACSignal *selectedIdentifierSignal = [[self rac_signalForSelector:@selector(didSelectRowWithIdentifier:withTableView:)]
        // Reduce the signal to send only the identifier
        reduceEach:^NSString *(NSString *identifier, UITableView *tableView){
            return identifier;
        }];
    
    [selectedIdentifierSignal subscribeNext:^(NSString *identifier) {
        @strongify(self);
        
        if ([identifier isEqualToString:EDAMenuViewControllerIdentifierLogOut]) {
            [self logOut];
        }
        else {
            UIViewController *newViewController;
            
            if ([identifier isEqualToString:EDAMenuViewControllerIdentifierDirectory]) {
                newViewController = [[EDADirectoryViewController alloc] initWithAllEmployees];
            }
            else if ([identifier isEqualToString:EDAMenuViewControllerIdentifierYourInfo]) {
                newViewController = [EDAYourInfoViewController new];
            }
            else if ([identifier isEqualToString:EDAMenuViewControllerIdentifierTeamMessaging]) {
                newViewController = [EDAMessagingViewController new];
            }
            else {
                newViewController = [UIViewController new];
            }
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newViewController];
            [self.paneController presentNewRootViewController:navigationController];
        }
    }];
}

#pragma mark - Actions

- (void)logOut {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to log out?" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out", nil];
    [alertView show];
    
    @weakify(self);
    
    [[alertView.rac_buttonClickedSignal
        filter:^BOOL(NSNumber *button) {
            return button.integerValue == 1;
        }]
        subscribeNext:^(id x) {
            @strongify(self);
            
            [[KCSUser activeUser] logout];
            
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[EDALoginViewController new]] animated:YES completion:NULL];
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
