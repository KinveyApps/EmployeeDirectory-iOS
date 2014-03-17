//
//  EDAAboutViewController.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/13/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAAboutViewController.h"

@interface EDAAboutViewController ()

@property (nonatomic) UIWebView *view;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *titleLabel;

@end

@implementation EDAAboutViewController


- (id)init
{
    self = [super init];
    if (self) {
        

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"About";

    NSDictionary *views = [self setupViews];
    [self setupConstraintsWithViews:views];

}


- (NSDictionary *)setupViews {

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.nameLabel.text = @"Employee Directory App";
    self.nameLabel.textColor = CVTDarkTextColor;
    [self.view addSubview:self.nameLabel];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.titleLabel.text = @"Built by Ballast Lane Applications, LLC";
    self.titleLabel.textColor = CVTDarkTextColor;
    [self.view addSubview:self.titleLabel];
    
    NSDictionary *views = @{ @"nameLabel": self.nameLabel,
                             @"titleLabel": self.titleLabel,
                            };
    
    return views;
}

- (void)setupConstraintsWithViews:(NSDictionary *)views {


    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[nameLabel]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[titleLabel]-|" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel]-[titleLabel]" options:0 metrics:nil views:views]];

}


@end
