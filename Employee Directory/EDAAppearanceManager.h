//
//  EDAAppearanceManager.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/11/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EDAAppearanceManager : NSObject

+ (void)customizeAppearanceWithWindow:(UIWindow *)window;
+ (void)customizeAppearanceOfNavigationBar:(UINavigationBar *)navigationBar;

+ (UIButton *)button;

@end

#define CVTAccentColor [UIColor colorWithRed:7.0/255.0 green:70.0/255.0 blue:128.0/255.0 alpha:1.0]
#define CVTBackgroundColor [UIColor whiteColor]
#define CVTButtonColor [UIColor colorWithRed:38.0/255.0 green:70.0/255.0 blue:102.0/255.0 alpha:1.0]
#define CVTLightButtonColor [UIColor colorWithRed:220.0/255.0 green:232.0/255.0 blue:242.0/255.0 alpha:1.0]
#define CVTDarkTextColor [UIColor colorWithRed:54.0/255.0 green:59.0/255.0 blue:67.0/255.0 alpha:1.0]
#define CVTLightTextColor [UIColor colorWithRed:134.0/255.0 green:146.0/255.0 blue:166.0/255.0 alpha:1.0]
#define CVTHighlightTextColor [UIColor colorWithRed:0/255.0 green:157.0/255.0 blue:57.0/255.0 alpha:1.0]
#define CVTWarningTextColor [UIColor colorWithRed:206/255.0 green:32.0/255.0 blue:41.0/255.0 alpha:1.0]
#define CVTSectionHeaderColor [UIColor colorWithRed:52.0/255.0 green:55.0/255.0 blue:63.0/255.0 alpha:1.000]
