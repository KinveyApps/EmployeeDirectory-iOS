//
//  EDAGroup+Sorting.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/13/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAGroup+Sorting.h"

@implementation EDAGroup (Sorting)

+ (NSArray *)standardSortDescriptors {
    return @[ [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES selector:@selector(localizedStandardCompare:)],
              [NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES selector:@selector(localizedStandardCompare:)] ];
}

@end
