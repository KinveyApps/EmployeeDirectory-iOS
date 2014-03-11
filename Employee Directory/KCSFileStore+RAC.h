//
//  KCSResourceService+RAC.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/11/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <KinveyKit/KinveyKit.h>

@interface KCSFileStore (RAC)

+ (RACSignal *)rac_downloadImageNamed:(NSString *)name;

@end
