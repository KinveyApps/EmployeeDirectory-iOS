//
//  EDAEmployDetailView.m
//  Employee Directory
//
//  Created by Justin Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployeeDetailView.h"

@interface EDAEmployeeDetailView ()

@property (nonatomic) UIButton *callButton;
@property (nonatomic) UIButton *emailButton;
@property (nonatomic) UIButton *favoriteButton;
@property (nonatomic) UIButton *linkedinButton;
@property (nonatomic) UIButton *messageButton;
@property (nonatomic) UIButton *mobileCallButton;
@property (nonatomic) UIButton *textButton;
@property (nonatomic) UIButton *tagButton;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *addressLabel;
@property (nonatomic) UILabel *linkedInHeadlineLabel;
@property (nonatomic) UILabel *linkedInSummaryLabel;
@property (nonatomic) UILabel *mobileNumberLabel;
@property (nonatomic) UILabel *emailLabel;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *officeNumberLabel;
@property (nonatomic) UILabel *textNumberLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIScrollView *scrollView;

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
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.addressLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.addressLabel.textColor = CVTDarkTextColor;
    self.addressLabel.numberOfLines = 0;
    [self.containerView addSubview:self.addressLabel];
    
    self.officeNumberLabel = [[UILabel alloc] init];
    self.officeNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.officeNumberLabel.text = @"Office: 555-555-5555";
    self.officeNumberLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.officeNumberLabel.textColor = CVTDarkTextColor;
    [self.containerView addSubview:self.officeNumberLabel];
    
    self.callButton = [EDAAppearanceManager button];
    self.callButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.callButton setTitle:@"Call" forState:UIControlStateNormal];
    [self.containerView addSubview:self.callButton];
    
    self.mobileNumberLabel = [[UILabel alloc] init];
    self.mobileNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.mobileNumberLabel.text = @"Office: 555-555-5555";
    self.mobileNumberLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.mobileNumberLabel.textColor = CVTDarkTextColor;
    [self.containerView addSubview:self.mobileNumberLabel];
    
    self.mobileCallButton = [EDAAppearanceManager button];
    self.mobileCallButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mobileCallButton setTitle:@"Call" forState:UIControlStateNormal];
    [self.containerView addSubview:self.mobileCallButton];
    
    self.textNumberLabel = [[UILabel alloc] init];
    self.textNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textNumberLabel.text = @"Office: 555-555-5555";
    self.textNumberLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.textNumberLabel.textColor = CVTDarkTextColor;
    [self.containerView addSubview:self.textNumberLabel];
    
    self.textButton = [EDAAppearanceManager button];
    self.textButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.textButton setTitle:@"Text" forState:UIControlStateNormal];
    [self.containerView addSubview:self.textButton];
    
    self.emailLabel = [[UILabel alloc] init];
    self.emailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.emailLabel.text = @"E-mail address";
    self.emailLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.emailLabel.textColor = CVTDarkTextColor;
    [self.containerView addSubview:self.emailLabel];
    
    self.emailButton = [EDAAppearanceManager button];
    self.emailButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.emailButton setTitle:@"Email" forState:UIControlStateNormal];
    [self.containerView addSubview:self.emailButton];
    
    self.messageButton = [EDAAppearanceManager button];
    self.messageButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.messageButton setTitle:@"Message" forState:UIControlStateNormal];
    //[self.containerView addSubview:self.messageButton];
    
    self.linkedinButton = [EDAAppearanceManager button];
    self.linkedinButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.linkedinButton setTitle:@"View Linkedin" forState:UIControlStateNormal];
    [self.containerView addSubview:self.linkedinButton];
/*

        self.favoriteButton = [EDAAppearanceManager button];
    self.favoriteButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
    [self.containerView addSubview:self.favoriteButton];
 */
    self.tagButton = [EDAAppearanceManager button];
    self.tagButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tagButton setTitle:@"Tag" forState:UIControlStateNormal];
    [self.containerView addSubview:self.tagButton];
    
    NSDictionary *views = @{ @"nameLabel": self.nameLabel,
                             @"titleLabel": self.titleLabel,
                             @"callButton": self.callButton,
                             @"emailButton": self.emailButton,
                            // @"messageButton": self.messageButton,
                             @"linkedinButton": self.linkedinButton,
                             @"imageView": self.imageView,
                             @"linkedInHeadlineLabel": self.linkedInHeadlineLabel,
                             @"linkedInSummaryLabel": self.linkedInSummaryLabel,
                             @"addressLabel": self.addressLabel,
                             @"tagButton": self.tagButton,
                             @"officeNumberLabel": self.officeNumberLabel,
                             @"mobileNumberLabel": self.mobileNumberLabel,
                             @"mobileCallButton": self.mobileCallButton,
                             @"emailLabel":self.emailLabel,
                             @"textNumberLabel": self.textNumberLabel,
                             @"textButton": self.textButton };
    
    return views;
}

- (void)setupConstraintsWithViews:(NSDictionary *)views {
    NSDictionary *metrics = @{ @"buttonWidth": @80,
                               @"insetSpacing": @20,
                               @"imageSize": @60 };
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[imageView(imageSize)]-[nameLabel]-(insetSpacing)-|" options:NSLayoutFormatAlignAllTop metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:[imageView(imageSize)]" options:0 metrics:metrics views:views]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[officeNumberLabel]-[callButton(buttonWidth)]-(insetSpacing)-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[mobileNumberLabel]-[mobileCallButton(buttonWidth)]-(insetSpacing)-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[textNumberLabel]-[textButton(buttonWidth)]-(insetSpacing)-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[emailLabel]-[emailButton(buttonWidth)]-(insetSpacing)-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[linkedinButton]-(insetSpacing)-|" options:0 metrics:metrics views:views]];

   // [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[favoriteButton]-(insetSpacing)-|" options:0 metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[tagButton]-(insetSpacing)-|" options:0 metrics:metrics views:views]];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel]-[titleLabel]" options:0 metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView]-[tagButton]-[linkedInHeadlineLabel]-[linkedInSummaryLabel]-[addressLabel]-(insetSpacing)-[callButton]-(insetSpacing)-[mobileCallButton]-(insetSpacing)-[textButton]-(insetSpacing)-[emailButton]-(insetSpacing)-[linkedinButton]-(insetSpacing)-|" options:0 metrics:metrics views:views]];

    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel]-[titleLabel]" options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing metrics:metrics views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[linkedInHeadlineLabel]-[linkedInSummaryLabel]-[addressLabel]" options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(insetSpacing)-[linkedInHeadlineLabel]-(insetSpacing)-|" options:0 metrics:metrics views:views]];
}

@end
