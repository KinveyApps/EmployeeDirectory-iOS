//
//  EDAEmployDetailView.h
//  Employee Directory
//
//  Created by Justin Stuart on 3/10/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDAEmployeeDetailView : UIView

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UILabel *nameLabel;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *linkedInHeadlineLabel;
@property (nonatomic, readonly) UILabel *linkedInSummaryLabel;
@property (nonatomic, readonly) UILabel *addressLabel;
@property (nonatomic, readonly) UIButton *callButton;
@property (nonatomic, readonly) UIButton *textButton;
@property (nonatomic, readonly) UIButton *emailButton;
@property (nonatomic, readonly) UIButton *messageButton;
@property (nonatomic, readonly) UIButton *linkedinButton;
@property (nonatomic, readonly) UIButton *supervisorButton;
@property (nonatomic, readonly) UIButton *reportsButton;
@property (nonatomic, readonly) UIButton *favoriteButton;

@end
