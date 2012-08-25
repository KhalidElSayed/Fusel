//
//  Fusel.h
//  Fusel
//
//  Created by Fränz Friederes on 07.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHasBeenDisplayedTolerance 50

#define kFuselMinSize       30
#define kFuselMaxSize       80

#define kFuselScoreDefault  13

typedef enum {
    kFuselTypeDefault
} FuselType;

@protocol FuselDelegate;

@interface Fusel : NSObject

@property (nonatomic, assign) id <FuselDelegate> delegate;

@property (nonatomic) CGPoint position;
@property (nonatomic) CGSize size;

@property (nonatomic) int index;

@property (nonatomic) FuselType fuselType;

- (id)initWithPosition:(CGPoint)position andIndex:(int)index;
- (void)generate;

- (void)drawAtPoint:(CGPoint)point;

- (int)score;
- (BOOL)hasBeenDisplayed;
- (int)scoreForPlayerId:(NSString *)playerId;

- (BOOL)isCollected;
- (int)collectTime;
- (NSString *)collectorPlayerId;

- (void)collect;
- (void)collectByPlayerId:(NSString *)playerId;

- (void)applyFuselChanges:(Fusel *)fusel;

@end

@protocol FuselDelegate <NSObject>

- (CGSize)fuselViewportSize;
- (int)fuselTime;

@end

//import fusel level at the end
// to avoid a cyclic dependency
#import "FuselLevel.h"
