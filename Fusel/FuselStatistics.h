//
//  FuselStatistics.h
//  Fusel
//
//  Created by Fränz Friederes on 13.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#define kUserDefaultsFuselCollected     @"FuselsCollected"
#define kUserDefaultsFuselMissed        @"FuselsMissed"
#define kUserDefaultsTotalSecondsPlayed @"SecondsPlayed"

#define kUserDefaultsFuselCollectedCounter  @"FuselsCollectedCounter"
#define kCounterReportUrl @"http://fusel.lu/statsupdate.php"

#define kUserDefaultsHighscoreShortGame     @"HighscoreShort"
#define kUserDefaultsHighscoreMediumGame    @"HighscoreMedium"
#define kUserDefaultsHighscoreSandboxGame   @"HighscoreSandbox"

#define kUserDefaultsGameCenterDisabled     @"GameCenterDisabled"

#define kLeaderboardModeShort           @"fusel_short"
#define kLeaderboardModeMedium          @"fusel_medium"
#define kLeaderboardModeSandbox         @"fusel_sandbox"
#define kLeaderboardFuselCollected      @"fusel_total_collected"
#define kLeaderboardFuselMissed         @"fusel_total_missed"

@interface FuselStatistics : NSObject

@property (nonatomic) BOOL isGameCenterDisabled;

+ (FuselStatistics *)localStatistics;

- (void)syncWithGameCenter;
- (void)authenticateLocalPlayer;

- (BOOL)isLoggedInToGameCenter;
- (void)showGameCenterLoginNeededMessage;

- (void)askGameCenterHighscoreForCategory:(NSString *)category;
- (void)gameCenterHighscore:(int)score forCategory:(NSString *)category;

- (void)reportScoreToGameCenter:(int)score withCategory:(NSString *)category;
- (void)reportFuselCollectedCounterToWebsite;

- (int)totalFuselsCollected;
- (int)addToTotalFuselsCollected:(int)count;

- (int)totalFuselsMissed;
- (int)addToTotalFuselsMissed:(int)count;

- (int)totalSecondsPlayed;
- (int)addToTotalSecondsPlayed:(int)count;

- (int)shortGameHighscore;
- (void)reportShortGameScore:(int)score;

- (int)mediumGameHighscore;
- (void)reportMediumGameScore:(int)score;

- (int)sandboxGameHighscore;
- (void)reportSandboxGameScore:(int)score;

- (int)previousShortGameHighscore;
- (int)previousMediumGameHighscore;
- (int)previousSandboxGameHighscoree;

@end
