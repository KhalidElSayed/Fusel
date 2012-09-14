//
//  FuselStatistics.m
//  Fusel
//
//  Created by Fränz Friederes on 13.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import "FuselStatistics.h"

@interface FuselStatistics ()

@property (nonatomic) int totalFuselsCollected;
@property (nonatomic) int totalFuselsMissed;
@property (nonatomic) int totalSecondsPlayed;

@property (nonatomic) int totalFuselsCollectedCounter;

@property (nonatomic) int shortGameHighscore;
@property (nonatomic) int mediumGameHighscore;
@property (nonatomic) int sandboxGameHighscore;

@property (nonatomic) int previousShortGameHighscore;
@property (nonatomic) int previousMediumGameHighscore;
@property (nonatomic) int previousSandboxGameHighscoree;

@property (strong, nonatomic) NSMutableData *receivedData;

@end

@implementation FuselStatistics

@synthesize previousShortGameHighscore = _previousShortGameHighscore, previousMediumGameHighscore = _previousMediumGameHighscore, previousSandboxGameHighscoree = _previousSandboxGameHighscoree, receivedData = _receivedData;

static FuselStatistics *_localStatistics;


- (id)init
{
    if (self = [super init]) {
        
        
        
    }
    
    return self;
}

+ (FuselStatistics *)localStatistics
{
    if (!_localStatistics)
        
        _localStatistics = [[FuselStatistics alloc] init];
    
    return _localStatistics;
}


- (void)authenticateLocalPlayer
{
    //try to login a player
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        
        if (!error) {
            
            [self syncWithGameCenter];
            
        }
        
    }];
}

- (void)syncWithGameCenter
{
    if (self.isGameCenterDisabled)
    
        //cancel this action
        return;

    //get highscores from gamecenter
    [self askGameCenterHighscoreForCategory:kLeaderboardFuselCollected];
    [self askGameCenterHighscoreForCategory:kLeaderboardFuselMissed];
    
    [self askGameCenterHighscoreForCategory:kLeaderboardModeShort];
    [self askGameCenterHighscoreForCategory:kLeaderboardModeMedium];
    [self askGameCenterHighscoreForCategory:kLeaderboardModeSandbox];
}

- (void)askGameCenterHighscoreForCategory:(NSString *)category
{
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] initWithPlayerIDs:[NSArray arrayWithObject:[GKLocalPlayer localPlayer].playerID]];
    
    if (leaderboardRequest != nil) {
        
        leaderboardRequest.range = NSMakeRange(1,1);
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardRequest.category = category;
        
        [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            
            if (scores != nil && [scores count] == 1) {
                
                GKScore *highscore = [scores objectAtIndex:0];
                
                [self gameCenterHighscore:highscore.value forCategory:category];
                
            }
            
        }];
        
    }
}

- (void)gameCenterHighscore:(int)score forCategory:(NSString *)category
{
    if ([category isEqualToString:kLeaderboardFuselCollected]) {
        
        if (score > self.totalFuselsCollected)
        
            [self setTotalFuselsCollected:score];
    
    } else if ([category isEqualToString:kLeaderboardFuselMissed]) {
        
        if (score > self.totalFuselsMissed)
        
            [self setTotalFuselsMissed:score];
    
    } else if ([category isEqualToString:kLeaderboardModeShort]) {
        
        if (score > self.shortGameHighscore)
            
            [self setShortGameHighscore:score];
        
    } else if ([category isEqualToString:kLeaderboardModeMedium]) {
        
        if (score > self.mediumGameHighscore)
            
            [self setMediumGameHighscore:score];
        
    } else if ([category isEqualToString:kLeaderboardModeSandbox]) {
        
        if (score > self.sandboxGameHighscore)
            
            [self setSandboxGameHighscore:score];
        
    }
}

- (void)reportScoreToGameCenter:(int)score withCategory:(NSString *)category
{
    if (self.isGameCenterDisabled)
        
        //cancel this action
        return;
    
    GKScore *levelScore = [[GKScore alloc] initWithCategory:category];
    
    levelScore.value = score;
    
    [levelScore reportScoreWithCompletionHandler:^(NSError *error) {
        
    }];
}

- (void)reportFuselCollectedCounterToWebsite
{
    NSURL *url = [NSURL URLWithString:kCounterReportUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *post = [NSString stringWithFormat:@"param=fuselscollected&value=%d", self.totalFuselsCollectedCounter];
    NSData *postData = [NSData dataWithBytes:[post UTF8String] length:[post length]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];

    NSURLConnection *download = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (download)
        
        self.receivedData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    self.receivedData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Response: %@", response);
    
    if ([response isEqualToString:@"ok"])
        
        self.totalFuselsCollectedCounter = 0;
}

- (int)totalFuselsCollected
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsFuselCollected];
}

