//
//  FuselLevelViewController.m
//  Fusel
//
//  Created by Fränz Friederes on 08.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import "FuselLevelViewController.h"

@interface FuselLevelViewController ()

@property (nonatomic) CGPoint beginTouchPoint;
@property (nonatomic) CGPoint beginTouchPosition;

@end

@implementation FuselLevelViewController

@synthesize delegate = _delegate, level = _level, beginTouchPoint = _beginTouchPoint, beginTouchPosition = _beginTouchPosition, fuselResultViewController = _fuselResultViewController;


- (id)init
{
    return [self initWithLevelMode:kLevelModeMedium];
}

- (id)initWithLevelMode:(FuselLevelMode)levelMode
{
    return [self initWithLevel:[[FuselLevel alloc] initWithLevelMode:levelMode]];
}

- (id)initWithLevel:(FuselLevel *)level
{
    self = [super init];
    if (self) {
        
        [self resetWithLevel:level];
        
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
    }
    return self;
}

- (void)resetWithLevel:(FuselLevel *)level
{
    [self loadView];
    
    self.level = level;
    level.delegate = self;
    
    self.levelView.position = CGPointMake(0, 0);
}

- (void)loadView
{
    //insert view
    FuselLevelView *levelView = [[FuselLevelView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    levelView.dataSource = self;
    
    //tab gesture recognizer
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    
    tapRecognizer.numberOfTapsRequired = 1;
    
    [levelView addGestureRecognizer:tapRecognizer];
    
    self.view = levelView;
}

- (FuselLevelView *)levelView
{
    return (FuselLevelView *)self.view;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //start the game
    [self.level start];
}

- (NSArray *)levelViewWillDrawFuselsAroundViewport:(CGPoint)viewport
{
    //ask model for fusels
    return [self.level fuselsAroundViewport:viewport];
}

- (float)levelViewTimeOver
{
    return [self.level timeOver];
}

- (int)levelViewSecondsPlayed
{
    return [self.level seconds];
}

- (void)fuselLevelSetNeedsDisplay
{
    //ask for repaint
    [self.view setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.beginTouchPoint = [[touches anyObject] locationInView:self.view];
    self.beginTouchPosition = [(FuselLevelView *)self.view position];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.level.isInteractionAllowed) {
    
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    
        //change position of view
        CGPoint position = CGPointMake(self.beginTouchPosition.x + (self.beginTouchPoint.x - touchPoint.x), self.beginTouchPosition.y + (self.beginTouchPoint.y - touchPoint.y));
    
        [self.levelView setPosition:position];
        [self.level setLastPosition:position];
        
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.beginTouchPoint = CGPointZero;
    self.beginTouchPosition = CGPointZero;
    
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    if (self.level.isInteractionAllowed) {
    
        CGPoint tabPoint = [tapRecognizer locationInView:self.view];
    
        CGPoint position = [(FuselLevelView *)self.view position];
    
        CGPoint tabPosition = CGPointMake(tabPoint.x + position.x, tabPoint.y + position.y);
    
        [self.level collectFuselsAtPosition:tabPosition];
        
    }
}

- (CGSize)fuselLevelViewportSize
{
    return self.view.frame.size;
}

- (void)fuselLevelGameDidEnd
{
    //create results
    self.fuselResultViewController = [[FuselResultViewController alloc] initWithLevel:self.level];
    
    self.fuselResultViewController.delegate = self;
    
    //show results view
    [self presentModalViewController:self.fuselResultViewController animated:YES];
}

- (void)fuselResultViewControllerDidFinish
{
    //switch to flip horizontal transition for flipping back
    self.fuselResultViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    //close and go back to menu
    [self.delegate fuselLevelViewControllerDidFinish];
}

- (void)fuselResultViewControllerDidReplay
{
    [self.delegate fuselLevelViewControllerReplayLevel:self.level];
}

- (CGPoint)levelViewLastOpponentPosition
{
    if ([self.level isMemberOfClass:[FuselMultiplayerLevel class]])
        
        return [(FuselMultiplayerLevel *)self.level lastOpponentPosition];
    
    return CGPointZero;
}

@end
