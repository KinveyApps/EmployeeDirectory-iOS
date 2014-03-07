//
//  EDAEmployee.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/7/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployee.h"

@implementation EDAEmployee

#pragma mark - Kinvey

- (NSDictionary *)hostToKinveyPropertyMapping {
    return @{ @"username": @keypath(self.username),
              @"firstName": @keypath(self.firstName),
              @"lastName": @keypath(self.lastName),
              @"title": @keypath(self.title),
              @"division": @keypath(self.division),
              @"department": @keypath(self.department),
              @"group": @keypath(self.group),
              @"workPhone": @keypath(self.workPhone),
              @"cellPhone": @keypath(self.cellPhone),
              @"email": @keypath(self.email),
              @"supervisor": @keypath(self.supervisor),
              @"hierarchy": @keypath(self.hierarchy) };
}

@end
