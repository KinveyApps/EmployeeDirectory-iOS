//
//  EDAMenuViewController.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAMenuViewController.h"

NSString * const EDAMenuViewControllerIdentifierYourInfo = @"Your Info";
NSString * const EDAMenuViewControllerIdentifierDirectory = @"Directory";
NSString * const EDAMenuViewControllerIdentifierTeamMessaging = @"Team Messaging";
NSString * const EDAMenuViewControllerIdentifierAbout = @"About";
NSString * const EDAMenuViewControllerIdentifierLogOut = @"Log Out";

@interface EDAMenuViewController ()

@end

@implementation EDAMenuViewController

- (void)viewDidLoad {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
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
