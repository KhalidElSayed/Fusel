//
//  FuselLevelViewController.h
//  Fusel
//
//  Created by Fränz Friederes on 08.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#import "FuselLevel.h"
#import "FuselLevelView.h"
#import "FuselResultViewController.h"
#import "FuselMultiplayerLevel.h"

@protocol FuselLevelViewDataSource;
@protocol FuselResultViewControllerDelegate;
@protocol FuselLevelViewControllerDelegate;

@interface FuselLevelViewController : UIViewController <FuselLevelViewDataSource, FuselLevelDelegate, FuselResultViewControllerDelegate>

@property (nonatomic, assign) id <FuselLevelViewControllerDelegate> delegate;

@property (strong, nonatomic) FuselLevel *level;
@property (strong, nonatomic) FuselResultViewController *fuselResultViewController;

- (id)initWithLevelMode:(FuselLevelMode)levelMode;
- (id)initWithLevel:(FuselLevel *)level;

- (void)resetWithLevel:(FuselLevel *)level;

- (FuselLevelView *)levelView;

@end

@protocol FuselLevelViewControllerDelegate <NSObject>

- (void)fuselLevelViewControllerDidFinish;
- (void)fuselLevelViewControllerReplayLevel:(FuselLevel *)level;

@end
