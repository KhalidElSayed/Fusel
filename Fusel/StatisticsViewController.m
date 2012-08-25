//
//  StatisticsViewController.m
//  Fusel
//
//  Created by Fränz Friederes on 12.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController ()

@property (strong, nonatomic) UISwitch *gameCenterSwitch;

@end

@implementation StatisticsViewController

@synthesize gameCenterSwitch = _gameCenterSwitch;


- (id)init
{
    self = [super init];
    if (self) {
        
        self.gameCenterSwitch = [[UISwitch alloc] init];
        
        self.gameCenterSwitch.on = ![[FuselStatistics localStatistics] isGameCenterDisabled];
        
        [self.gameCenterSwitch addTarget:self action:@selector(gameCenterSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.title = NSLocalizedString(@"StatisticsTitle", @"");
        
    }
    return self;
}

- (IBAction)gameCenterSwitchValueChanged:(id)sender
{
    [[FuselStatistics localStatistics] setIsGameCenterDisabled:!self.gameCenterSwitch.on];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        
        return 3;
    
    else if (section == 1)
        
        return 3;
    
    else if (section == 2)
        
        return 2;
        
    else if (section == 3)
        
        return 1;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Default";
    
    if (indexPath.section == 2 && indexPath.row == 0)
        
        identifier = @"GameCenter";
    
    if (indexPath.section == 2 && indexPath.row == 0)
        
        identifier = @"GameCenterLeaderboards";
    
    else if (indexPath.section == 2 && indexPath.row == 1)
        
        identifier = @"Back";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        
        cell = [[FuselMenuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    
    if (indexPath.section == 0) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        if (indexPath.row == 0) {
        
            [cell.textLabel setText:NSLocalizedString(@"LevelModeShort", @"")];
            
            int highscore = [[FuselStatistics localStatistics] shortGameHighscore];
            
            [cell.detailTextLabel setText:[NSString stringWithFormat:NSLocalizedString(@"StatisticsPointCount", @""), highscore]];
            
        } else if (indexPath.row == 1) {
            
            [cell.textLabel setText:NSLocalizedString(@"LevelModeMedium", @"")];
            
            int highscore = [[FuselStatistics localStatistics] mediumGameHighscore];
            
            [cell.detailTextLabel setText:[NSString stringWithFormat:NSLocalizedString(@"StatisticsPointCount", @""), highscore]];
            
        } else if (indexPath.row == 2) {
            
            [cell.textLabel setText:NSLocalizedString(@"LevelModeSandbox", @"")];
            
            int highscore = [[FuselStatistics localStatistics] sandboxGameHighscore];
            
            [cell.detailTextLabel setText:[NSString stringWithFormat:NSLocalizedString(@"StatisticsPointCount", @""), highscore]];
            
        }
            
    } else if (indexPath.section == 1) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            
            [cell.textLabel setText:NSLocalizedString(@"StatisticsCollectedFusel", @"")];
            
            //get collected fusel count
            int totalFuselsCollected = [[FuselStatistics localStatistics] totalFuselsCollected];
            
            [cell.detailTextLabel setText:[NSString stringWithFormat:NSLocalizedString(@"StatisticsFuselCount", @""), totalFuselsCollected]];
            
        } else if (indexPath.row == 1) {
            
            [cell.textLabel setText:NSLocalizedString(@"StatisticsMissedFusel", @"")];
            
            //get missed fusel count
            int totalFuselsMissed = [[FuselStatistics localStatistics] totalFuselsMissed];
            
            [cell.detailTextLabel setText:[NSString stringWithFormat:NSLocalizedString(@"StatisticsFuselCount", @""), totalFuselsMissed]];
            
        } else if (indexPath.row == 2) {
            
            [cell.textLabel setText:NSLocalizedString(@"StatisticsTime", @"")];
            
            //get time
            int totalSecondsPlayed = [[FuselStatistics localStatistics] totalSecondsPlayed];
            
            float totalMinutesPlayed = totalSecondsPlayed / 60.0;
            float totalHoursPlayed = totalMinutesPlayed / 60.0;
            
            NSString *timePlayed = nil;
            
            if (totalSecondsPlayed == 0) {
                
                timePlayed = NSLocalizedString(@"StatisticsTimeNone", @"");
                
            } else if (totalMinutesPlayed < 2) {
                
                timePlayed = [NSString stringWithFormat:NSLocalizedString(@"StatisticsTimeSeconds", @""), totalSecondsPlayed];
                
            } else if (totalHoursPlayed < 1.5) {
                
                timePlayed = [NSString stringWithFormat:NSLocalizedString(@"StatisticsTimeMinutes", @""), totalMinutesPlayed];
                
            } else {
                
                timePlayed = [NSString stringWithFormat:NSLocalizedString(@"StatisticsTimeHours", @""), totalHoursPlayed];
                
            }
            
            [cell.detailTextLabel setText:timePlayed];
            
        }
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.textLabel setText:NSLocalizedString(@"StatisticsGameCenter", @"")];
            
            [cell setAccessoryView:self.gameCenterSwitch];
            
        } else if (indexPath.row == 1) {
            
            [cell.textLabel setText:NSLocalizedString(@"StatisticsLeaderboards", @"")];
            
        }
        
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            
            [cell.textLabel setText:NSLocalizedString(@"Back", @"")];
            
        }
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        
        if (indexPath.row == 1) {
            
            if ([[FuselStatistics localStatistics] isLoggedInToGameCenter]) {
                
                //show leaderboards
                GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
                
                if (leaderboardViewController != NULL) {
                    
                    leaderboardViewController.leaderboardDelegate = self;
                    
                    [self presentModalViewController:leaderboardViewController animated:YES];
                    
                }
            
            } else {
                
                [[FuselStatistics localStatistics] showGameCenterLoginNeededMessage];
                
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                
            }
                
        }
        
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
