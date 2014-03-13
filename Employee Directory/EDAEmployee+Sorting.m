//
//  EDAEmployee+Sorting.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/13/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDAEmployee+Sorting.h"

@implementation EDAEmployee (Sorting)

+ (NSArray *)standardSortDescriptors {
    return @[ [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES selector:@selector(localizedStandardCompare:)],
              [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedStandardCompare:)],
              [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES selector:@selector(localizedStandardCompare:)] ];
}

@end
