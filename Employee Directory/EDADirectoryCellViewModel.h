//
//  EDADirectoryCellViewModel.h
//  Employee Directory
//
//  Created by Justin Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EDAEmployee;

@interface EDADirectoryCellViewModel : NSObject

@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) NSString *title;

- (id)initWithEmployee:(EDAEmployee *)employee;

@end
