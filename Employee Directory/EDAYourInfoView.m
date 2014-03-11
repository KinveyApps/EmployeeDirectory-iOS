//
//  EDAYourInfoView.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/11/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAYourInfoView.h"

@interface EDAYourInfoView ()

@property (readwrite, nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation EDAYourInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.spinner];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    
    return self;
}

@end
