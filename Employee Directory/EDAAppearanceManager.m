//
//  EDAAppearanceManager.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/11/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAAppearanceManager.h"

@implementation EDAAppearanceManager

+ (void)customizeAppearanceWithWindow:(UIWindow *)window {
    window.tintColor = CVTAccentColor;
    
    // Nav bar
    [[UINavigationBar appearance] setBarTintColor:CVTAccentColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.65] }];
}

+ (UIButton *)button {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[self imageFromColor:CVTButtonColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageFromColor:CVTLightTextColor] forState:UIControlStateHighlighted];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
	button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    return button;
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
