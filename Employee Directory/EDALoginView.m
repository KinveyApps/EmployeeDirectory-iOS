//
//  EDALoginView.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDALoginView.h"

@interface EDALoginView ()

@end

@implementation EDALoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSDictionary *views = [self setupViews];
        [self setupConstraintsWithViews:views];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (NSDictionary *)setupViews {
    UILabel *label = [UILabel new];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label.text = @"Welcome to the Employee Directory app. Tap “Next” to sign in with Citrix.";
    label.numberOfLines = 0;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:label];
    
    NSDictionary *views = @{ @"label": label };
    
    return views;
}

- (void)setupConstraintsWithViews:(NSDictionary *)views {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[label]-|" options:0 metrics:0 views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(100)-[label]" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];
}

@end
