//
//  EDAGroupCell.h
//  Employee Directory
//
//  Created by Peter Stuart on 3/12/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EDAGroupCellViewModel;

@interface EDAGroupCell : UITableViewCell <EPSReactiveTableViewCell>

@property (nonatomic) EDAGroupCellViewModel *object;

@end
