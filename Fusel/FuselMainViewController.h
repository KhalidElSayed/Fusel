//
//  FuselMainViewController.h
//  Fusel
//
//  Created by Fränz Friederes on 08.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FuselMenuTableViewController.h"
#import "AboutViewController.h"
#import "FuselLevel.h"
#import "FuselLevelViewController.h"
#import "StatisticsViewController.h"

@protocol FuselLevelViewControllerDelegate;

@interface FuselMainViewController : FuselMenuTableViewController <FuselLevelViewControllerDelegate, GKMatchmakerViewControllerDelegate>

@property (strong, nonatomic) FuselLevelViewController *fuselLevelViewController;

@property (nonatomic) FuselLevelMode levelMode;

- (void)startLevel:(FuselLevelMode)levelMode;
- (void)startMultiplayerLevel:(FuselLevelMode)levelMode;

@end
