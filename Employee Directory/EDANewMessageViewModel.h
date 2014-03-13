//
//  EDANewMessageViewModel.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/13/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const EDANewMessageViewModelErrorDomain;

extern NSInteger const EDANewMessageViewModelEmailErrorCodeNotSetUp;

@interface EDANewMessageViewModel : NSObject

@property (nonatomic) NSString *messageText;

- (id)initWithEmployees:(NSArray *)employees;

/// Sends YES when the message has been successfully sent.
/// @param viewController The view controller to use to present the mail view controller.
- (RACCommand *)sendMessageCommandWithViewController:(UIViewController *)viewController;

@end
