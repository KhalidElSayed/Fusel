//
//  FuselLevelView.h
//  Fusel
//
//  Created by Fränz Friederes on 08.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

#import "FuselLevel.h"

@protocol FuselLevelViewDataSource;

@interface FuselLevelView : UIView

@property (nonatomic, assign) id <FuselLevelViewDataSource> dataSource;

@property (nonatomic) CGPoint position;

@end

@protocol FuselLevelViewDataSource <NSObject>

- (NSArray *)levelViewWillDrawFuselsAroundViewport:(CGPoint)viewport;
- (float)levelViewTimeOver;
- (int)levelViewSecondsPlayed;
- (CGPoint)levelViewLastOpponentPosition;

@end
