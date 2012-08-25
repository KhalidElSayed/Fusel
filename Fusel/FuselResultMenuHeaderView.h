//
//  FuselResultMenuHeaderView.h
//  Fusel
//
//  Created by Fränz Friederes on 15.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FuselResultMenuHeaderViewDelegate;

@interface FuselResultMenuHeaderView : UIView

@property (nonatomic, assign) id <FuselResultMenuHeaderViewDelegate> delegate;

@property (strong, nonatomic) NSString *title;

@property (nonatomic) BOOL isMultiplayer;

@end

@protocol FuselResultMenuHeaderViewDelegate <NSObject>

- (int)resultViewWillShowScore;
- (int)resultViewWillShowFuselCount;
- (int)resultViewWillShowMissedFuselCount;
- (int)resultViewWillShowPreviousHighscore;

//multiplayer
- (int)resultViewWillShowMultiplayerOpponentScore;
- (NSString *)resultViewWillShowMultiplayerPlayerName;
- (NSString *)resultViewWillShowMultiplayerOpponentName;

@end