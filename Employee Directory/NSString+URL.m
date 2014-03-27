//
//  NSString+URL.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/25/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSURL (URL)

+ (NSDictionary *)parametersFromAuthURL:(NSURL *)URL ignoringString:(NSString *)stringToIgnore {
    NSString *string = URL.absoluteString;
    string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@?", stringToIgnore] withString:@""];
    
    NSArray *components = [string componentsSeparatedByString:@"&"];
    NSDictionary *parameters = [components.rac_sequence foldLeftWithStart:[NSMutableDictionary new] reduce:^id(NSMutableDictionary *dictionary, NSString *component) {
        NSArray *subcomponents = [component componentsSeparatedByString:@"="];
        if (subcomponents.count != 2) return dictionary;
        NSString *parameter = subcomponents.firstObject;
        NSString *value = [subcomponents.lastObject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        dictionary[parameter] = value;
        return dictionary;
    }];
    
    return parameters;
}

@end
