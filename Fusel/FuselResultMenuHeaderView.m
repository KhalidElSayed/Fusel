//
//  FuselResultMenuHeaderView.m
//  Fusel
//
//  Created by Fränz Friederes on 15.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import "FuselResultMenuHeaderView.h"

@implementation FuselResultMenuHeaderView

@synthesize delegate = _delegate, title = _title, isMultiplayer = _isMultiplayer;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //header background is transparent
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        
        self.isMultiplayer = NO;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw background
    [[UIColor colorWithPatternImage:[UIImage imageNamed:@"Wood.png"]] setFill];
    
    CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    
    //draw heading
    CGContextSaveGState(context);
    
    CGContextRotateCTM(context, -0.10);
    
    //colors
    [[UIColor colorWithWhite:0.1 alpha:1.0] setFill];
    [[UIColor colorWithWhite:0.1 alpha:1.0] setStroke];
    
    int score = [self.delegate resultViewWillShowScore];
    
    if (!self.isMultiplayer) {
        
        int fuselCount = [self.delegate resultViewWillShowFuselCount];
        int missedFusels = [self.delegate resultViewWillShowMissedFuselCount];
        int previousHighscore = [self.delegate resultViewWillShowPreviousHighscore];
        
        //draw texts
        [[self.title uppercaseString] drawAtPoint:CGPointMake(54, 62) withFont:[UIFont systemFontOfSize:30.0]];
        
        [[NSString stringWithFormat:@"%d", score] drawAtPoint:CGPointMake(54, 85) withFont:[UIFont boldSystemFontOfSize:80.0]];
        
        [[[NSString stringWithFormat:NSLocalizedString(@"ResultCollectedFusels", @""), fuselCount] uppercaseString] drawAtPoint:CGPointMake(54, 180) withFont:[UIFont systemFontOfSize:20.0]];
        [[[NSString stringWithFormat:NSLocalizedString(@"ResultMissedFusels", @""), missedFusels] uppercaseString] drawAtPoint:CGPointMake(54, 205) withFont:[UIFont systemFontOfSize:20.0]];
        [[[NSString stringWithFormat:NSLocalizedString(@"ResultPreHighscore", @""), previousHighscore] uppercaseString] drawAtPoint:CGPointMake(54, 230) withFont:[UIFont systemFontOfSize:20.0]];
        
        //side line
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 12.0);
        CGContextMoveToPoint(context, 40, -20);
        CGContextAddLineToPoint(context, 40, 250);
        CGContextStrokePath(context);
        
    } else {
        
        NSString *playerName = [self.delegate resultViewWillShowMultiplayerPlayerName];
        NSString *opponentName = [self.delegate resultViewWillShowMultiplayerOpponentName];
        int opponentScore = [self.delegate resultViewWillShowMultiplayerOpponentScore];
        
        //player
        [[UIColor colorWithHue:(14 / 360.0) saturation:0.91 brightness:0.61 alpha:1] setFill];
        
        [[playerName uppercaseString] drawAtPoint:CGPointMake(43, 30) withFont:[UIFont systemFontOfSize:20.0]];
        
        [[UIColor colorWithWhite:0.1 alpha:1.0] setFill];
        
        [[NSString stringWithFormat:@"%d", score] drawAtPoint:CGPointMake(43, 40) withFont:[UIFont boldSystemFontOfSize:80.0]];
        
        //top line
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 12.0);
        CGContextMoveToPoint(context, 30, -20);
        CGContextAddLineToPoint(context, 30, 114);
        CGContextStrokePath(context);
        
        //opponent
        [[UIColor colorWithHue:(203 / 360.0) saturation:0.91 brightness:0.61 alpha:1] setFill];
        
        [[opponentName uppercaseString] drawAtPoint:CGPointMake(20, 150) withFont:[UIFont systemFontOfSize:20.0]];
        
        [[UIColor colorWithWhite:0.1 alpha:1.0] setFill];
        
        [[NSString stringWithFormat:@"%d", opponentScore] drawAtPoint:CGPointMake(20, 160) withFont:[UIFont boldSystemFontOfSize:80.0]];
        
        //bottom line
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 12.0);
        CGContextMoveToPoint(context, 20, 250);
        CGContextAddLineToPoint(context, 400, 250);
        CGContextStrokePath(context);
        
    }
    
    CGContextRestoreGState(context);
    
}

@end
