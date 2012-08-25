//
//  FuselResultViewController.h
//  Fusel
//
//  Created by Fränz Friederes on 08.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>

#import "FuselMenuTableViewController.h"
#import "FuselResultMenuHeaderView.h"
#import "FuselStatistics.h"
#import "FuselLevel.h"

#define ARC4RANDOM_MAX 0x100000000

@protocol FuselResultMenuHeaderViewDelegate;
@protocol FuselResultViewControllerDelegate;

@interface FuselResultViewController : FuselMenuTableViewController <FuselResultMenuHeaderViewDelegate, UIActionSheetDelegate>

@property (nonatomic, assign) id <FuselResultViewControllerDelegate> delegate;

@property (strong, nonatomic) FuselLevel *fuselLevel;
@property (nonatomic) int loopIncrementMax;

- (id)initWithLevel:(FuselLevel *)fuselLevel;
- (void)countingDidFinish;

- (void)shareResult;

@end

@protocol FuselResultViewControllerDelegate <NSObject>

- (void)fuselResultViewControllerDidFinish;
- (void)fuselResultViewControllerDidReplay;

@end
