//
//  EDAEmployDetailView.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployeeDetailView.h"

@interface EDAEmployeeDetailView ()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *linkedInHeadlineLabel;
@property (nonatomic) UILabel *linkedInSummaryLabel;
@property (nonatomic) UIButton *callButton;
@property (nonatomic) UIButton *textButton;
@property (nonatomic) UIButton *emailButton;
@property (nonatomic) UIButton *messageButton;
@property (nonatomic) UIButton *linkedinButton;
@property (nonatomic) UIButton *supervisorButton;
@property (nonatomic) UIButton *reportsButton;
@property (nonatomic) UIButton *favoriteButton;

@property (nonatomic) UIView *containerView;

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
    self.scrollView = scrollView;
    
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
    self.nameLabel.textColor = CVTDarkTextColor;
    [self.containerView addSubview:self.nameLabel];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.titleLabel.text = @"Test Title";
    self.titleLabel.textColor = CVTDarkTextColor;
    [self.containerView addSubview:self.titleLabel];
    
    self.linkedInHeadlineLabel = [[UILabel alloc] init];
    self.linkedInHeadlineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.linkedInHeadlineLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.linkedInHeadlineLabel.textColor = CVTDarkTextColor;
    self.linkedInHeadlineLabel.numberOfLines = 0;
    [self.containerView addSubview:self.linkedInHeadlineLabel];
    
    self.linkedInSummaryLabel = [[UILabel alloc] init];
    self.linkedInSummaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.linkedInSummaryLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.linkedInSummaryLabel.textColor = CVTDarkTextColor;
    self.linkedInSummaryLabel.numberOfLines = 0;
    [self.containerView addSubview:self.linkedInSummaryLabel];
    
    self.callButton = [EDAAppearanceManager button];
    self.callButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.callButton setTitle:@"Call" forState:UIControlStateNormal];
    [self.containerView addSubview:self.callButton];
    
    self.textButton = [EDAAppearanceManager button];
    self.textButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.textButton setTitle:@"Text" forState:UIControlStateNormal];
    [self.containerView addSubview:self.textButton];
    
    self.emailButton = [EDAAppearanceManager button];
    self.emailButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.emailButton setTitle:@"Email" forState:UIControlStateNormal];
    [self.containerView addSubview:self.emailButton];
    
    self.messageButton = [EDAAppearanceManager button];
    self.messageButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.messageButton setTitle:@"Message" forState:UIControlStateNormal];
    [self.containerView addSubview:self.messageButton];
    
    self.linkedinButton = [EDAAppearanceManager button];
    self.linkedinButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.linkedinButton setTitle:@"View Linkedin" forState:UIControlStateNormal];
    [self.containerView addSubview:self.linkedinButton];
    
    self.supervisorButton = [EDAAppearanceManager button];
    self.supervisorButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.supervisorButton setTitle:@"Supervisor" forState:UIControlStateNormal];
    [self.containerView addSubview:self.supervisorButton];
    
    self.reportsButton = [EDAAppearanceManager button];
    self.reportsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.reportsButton setTitle:@"Reports" forState:UIControlStateNormal];
    [self.containerView addSubview:self.reportsButton];
    
    self.favoriteButton = [EDAAppearanceManager button];
    self.favoriteButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
    [self.containerView addSubview:self.favoriteButton];
    
    NSDictionary *views = @{ @"nameLabel": self.nameLabel,
                             @"titleLabel": self.titleLabel,
                             @"callButton": self.callButton,
                             @"textButton": self.textButton,
                             @"emailButton": self.emailButton,
                             @"messageButton": self.messageButton,
                             @"linkedinButton": self.linkedinButton,
                             @"supervisorButton": self.supervisorButton,
                             @"reportsButton": self.reportsButton,
                             @"imageView": self.imageView,
                             @"linkedInHeadlineLabel": self.linkedInHeadlineLabel,
                             @"linkedInSummaryLabel": self.linkedInSummaryLabel,
                             @"favoriteButton": self.favoriteButton };
    
    return views;
}

- (void)setupConstraintsWithViews:(NSDictionary *)views {
    NSDictionary *metrics = @{ @"buttonWidth": @120,
                               @"insetSpacing": @20,
                               @"imageSize": @60 };
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[imageView(imageSize)]-[nameLabel]-(insetSpacing)-|" options:NSLayoutFormatAlignAllTop metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:[imageView(imageSize)]" options:0 metrics:metrics views:views]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[callButton]-(insetSpacing)-[textButton(==callButton)]-(insetSpacing)-|" options:NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[emailButton]-(insetSpacing)-[messageButton(==emailButton)]-(insetSpacing)-|" options:NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[linkedinButton]-(insetSpacing)-|" options:0 metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[supervisorButton]-(insetSpacing)-[reportsButton(==supervisorButton)]-(insetSpacing)-|" options:NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[favoriteButton]-(insetSpacing)-|" options:0 metrics:metrics views:views]];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel]-[titleLabel]" options:0 metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView]-[linkedInHeadlineLabel]-[linkedInSummaryLabel]-(insetSpacing)-[callButton]-(insetSpacing)-[emailButton]-(insetSpacing)-[linkedinButton]-(insetSpacing)-[supervisorButton]-(insetSpacing)-[favoriteButton]-(insetSpacing)-|" options:0 metrics:metrics views:views]];

    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel]-[titleLabel]" options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[linkedInHeadlineLabel]-[linkedInSummaryLabel]" options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[linkedInHeadlineLabel]-(insetSpacing)-|" options:0 metrics:metrics views:views]];
}

@end
