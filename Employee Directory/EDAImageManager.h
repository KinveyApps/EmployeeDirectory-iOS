//
//  EDAImageManager.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/14/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EDAImageManager : NSObject

+ (instancetype)sharedManager;

- (RACSignal *)imageFromURL:(NSURL *)URL;

@end
