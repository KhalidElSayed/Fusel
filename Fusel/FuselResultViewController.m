//
//  FuselResultViewController.m
//  Fusel
//
//  Created by Fränz Friederes on 08.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import "FuselResultViewController.h"

@interface FuselResultViewController ()

@property (nonatomic) BOOL isMultiplayer;

@property (nonatomic) int score;
@property (nonatomic) int previousHighscore;
@property (nonatomic) int fuselCount;
@property (nonatomic) int missedFuselCount;

@property (nonatomic) int opponentScore;

@property (nonatomic) int loopIncrement;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation FuselResultViewController

@synthesize delegate = _delegate, fuselLevel = _fuselLevel, score = _score, opponentScore = _opponentScore, previousHighscore = _previousHighscore, fuselCount = _fuselCount, missedFuselCount = _missedFuselCount, timer = _timer, loopIncrement = _loopIncrement, isMultiplayer = _isMultiplayer, loopIncrementMax = _loopIncrementMax;


- (id)initWithLevel:(FuselLevel *)fuselLevel
{
    self = [super init];
    if (self) {
        
        self.fuselLevel = fuselLevel;
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        //start loop
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(loop) userInfo:nil repeats:YES];
        
        //get level score
        self.score = [self.fuselLevel score];
        self.fuselCount = [self.fuselLevel collectedFuselCount];
        self.missedFuselCount = [self.fuselLevel displayedFuselCount] - self.fuselCount;
        
        self.loopIncrement = 0;
        self.loopIncrementMax = ((float)arc4random() / ARC4RANDOM_MAX * 50) + 100;
        
        //get previous highscore
        if (fuselLevel.levelMode == kLevelModeShort)
            
            self.previousHighscore = [[FuselStatistics localStatistics] previousShortGameHighscore];
        
        else if (fuselLevel.levelMode == kLevelModeMedium)
            
            self.previousHighscore = [[FuselStatistics localStatistics] previousMediumGameHighscore];
        
        else if (fuselLevel.levelMode == kLevelModeSandbox)
            
            self.previousHighscore = [[FuselStatistics localStatistics] previousSandboxGameHighscoree];
        
        else
            
            self.previousHighscore = 0;
        
        //table header view
        FuselResultMenuHeaderView *fuselResultMenuHeaderView = [[FuselResultMenuHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 275.0)];
        
        fuselResultMenuHeaderView.delegate = self;
        fuselResultMenuHeaderView.title = NSLocalizedString(@"ResultTitle", @"");
        
        self.tableView.tableHeaderView = fuselResultMenuHeaderView;
        
    }
    return self;
}

- (int)resultViewWillShowScore
{
    int score = (int)((float)self.loopIncrement / self.loopIncrementMax * (self.isMultiplayer ? MAX(self.score, self.opponentScore) : self.score));
    
    return MIN(score, self.score);
}

- (int)resultViewWillShowMultiplayerOpponentScore
{
    int opponentScore = (int)((float)self.loopIncrement / self.loopIncrementMax * MAX(self.score, self.opponentScore));
    
    return MIN(opponentScore, self.opponentScore);
}

- (NSString *)resultViewWillShowMultiplayerPlayerName
{
    return [GKLocalPlayer localPlayer].alias;
}

- (int)resultViewWillShowPreviousHighscore
{
    int previousHighscore = (int)((float)self.loopIncrement / self.loopIncrementMax * self.previousHighscore);
    
    return MIN(previousHighscore, self.previousHighscore);
}

- (int)resultViewWillShowFuselCount
{
    int fuselCount = (int)((float)self.loopIncrement / self.loopIncrementMax * self.fuselCount);
    
    return MIN(fuselCount, self.fuselCount);
}

- (int)resultViewWillShowMissedFuselCount
{
    int missedFuselCount = (int)((float)self.loopIncrement / self.loopIncrementMax * self.missedFuselCount);
    
    return MIN(missedFuselCount, self.missedFuselCount);
}

- (void)loop
{
    self.loopIncrement ++;
    
    if (self.loopIncrement >= self.loopIncrementMax) {
        
        [self.timer invalidate];
        self.timer = nil;
        
        [self countingDidFinish];
        
    }
    
    [self.tableView.tableHeaderView setNeedsDisplay];
}

- (void)countingDidFinish
{
    if (self.previousHighscore < self.score)
    
        [(FuselResultMenuHeaderView *)self.tableView.tableHeaderView setTitle:NSLocalizedString(@"ResultHighscoreTitle", @"")];
    
    [self.tableView.tableHeaderView setNeedsDisplay];
}

- (void)viewDidLoad
{
    //disable scrolling
    self.tableView.scrollEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        
        return 1;
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        
        cell = [[FuselMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.section == 0) {
    
        if (indexPath.row == 0) {
            
            [cell.textLabel setText:NSLocalizedString(@"ResultShare", @"")];
            
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            [cell.textLabel setText:NSLocalizedString(@"ResultReplay", @"")];
            
        } else if (indexPath.row == 1) {
            
            [cell.textLabel setText:NSLocalizedString(@"Back", @"")];
            
        }
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            [self shareResult];
            
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            [self.delegate fuselResultViewControllerDidReplay];
            
        } else if (indexPath.row == 1) {
            
            [self.delegate fuselResultViewControllerDidFinish];
            
        }
        
    }
}

- (void)shareResult
{
    //show action sheet
    UIActionSheet *shareActionSheet = [[UIActionSheet alloc] init];
    
    shareActionSheet.delegate = self;
    
    shareActionSheet.title = NSLocalizedString(@"ResultShare", @"");
    shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [shareActionSheet addButtonWithTitle:@"Twitter"];
    [shareActionSheet addButtonWithTitle:NSLocalizedString(@"Copy", @"")];
    [shareActionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
    shareActionSheet.cancelButtonIndex = 2;
    
    [shareActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        //share on twitter
        TWTweetComposeViewController *tweetComposeViewController = [[TWTweetComposeViewController alloc] init];
        
        [tweetComposeViewController setInitialText:[NSString stringWithFormat:NSLocalizedString(@"ResultTweetMessage", @""), self.score, self.fuselCount]];
        
        [self presentModalViewController:tweetComposeViewController animated:YES];
        
    } else if (buttonIndex == 1) {
        
        //copy score
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"ResultDefaultMessage", @""), self.score, self.fuselCount];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        pasteboard.string = message;
        
    }
}

@end
