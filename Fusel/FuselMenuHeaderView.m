//
//  FuselMenuHeaderView.m
//  Fusel
//
//  Created by Fränz Friederes on 15.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import "FuselMenuHeaderView.h"

@implementation FuselMenuHeaderView

@synthesize title = _title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //header background is transparent
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw heading
    CGContextSaveGState(context);
    
    CGContextRotateCTM(context, - 0.1);
    
    //colors
    [[UIColor colorWithWhite:0.1 alpha:1.0] setFill];
    [[UIColor colorWithWhite:0.1 alpha:1.0] setStroke];
    
    //draw texts
    [[self.title uppercaseString] drawAtPoint:CGPointMake(22, 60) withFont:[UIFont boldSystemFontOfSize:45.0]];
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 8.0);
    CGContextMoveToPoint(context, 22, 115);
    CGContextAddLineToPoint(context, 330, 115);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
    
}

@end
