//
//  FuselMainViewController.m
//  Fusel
//
//  Created by Fränz Friederes on 08.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import "FuselMainViewController.h"

@interface FuselMainViewController ()

@end

@implementation FuselMainViewController

@synthesize fuselLevelViewController = _fuselLevelViewController, levelMode = _levelMode;


- (id)init
{
    self = [super init];
    if (self) {
        
        self.title = NSLocalizedString(@"Fusel", @"");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //disable scrolling
    self.tableView.scrollEnabled = NO;
    
    //add invite handler
    [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) {
        
        //stop game to process the invite
        [self dismissModalViewControllerAnimated:NO];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        if (acceptedInvite) {
            
            GKMatchmakerViewController *matchmakerViewController = [[GKMatchmakerViewController alloc] initWithInvite:acceptedInvite];
            
            matchmakerViewController.matchmakerDelegate = self;
            
            [self presentModalViewController:matchmakerViewController animated:YES];
            
        } else if (playersToInvite) {
            
            GKMatchRequest *matchRequest = [[GKMatchRequest alloc] init];
            matchRequest.minPlayers = 2;
            matchRequest.maxPlayers = 2;
            matchRequest.playersToInvite = playersToInvite;
            
            GKMatchmakerViewController *matchmakerViewController = [[GKMatchmakerViewController alloc] initWithMatchRequest:matchRequest];
            
            matchmakerViewController.matchmakerDelegate = self;
            
            [self presentModalViewController:matchmakerViewController animated:YES];
            
        }
        
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    
        return 3;
    
    else if (section == 1)
        
        return 1;
    
    else if (section == 2)
        
        return 1;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        
        cell = [[FuselMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            [cell.textLabel setText:NSLocalizedString(@"LevelModeShort", @"")];
            
        } else if (indexPath.row == 1) {
            
            [cell.textLabel setText:NSLocalizedString(@"LevelModeMedium", @"")];
            
        } else if (indexPath.row == 2) {
            
            [cell.textLabel setText:NSLocalizedString(@"LevelModeSandbox", @"")];
            
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            [cell.textLabel setText:NSLocalizedString(@"StatisticsTitle", @"")];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            [cell.textLabel setText:NSLocalizedString(@"AboutTitle", @"")];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            [self startLevel:kLevelModeShort];
            
        } else if (indexPath.row == 1) {
            
            [self startLevel:kLevelModeMedium];
            
        } else if (indexPath.row == 2) {
            
            [self startLevel:kLevelModeSandbox];
            
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            //show statistics
            StatisticsViewController *statisticsViewController = [[StatisticsViewController alloc] init];
            
            [self.navigationController pushViewController:statisticsViewController animated:YES];
            
        }
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            //about view controller
            AboutViewController *aboutViewController = [[AboutViewController alloc] init];
            
            [self.navigationController pushViewController:aboutViewController animated:YES];
            
        }
        
    }
}

- (void)startLevel:(FuselLevelMode)levelMode
{
    //create level
    FuselLevel *fuselLevel = [[FuselLevel alloc] initWithLevelMode:levelMode];
        
    //starts a new game
    self.fuselLevelViewController = [[FuselLevelViewController alloc] initWithLevel:fuselLevel];
        
    self.fuselLevelViewController.delegate = self;
        
    [self.navigationController presentModalViewController:self.fuselLevelViewController animated:YES];
}

- (void)startMultiplayerLevel:(FuselLevelMode)levelMode
{
    //prepair for multiplayer
    // find peer
    
    //request matchmaking
    GKMatchRequest *matchRequest = [[GKMatchRequest alloc] init];
    
    matchRequest.minPlayers = 2;
    matchRequest.maxPlayers = 2;
    
    //cache level mode
    self.levelMode = levelMode;
    
    //show matchmaking view
    GKMatchmakerViewController *matchmakerViewController = [[GKMatchmakerViewController alloc] initWithMatchRequest:matchRequest];
    
    matchmakerViewController.matchmakerDelegate = self;
    
    [self presentViewController:matchmakerViewController animated:YES completion:^(void) {
        
        //deselect row
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
        
    }];
}

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)fuselLevelViewControllerDidFinish
{
    //deselect menu
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    
    [self dismissModalViewControllerAnimated:YES];
    
    self.fuselLevelViewController = nil;
}

- (void)fuselLevelViewControllerReplayLevel:(FuselLevel *)level
{
    FuselLevel *fuselLevel = [[FuselLevel alloc] initWithLevelMode:level.levelMode];
    
    [self.fuselLevelViewController resetWithLevel:fuselLevel];
    
    [self.fuselLevelViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.fuselLevelViewController dismissModalViewControllerAnimated:YES];
}

@end
