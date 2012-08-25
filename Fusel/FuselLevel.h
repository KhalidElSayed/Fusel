//
//  FuselLevel.h
//  Fusel
//
//  Created by Fränz Friederes on 07.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#import "Fusel.h"
#import "FuselStatistics.h"

#define ARC4RANDOM_MAX 0x100000000

#define kTabTolerance 20

typedef enum {
    kLevelModeSandbox,
    kLevelModeMedium,
    kLevelModeShort
} FuselLevelMode;


@protocol FuselDelegate;
@protocol FuselLevelDelegate;

@interface FuselLevel : NSObject <FuselDelegate>

@property (nonatomic, assign) id <FuselLevelDelegate> delegate;

@property (nonatomic) FuselLevelMode levelMode;

@property (nonatomic) CGPoint lastPosition;

- (id)initWithLevelMode:(FuselLevelMode)levelMode;

//time
- (float)timeOver;
- (int)seconds;

//scores
- (int)score;
- (int)collectedFuselCount;
- (int)displayedFuselCount;
+ (NSString *)scoreCategoryByLevelMode:(FuselLevelMode)levelMode;

//fusels
- (void)createFuselsAroundViewport:(CGPoint)viewport;
- (NSArray *)createFuselsAtViewport:(CGPoint)viewport;
- (void)createEmptyViewport:(CGPoint)viewport;

- (NSArray *)collectedFusels;

- (NSArray *)fuselsAtViewport:(CGPoint)viewport;
- (NSArray *)fuselsAroundViewport:(CGPoint)viewport;
- (NSArray *)fuselsAtPosition:(CGPoint)point;

- (void)setFusels:(NSArray *)fusels atViewport:(CGPoint)viewport;
- (void)applyFusels:(NSArray *)fusels atViewport:(CGPoint)viewport;
- (NSArray *)fusels;

- (void)collectFusel:(Fusel *)fusel;
- (void)collectFuselsAtPosition:(CGPoint)point;

//game status
- (BOOL)isInteractionAllowed;
- (BOOL)isRunning;

- (void)start;
- (void)resume;
- (void)pause;
- (void)stop;

//viewport
- (CGPoint)viewportOfPoint:(CGPoint)point;
+ (CGPoint)viewportOfPoint:(CGPoint)point withViewportSize:(CGSize)viewportSize;

@end

@protocol FuselLevelDelegate <NSObject>

- (void)fuselLevelSetNeedsDisplay;

- (void)fuselLevelGameDidEnd;

- (CGSize)fuselLevelViewportSize;

@end

#import "FuselMultiplayerLevel.h"
