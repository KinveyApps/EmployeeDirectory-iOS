//
//  EDALoginView.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDALoginView.h"

@interface EDALoginView ()

@property (nonatomic, readwrite) UITextField *passwordTextField;
@property (nonatomic, readwrite) UITextField *usernameTextField;

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
    self.usernameTextField = [UITextField new];
    self.usernameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameTextField.placeholder = @"username";
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubview:self.usernameTextField];
    
    self.passwordTextField = [UITextField new];
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.placeholder = @"password";
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubview:self.passwordTextField];
    
    NSDictionary *views = @{ @"usernameTextField": self.usernameTextField,
                             @"passwordTextField": self.passwordTextField };
    
    return views;
}

- (void)setupConstraintsWithViews:(NSDictionary *)views {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[usernameTextField]-|" options:0 metrics:0 views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.passwordTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.usernameTextField attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[usernameTextField]-[passwordTextField]" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];
}

@end