- (void)setTotalFuselsCollected:(int)totalFuselsCollected
{
    [[NSUserDefaults standardUserDefaults] setInteger:totalFuselsCollected forKey:kUserDefaultsFuselCollected];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)totalFuselsCollectedCounter
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsFuselCollectedCounter];
}

- (void)setTotalFuselsCollectedCounter:(int)totalFuselsCollectedCounter
{
    [[NSUserDefaults standardUserDefaults] setInteger:totalFuselsCollectedCounter forKey:kUserDefaultsFuselCollectedCounter];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (totalFuselsCollectedCounter > 100)
        
        [self reportFuselCollectedCounterToWebsite];
}

- (int)addToTotalFuselsCollected:(int)count
{
    int totalFuselsCollected = self.totalFuselsCollected;
    totalFuselsCollected += count;
    
    [self setTotalFuselsCollected:totalFuselsCollected];
    
    //add it also to the counter
    self.totalFuselsCollectedCounter = self.totalFuselsCollectedCounter + count;
    
    [self reportScoreToGameCenter:totalFuselsCollected withCategory:kLeaderboardFuselCollected];
    
    return totalFuselsCollected;
}


- (int)totalFuselsMissed
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsFuselMissed];
}

- (void)setTotalFuselsMissed:(int)totalFuselsMissed
{
    [[NSUserDefaults standardUserDefaults] setInteger:totalFuselsMissed forKey:kUserDefaultsFuselMissed];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)addToTotalFuselsMissed:(int)count
{
    int totalFuselsMissed = self.totalFuselsMissed;
    totalFuselsMissed += count;
    
    [self setTotalFuselsMissed:totalFuselsMissed];
    
    [self reportScoreToGameCenter:totalFuselsMissed withCategory:kLeaderboardFuselMissed];
    
    return totalFuselsMissed;
}


- (int)totalSecondsPlayed
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsTotalSecondsPlayed];
}

- (void)setTotalSecondsPlayed:(int)totalSecondsPlayed
{
    [[NSUserDefaults standardUserDefaults] setInteger:totalSecondsPlayed forKey:kUserDefaultsTotalSecondsPlayed];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)addToTotalSecondsPlayed:(int)count
{
    
    int totalSecondsPlayed = self.totalSecondsPlayed;
    totalSecondsPlayed += count;
    
    [self setTotalSecondsPlayed:totalSecondsPlayed];
    
    return totalSecondsPlayed;
}


- (int)shortGameHighscore
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsHighscoreShortGame];
}

- (void)setShortGameHighscore:(int)shortGameHighscore
{
    [[NSUserDefaults standardUserDefaults] setInteger:shortGameHighscore forKey:kUserDefaultsHighscoreShortGame];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)reportShortGameScore:(int)score
{
    self.previousShortGameHighscore = self.shortGameHighscore;
    
    if (score > self.shortGameHighscore)   
    
        [self setShortGameHighscore:score];
    
    [self reportScoreToGameCenter:score withCategory:kLeaderboardModeShort];
    
}


- (int)mediumGameHighscore
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsHighscoreMediumGame];
}

- (void)setMediumGameHighscore:(int)mediumGameHighscore
{
    [[NSUserDefaults standardUserDefaults] setInteger:mediumGameHighscore forKey:kUserDefaultsHighscoreMediumGame];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)reportMediumGameScore:(int)score
{
    self.previousMediumGameHighscore = self.mediumGameHighscore;
    
    if (score > self.mediumGameHighscore)   
        
        [self setMediumGameHighscore:score];
    
    [self reportScoreToGameCenter:score withCategory:kLeaderboardModeMedium];
}


- (int)sandboxGameHighscore
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsHighscoreSandboxGame];
}

- (void)setSandboxGameHighscore:(int)sandboxGameHighscore
{
    [[NSUserDefaults standardUserDefaults] setInteger:sandboxGameHighscore forKey:kUserDefaultsHighscoreSandboxGame];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)reportSandboxGameScore:(int)score
{
    self.previousSandboxGameHighscoree = self.sandboxGameHighscore;
    
    if (score > self.sandboxGameHighscore)   
        
        [self setSandboxGameHighscore:score];
    
    [self reportScoreToGameCenter:score withCategory:kLeaderboardModeSandbox];
}


- (BOOL)isGameCenterDisabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsGameCenterDisabled];
}

- (BOOL)isLoggedInToGameCenter
{
    return [GKLocalPlayer localPlayer].isAuthenticated;
}

- (void)showGameCenterLoginNeededMessage
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GameCenterLoginNeeded", @"") message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
}

- (void)setIsGameCenterDisabled:(BOOL)isGameCenterDisabled
{
    [[NSUserDefaults standardUserDefaults] setInteger:isGameCenterDisabled forKey:kUserDefaultsGameCenterDisabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
