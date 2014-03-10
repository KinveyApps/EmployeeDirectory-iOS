//
//  EDALoginModel.h
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EDALoginViewModel : NSObject

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) BOOL acceptInput;

@property (readonly, nonatomic) RACCommand *loginCommand;

- (id)initWithViewController:(UIViewController *)viewController; // A view controller is needed to present the LinkedIn authorization view

@end
