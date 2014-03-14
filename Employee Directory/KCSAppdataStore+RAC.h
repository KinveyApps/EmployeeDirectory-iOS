//
//  KCSAppdataStore+RAC.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <KinveyKit/KinveyKit.h>

@interface KCSAppdataStore (RAC)

- (RACSignal *)rac_saveObject:(id)object;

- (RACSignal *)rac_deleteObject:(id)object;

- (RACSignal *)rac_queryWithQuery:(KCSQuery *)query;

@end
