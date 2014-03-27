//
//  NSString+URL.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/25/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (URL)

+ (NSDictionary *)parametersFromAuthURL:(NSURL *)URL ignoringString:(NSString *)string;

@end
