//
//  FuselLevel.m
//  Fusel
//
//  Created by Fränz Friederes on 07.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import "FuselLevel.h"

@interface FuselLevel ()

@property (strong, nonatomic) NSMutableDictionary *viewports;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL isRunning;

@property (nonatomic) int seconds;
@property (nonatomic) int duration;

- (void)reportScores;

- (NSString *)descriptionOfViewport:(CGPoint)viewport;

- (CGSize)viewportSize;

@end

@implementation FuselLevel

@synthesize delegate = _delegate, viewports = _viewports, levelMode = _levelMode, seconds = _seconds, duration = _duration, timer = _timer, isRunning = _isRunning, lastPosition = _lastPosition;


- (id)init
{
    return [self initWithLevelMode:kLevelModeMedium];
}

- (id)initWithLevelMode:(FuselLevelMode)levelMode
{
    if (self = [super init]) {
        
        self.viewports = [[NSMutableDictionary alloc] init];
        
        self.levelMode = levelMode;
        
        self.isRunning = false;
        self.lastPosition = CGPointMake(0, 0);
        
        //countdown
        self.seconds = -3;
        
        //set game duration
        self.duration = 60 * 3;
        
        if (levelMode == kLevelModeMedium)
            
            self.duration = 60 + 30;
        
        else if (levelMode == kLevelModeShort)
            
            self.duration = 30;
        
        //start loop
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loop) userInfo:nil repeats:YES];
        
    }
    
    return self;
}


- (float)timeOver
{
    float timeOver = (float)self.seconds / self.duration;
    
    //check limits
    if (timeOver > 1) timeOver = 1;
    if (timeOver < 0) timeOver = 0;
    
    return timeOver;
}

- (void)loop
{
    //main loop
    if (self.isRunning) {
        
        //time runs
        self.seconds += 1;
        
        if (self.seconds > self.duration)
            
            [self stop];
        
        //repaint
        [self.delegate fuselLevelSetNeedsDisplay];
        
    }
}


- (int)score
{
    int score = 0;
    
    NSArray *fusels = [self collectedFusels];
    
    //calculate sum of fusel scores
    for (Fusel *fusel in fusels)
        
        score += [fusel score];
    
    return score;
}

- (int)collectedFuselCount
{
    return [[self collectedFusels] count];
}

- (int)displayedFuselCount
{
    NSArray *fusels = [self fusels];
    
    int displayedFuselCount = 0;
    
    for (Fusel *fusel in fusels)
        
        if ([fusel hasBeenDisplayed])
        
            displayedFuselCount ++;
    
    return displayedFuselCount;
}

- (void)reportScores
{
    BOOL isMultiplayer = NO;
    
    //fusels collected
    [[FuselStatistics localStatistics] addToTotalFuselsCollected:[self collectedFuselCount]];
    
    //total seconds played
    [[FuselStatistics localStatistics] addToTotalSecondsPlayed:self.duration];
    
    //report highscore to local statistics
    int score = [self score];
    
    if (!isMultiplayer) {
    
        //report these scores only in singleplayer
        if (self.levelMode == kLevelModeShort)
            
            [[FuselStatistics localStatistics] reportShortGameScore:score];
        
        else if (self.levelMode == kLevelModeMedium)
            
            [[FuselStatistics localStatistics] reportMediumGameScore:score];
        
        else if (self.levelMode == kLevelModeSandbox)
            
            [[FuselStatistics localStatistics] reportSandboxGameScore:score];
        
        [[FuselStatistics localStatistics] addToTotalFuselsMissed:([self displayedFuselCount] - [self collectedFuselCount])];
        
    }
}

+ (NSString *)scoreCategoryByLevelMode:(FuselLevelMode)levelMode
{
    if (levelMode == kLevelModeMedium)
        
        return kLeaderboardModeMedium;
    
    else if (levelMode == kLevelModeShort)
        
        return kLeaderboardModeShort;
    
    return kLeaderboardModeSandbox;
}


