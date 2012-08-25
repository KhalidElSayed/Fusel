//
//  FuselMenuCell.h
//  Fusel
//
//  Created by Fränz Friederes on 15.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultFuselMenuCellSideMargin 20.0

@interface FuselMenuCell : UITableViewCell

@property (nonatomic) CGRect originalFrame;
@property (nonatomic) float sideMargin;

@end
