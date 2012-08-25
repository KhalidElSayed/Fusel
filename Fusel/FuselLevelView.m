//
//  FuselLevelView.m
//  Fusel
//
//  Created by Fränz Friederes on 08.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import "FuselLevelView.h"

@interface FuselLevelView ()

@property (nonatomic) BOOL movableDisplayed;

@property (strong, nonatomic) UIImage *textureImage;
@property (nonatomic) CGSize textureImageSize;

@property (strong, nonatomic) UIImage *movableImage;

@end

@implementation FuselLevelView

@synthesize dataSource = _dataSource, position = _position, movableDisplayed = _movableDisplayed, textureImage = _textureImage, movableImage = _movableImage, textureImageSize = _textureImageSize;


- (id)init
{
    return [self initWithFrame:CGRectNull];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.position = CGPointMake(0, 0);
        
        if ([UIScreen mainScreen].scale == 2.0) {
            
            self.textureImage = [UIImage imageNamed:@"Texture@2x.png"];
            self.textureImageSize = CGSizeMake(self.textureImage.size.width / 2, self.textureImage.size.height / 2);
            
        } else {
            
            self.textureImage = [UIImage imageNamed:@"Texture.png"];
            self.textureImageSize = CGSizeMake(self.textureImage.size.width, self.textureImage.size.height);
            
        }
        
        self.movableImage = [UIImage imageNamed:@"Movable.png"];
        self.movableDisplayed = YES;
        
    }
    return self;
}

- (void)setPosition:(CGPoint)position
{
    _position = position;
    
    //redraw after position change
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw texture
    CGPoint offset = CGPointMake(- (int)self.position.x % (int)self.textureImageSize.width, - (int)self.position.y % (int)self.textureImageSize.height);
    
    //go through each area to draw the texture
    // image on the right place
    int x = 0;
    int y = offset.y;
    
    if (offset.y > 0)
        
        y -= self.textureImageSize.height;
    
    while (y < self.frame.size.height) {
        
        x = offset.x;
        
        if (offset.x > 0)
            
            x -= self.textureImageSize.width;
        
        while (x < self.frame.size.width) {
            
            CGContextDrawImage(context, CGRectMake(x, y, self.textureImageSize.width, self.textureImageSize.height), [self.textureImage CGImage]);
            
            x += self.textureImageSize.width;
            
        }
        
        y += self.textureImageSize.height;
        
    }
    
    //draw fusels
    CGPoint viewport = [FuselLevel viewportOfPoint:self.position withViewportSize:self.frame.size];
    
    NSArray *fusels = [self.dataSource levelViewWillDrawFuselsAroundViewport:viewport];
    
    for (Fusel *fusel in fusels) {
        
        CGPoint screenPoint = CGPointMake(fusel.position.x - self.position.x, fusel.position.y - self.position.y);
        
        //check if fusel is on screen (performance saving)
        if (screenPoint.x + fusel.size.width > 0
            && screenPoint.y + fusel.size.height > 0
            && screenPoint.x < self.frame.size.width
            && screenPoint.y < self.frame.size.height)
        
            //draw single fusel
            [fusel drawAtPoint:screenPoint];
        
    }
    
    //check if countdown
    int secondsPlayed = [self.dataSource levelViewSecondsPlayed];
    
    if (secondsPlayed < 0) {
        
        //countdown
        [[UIColor colorWithWhite:0.1 alpha:0.7] setFill];
        
        NSString *countdownString = @"?";
        
        if (- secondsPlayed == 1)
            
            countdownString = @"!";
        
        [countdownString drawInRect:CGRectMake(0, 95, self.frame.size.width, 250) withFont:[UIFont boldSystemFontOfSize:250] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
        
    } else {
    
        //draw time over display
        float timeOver = [self.dataSource levelViewTimeOver];
    
        CGRect timeOverRect = CGRectMake(10.0, 10.0, (self.frame.size.width - 20.0) * timeOver, 5.0);
        
        [[UIColor colorWithWhite:0 alpha:timeOver * 0.8 + 0.2] setFill];
    
        CGContextFillRect(context, timeOverRect);
        
    }
    
    //draw arrows
    float distanceToCenter = sqrt(pow(self.position.x, 2) + pow(self.position.y, 2));
    
    if (distanceToCenter <= 100 && self.movableDisplayed) {
        
        float alpha = (1 - distanceToCenter / 100.0) * 0.75;
        
        CGContextSetAlpha(context, alpha);
        CGContextDrawImage(context, self.frame, [self.movableImage CGImage]);
        
    } else
        
        self.movableDisplayed = NO;
    
}

@end