- (void)createFuselsAroundViewport:(CGPoint)viewport
{
    for (int x = - 2; x <= 2; x ++)
        
        for (int y = - 2; y <= 2; y ++) {
            
            CGPoint creationViewport = CGPointMake(viewport.x + x, viewport.y + y);
            
            if ([self.viewports objectForKey:[self descriptionOfViewport:creationViewport]] == nil)
            
                [self createFuselsAtViewport:creationViewport];
            
        }
}

- (NSArray *)createFuselsAtViewport:(CGPoint)viewport
{
    //find out factor
    //sandbox factor does not decrease how often fusels appear
    float factor = 1;
    
    if (self.levelMode == kLevelModeMedium)
        
        factor = 1.2;
    
    else if (self.levelMode == kLevelModeShort)
        
        factor = 1.4;
    
    NSMutableArray *viewportFusels = [[NSMutableArray alloc] init];
    
    //generate percentage
    int viewportDistanceToCenter = (int)sqrt(pow(viewport.x, 2) + pow(viewport.y, 2));
    float percent = 1 / pow(factor, viewportDistanceToCenter);
    
    //there is always a 2% chance to get a fusel
    if (percent < 0.02)
        
        percent = 0.02;
    
    //try 5 times to put a fusel
    int tries = 5;
    
    for (int i = 0; i < tries; i ++) {
        
        //percentages
        float rand = (float)arc4random() / ARC4RANDOM_MAX;
        
        if (rand <= percent) {
            
            //random position
            CGPoint position = CGPointMake(
                                           ((float)arc4random() / ARC4RANDOM_MAX) * self.viewportSize.width + self.viewportSize.width * viewport.x, 
                                           ((float)arc4random() / ARC4RANDOM_MAX) * self.viewportSize.height + self.viewportSize.height * viewport.y);
            
            //create fusel
            Fusel *fusel = [[Fusel alloc] initWithPosition:position andIndex:[viewportFusels count]];
            
            fusel.delegate = self;
            
            //add it to array
            [viewportFusels addObject:fusel];
            
        }
        
    }
    
    //save the fusels for this viewport
    [self.viewports setObject:[viewportFusels copy] forKey:[self descriptionOfViewport:viewport]];
    
    return [viewportFusels copy];
}

- (void)createEmptyViewport:(CGPoint)viewport
{
    [self.viewports setObject:[[NSArray alloc] init] forKey:[self descriptionOfViewport:viewport]];
}

- (NSArray *)collectedFusels
{
    NSMutableArray *fusels = [[NSMutableArray alloc] init];
    
    for (NSString *key in self.viewports) {
        
        NSArray *viewportFusels = [self.viewports objectForKey:key];
        
        for (Fusel *fusel in viewportFusels)
            
            if (fusel.isCollected)
                
                [fusels addObject:fusel];
        
    }
    
    return [fusels copy];
}

- (NSArray *)fuselsAtViewport:(CGPoint)viewport
{
    //check if viewport already exist
    NSArray *viewportEntry = [self.viewports objectForKey:[self descriptionOfViewport:viewport]];
    
    if (!viewportEntry) {
        
        //create fusels for this viewport
        return [self createFuselsAtViewport:viewport];
        
    }
        
    return [viewportEntry copy];
}

- (NSArray *)fuselsAroundViewport:(CGPoint)viewport
{
    NSMutableArray *fusels = [[NSMutableArray alloc] init];
    
    for (int x = - 1; x <= 1; x ++)
        
        for (int y = - 1; y <= 1; y ++)
            
            [fusels addObjectsFromArray:[self fuselsAtViewport:CGPointMake(viewport.x + x, viewport.y + y)]];
    
    return [fusels copy];
}

