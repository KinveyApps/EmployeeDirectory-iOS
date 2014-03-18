//
//  EDADirectoryView.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/18/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDADirectoryView.h"

@interface EDADirectoryView ()

@property (readwrite, nonatomic) UITableView *tableView;
@property (readwrite, nonatomic) UIView *instructionsView;

@end

@implementation EDADirectoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITableView *tableView = [UITableView new];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:tableView];
        
        UILabel *instructionsView = [UILabel new];
        instructionsView.translatesAutoresizingMaskIntoConstraints = NO;
        instructionsView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        instructionsView.numberOfLines = 0;
        instructionsView.text = @"Search for employees";
        instructionsView.textAlignment = NSTextAlignmentCenter;
        instructionsView.textColor = [UIColor grayColor];
        [self addSubview:instructionsView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(tableView, instructionsView);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[tableView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[instructionsView]|" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:instructionsView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tableView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-100]];
        
        self.tableView = tableView;
        self.instructionsView = instructionsView;
    }
    return self;
}

@end
