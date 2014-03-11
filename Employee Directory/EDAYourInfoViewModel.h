//
//  EDAYourInfoViewModel.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/11/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EDAYourInfoViewModel : NSObject

/// Send an EDAEmployee object for the current
@property (readonly, nonatomic) RACCommand *getYourInfoCommand;

@end