- (NSArray *)fuselsAtPosition:(CGPoint)point
{
    CGPoint viewport = [self viewportOfPoint:point];
    
    NSArray *fusels = [self fuselsAroundViewport:viewport];
    
    NSMutableArray *fuselsAtPosition = [[NSMutableArray alloc] init];
    
    for (Fusel *fusel in fusels) {
        
        //check if point is in rect (with tolerance)
        if (fusel.position.x - kTabTolerance < point.x
            && fusel.position.y - kTabTolerance < point.y
            && fusel.position.x + fusel.size.width + kTabTolerance > point.x
            && fusel.position.y + fusel.size.height + kTabTolerance > point.y)
            
            [fuselsAtPosition addObject:fusel];
        
    }
    
    return [fuselsAtPosition copy];
}

- (NSArray *)fusels
{
    NSMutableArray *fusels = [[NSMutableArray alloc] init];
    
    for (NSString *key in self.viewports) {
        
        NSArray *viewportFusels = [self.viewports objectForKey:key];
        
        for (Fusel *fusel in viewportFusels) [fusels addObject:fusel];
        
    }
    
    return [fusels copy];
}

- (void)setFusels:(NSArray *)fusels atViewport:(CGPoint)viewport
{
    [self.viewports setObject:fusels forKey:[self descriptionOfViewport:viewport]];
    
    [self.delegate fuselLevelSetNeedsDisplay];
}

- (void)applyFusels:(NSArray *)newFusels atViewport:(CGPoint)viewport
{
    NSArray *fusels = [self fuselsAtViewport:viewport];
    
    for (int i = 0; i < MIN([fusels count], [newFusels count]); i ++)
        
        [[fusels objectAtIndex:i] applyFuselChanges:[newFusels objectAtIndex:i]];
    
    //redraw
    [self.delegate fuselLevelSetNeedsDisplay];
}

- (void)collectFuselsAtPosition:(CGPoint)point
{
    NSArray *fusels = [self fuselsAtPosition:point];
    
    //mark fusel
    for (Fusel *fusel in fusels)
        
        //collect
        [self collectFusel:fusel];
    
    //repaint
    [self.delegate fuselLevelSetNeedsDisplay];
}

- (void)collectFusel:(Fusel *)fusel
{
    [fusel collect];
}


- (BOOL)isInteractionAllowed
{
    //interaction is allowed, when countdown is finished
    return self.seconds >= 0;
}

- (void)start
{
    self.isRunning = YES;
}

- (void)resume
{
    self.isRunning = YES;
}

- (void)pause
{
    self.isRunning = NO;
}

- (void)stop
{
    //stop the game
    self.isRunning = NO;
    
    [self.timer invalidate];
    self.timer = nil;
    
    //report scores to game center
    [self reportScores];
    
    //send game end to delegate
    [self.delegate fuselLevelGameDidEnd];
}


- (CGSize)viewportSize
{
    return [self.delegate fuselLevelViewportSize];
}

- (CGPoint)viewportOfPoint:(CGPoint)point
{
    return [FuselLevel viewportOfPoint:point withViewportSize:self.viewportSize];
}

+ (CGPoint)viewportOfPoint:(CGPoint)point withViewportSize:(CGSize)viewportSize
{
    CGPoint viewport = CGPointMake((int)(point.x / viewportSize.width), (int)(point.y / viewportSize.height));
    
    //adjustment for negative viewports
    if (point.x < 0) viewport.x -= 1;
    if (point.y < 0) viewport.y -= 1;
    
    return viewport;
}

- (CGSize)fuselViewportSize
{
    return [self viewportSize];
}

- (int)fuselTime
{
    return [[NSDate date] timeIntervalSince1970];
}

- (void)fuselGetsCollected:(Fusel *)fusel
{
    
}

- (NSString *)descriptionOfViewport:(CGPoint)viewport
{
    return [NSString stringWithFormat:@"%.0f;%.0f", viewport.x, viewport.y];
}

@end
