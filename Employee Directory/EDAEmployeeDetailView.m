//
//  EDAEmployDetailView.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployeeDetailView.h"

@interface EDAEmployeeDetailView ()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *callButton;
@property (nonatomic) UIButton *textButton;
@property (nonatomic) UIButton *emailButton;
@property (nonatomic) UIButton *messageButton;
@property (nonatomic) UIButton *linkedinButton;
@property (nonatomic) UIButton *supervisorButton;
@property (nonatomic) UIButton *reportsButton;

@property (nonatomic) UIView *containerView;
@property (nonatomic) UIScrollView *scrollView;

@end

@implementation EDAEmployeeDetailView

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

- (void)setupScrollView {
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.scrollEnabled = YES;
    [self addSubview:scrollView];
    
    NSDictionary *scrollViews = @{ @"scrollView": scrollView };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[scrollView]|" options:0 metrics:nil views:scrollViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:scrollViews]];
    
    self.containerView = [UIView new];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:self.containerView];
    
    NSDictionary *containerViews = @{ @"containerView": self.containerView };
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[containerView(320)]|" options:0 metrics:nil views:containerViews]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[containerView]|" options:0 metrics:nil views:containerViews]];
}

- (NSDictionary *)setupViews {
    [self setupScrollView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.imageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.nameLabel.text = @"Test Name";
    [self.containerView addSubview:self.nameLabel];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.titleLabel.text = @"Test Title";
    [self.containerView addSubview:self.titleLabel];
    
    self.callButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.callButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.callButton setTitle:@"Call" forState:UIControlStateNormal];
    self.callButton.backgroundColor = [UIColor redColor];
    [self.containerView addSubview:self.callButton];
    
    self.textButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.textButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.textButton setTitle:@"Text" forState:UIControlStateNormal];
    self.textButton.backgroundColor = [UIColor redColor];
    [self.containerView addSubview:self.textButton];
    
    self.emailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.emailButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.emailButton setTitle:@"Email" forState:UIControlStateNormal];
    self.emailButton.backgroundColor = [UIColor redColor];
    [self.containerView addSubview:self.emailButton];
    
    self.messageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.messageButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.messageButton setTitle:@"Message" forState:UIControlStateNormal];
    self.messageButton.backgroundColor = [UIColor redColor];
    [self.containerView addSubview:self.messageButton];
    
    self.linkedinButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.linkedinButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.linkedinButton setTitle:@"View Linkedin" forState:UIControlStateNormal];
    self.linkedinButton.backgroundColor = [UIColor redColor];
    [self.containerView addSubview:self.linkedinButton];
    
    self.supervisorButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.supervisorButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.supervisorButton setTitle:@"Supervisor" forState:UIControlStateNormal];
    self.supervisorButton.backgroundColor = [UIColor redColor];
    [self.containerView addSubview:self.supervisorButton];
    
    self.reportsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.reportsButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.reportsButton.backgroundColor = [UIColor redColor];
    [self.reportsButton setTitle:@"Reports" forState:UIControlStateNormal];
    [self.containerView addSubview:self.reportsButton];
    
    NSDictionary *views = @{ @"nameLabel": self.nameLabel,
                             @"titleLabel": self.titleLabel,
                             @"callButton": self.callButton,
                             @"textButton": self.textButton,
                             @"emailButton": self.emailButton,
                             @"messageButton": self.messageButton,
                             @"linkedinButton": self.linkedinButton,
                             @"supervisorButton": self.supervisorButton,
                             @"reportsButton": self.reportsButton,
                             @"imageView": self.imageView };
    
    return views;
}

- (void)setupConstraintsWithViews:(NSDictionary *)views {
    NSDictionary *metrics = @{ @"buttonWidth": @80,
                               @"insetSpacing": @40,
                               @"imageSize": @60 };
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[imageView(imageSize)]-[nameLabel]-(insetSpacing)-|" options:NSLayoutFormatAlignAllTop metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:[imageView(imageSize)]" options:0 metrics:metrics views:views]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[callButton(buttonWidth)]-(>=20)-[textButton(buttonWidth)]-(insetSpacing)-|" options:NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[emailButton(buttonWidth)]-(>=20)-[messageButton(buttonWidth)]-(insetSpacing)-|" options:NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[linkedinButton]-(insetSpacing)-|" options:0 metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[supervisorButton(buttonWidth)]-(>=20)-[reportsButton(buttonWidth)]-(insetSpacing)-|" options:NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel]-[titleLabel]-(40)-[callButton(buttonWidth)]-[emailButton(buttonWidth)]-[linkedinButton(buttonWidth)]-[supervisorButton(buttonWidth)]-|" options:0 metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel]-[titleLabel]" options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[textButton(buttonWidth)]" options:0 metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[messageButton(buttonWidth)]" options:0 metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[reportsButton(buttonWidth)]" options:0 metrics:metrics views:views]];
}

@end
