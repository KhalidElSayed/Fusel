//
//  Fusel.m
//  Fusel
//
//  Created by Fränz Friederes on 07.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import "Fusel.h"

@interface Fusel ()

@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) UIColor *color;

@property (nonatomic) BOOL hasBeenDisplayed;

@property (nonatomic) BOOL isCollected;
@property (strong, nonatomic) NSString *collectorPlayerId;
@property (nonatomic) int collectTime;

@end

@implementation Fusel

@synthesize delegate = _delegate, position = _position, size = _size, fuselType = _fuselType, path = _path, color = _color, isCollected = _isCollected, collectorPlayerId = _collectorPlayerId, collectTime = _collectTime, hasBeenDisplayed = _hasBeenDisplayed, index = _index;


- (id)initWithPosition:(CGPoint)position andIndex:(int)index
{
    self = [super init];
    if (self) {
        
        self.position = position;
        self.size = CGSizeZero;
        
        //random type
        self.fuselType = kFuselTypeDefault;
        
        //not found at beginning
        self.isCollected = NO;
        self.hasBeenDisplayed = NO;
        
        [self generate];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        self.position = [coder decodeCGPointForKey:@"position"];
        self.size = [coder decodeCGSizeForKey:@"size"];
        self.index = [coder decodeIntForKey:@"index"];
        self.fuselType = [coder decodeIntForKey:@"fuselType"];
        
        self.path = (UIBezierPath *)[coder decodeObjectForKey:@"path"];
        self.color = (UIColor *)[coder decodeObjectForKey:@"color"];
        
        self.isCollected = [coder decodeBoolForKey:@"isCollected"];
        self.collectorPlayerId = (NSString *)[coder decodeObjectForKey:@"collectorPlayerId"];
        self.collectTime = [coder decodeIntForKey:@"collectTime"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeCGPoint:self.position forKey:@"position"];
    [coder encodeCGSize:self.size forKey:@"size"];
    [coder encodeInt:self.index forKey:@"index"];
    [coder encodeInt:self.fuselType forKey:@"fuselType"];
    
    [coder encodeObject:self.path forKey:@"path"];
    [coder encodeObject:self.color forKey:@"color"];
    
    [coder encodeBool:self.isCollected forKey:@"isCollected"];
    [coder encodeObject:self.collectorPlayerId forKey:@"collectorPlayerId"];
    [coder encodeInt:self.collectTime forKey:@"collectTime"];
    
}

- (void)generate
{   
    //generate size
    self.size = CGSizeMake(
                           ((float)random() / RAND_MAX) * (kFuselMaxSize - kFuselMinSize) + kFuselMinSize,
                           ((float)random() / RAND_MAX) * (kFuselMaxSize - kFuselMinSize) + kFuselMinSize);
    
    //create path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    if (self.fuselType == kFuselTypeDefault) {
        
        //generate path
        CGPoint centerPoint = CGPointMake(self.size.width / 2, self.size.height / 2);
        
        int armCount = (int)(((float)random() / RAND_MAX) * 7) + 1;
        
        //draw each "arm"
        for (int i = 0; i < armCount; i ++) {
            
            CGPoint endPoint = CGPointMake(((float)random() / RAND_MAX) * self.size.width,
                                           ((float)random() / RAND_MAX) * self.size.height);
            
            //mid point
            CGPoint midPoint = CGPointMake((endPoint.x + centerPoint.x) / 2, (endPoint.y + centerPoint.y) / 2);
            
            //add a "knick"
            midPoint = CGPointApplyAffineTransform(midPoint, CGAffineTransformMakeTranslation(((float)random() / RAND_MAX) * 10 - 5, (((float)random() / RAND_MAX) * 10 - 5)));
            
            //draw arm lines
            [path moveToPoint:centerPoint];
            [path addLineToPoint:midPoint];
            [path addLineToPoint:endPoint];
            
        }
        
        //add color
        self.color = [UIColor colorWithHue:((float)random() / RAND_MAX) saturation:0.35 brightness:(((float)random() / RAND_MAX) * 0.7 + 0.3) alpha:1.0];
        
    }
    
    self.path = path;
}

- (void)drawAtPoint:(CGPoint)sourcePoint
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //stroke aktual fusel
    CGContextSaveGState(context);
    
    [self.color setStroke];
    CGContextSetShadow(context, CGSizeMake(1.0, 1.0), 1.0);
    
    CGContextTranslateCTM(context, sourcePoint.x, sourcePoint.y);
    [self.path stroke];
    
    CGContextRestoreGState(context);
    
    //draw collected effect
    if (self.isCollected) {
        
        CGContextSaveGState(context);
        
        //red
        int colorHue = 14;
        
        //is multiplayer
        if (self.collectorPlayerId)
            
            if (![self.collectorPlayerId isEqualToString:[GKLocalPlayer localPlayer].playerID])
                
                colorHue = 203;

        [[UIColor colorWithHue:(colorHue / 360.0) saturation:0.91 brightness:0.61 alpha:0.7] setStroke];
            
        CGContextSetLineWidth(context, 6.0);
        CGContextStrokeEllipseInRect(context, CGRectMake(sourcePoint.x, sourcePoint.y, self.size.width, self.size.height));
        
        CGContextRestoreGState(context);
        
    }
    
    //has been displayed tolerance
    if (sourcePoint.x + self.size.width > kHasBeenDisplayedTolerance
        && sourcePoint.y + self.size.height > kHasBeenDisplayedTolerance
        && sourcePoint.x < [self.delegate fuselViewportSize].width - kHasBeenDisplayedTolerance
        && sourcePoint.y < [self.delegate fuselViewportSize].height - kHasBeenDisplayedTolerance)
        
        self.hasBeenDisplayed = YES;
}

- (int)score
{
    int score = 0;
    
    //this fusel has score when collected
    if (self.isCollected) {
    
        //base score
        if (self.fuselType == kFuselTypeDefault)
        
            score = kFuselScoreDefault;
        
        //when score positiv, apply bonuses
        if (score > 0) {
            
            //find out distance of viewport
            CGPoint viewport = [FuselLevel viewportOfPoint:self.position withViewportSize:[self.delegate fuselViewportSize]];
            
            int distance = sqrt(pow(viewport.x, 2) + pow(viewport.y, 2));
            
            //bonus limit
            if (distance > 10)
                
                distance = 10;
            
            if (distance < 0)
                
                distance = 0;
            
            //apply distance score
            score += distance * 5;
            
            //size bonus
            int sizePercent = (1 - (self.size.width * self.size.height - pow(kFuselMinSize, 2)) / pow(kFuselMaxSize - kFuselMinSize, 2));
            
            //apply size bonus
            score += sizePercent * 30;
            
        }
    
    }
    
    return score;
}

- (int)scoreForPlayerId:(NSString *)playerId
{
    if ([self.collectorPlayerId isEqualToString:playerId])
        
        return [self score];
    
    return 0;
}

- (void)applyFuselChanges:(Fusel *)fusel
{
    BOOL applyNewFusel = NO;
    
    if (!self.isCollected && fusel.isCollected)
        
        applyNewFusel = YES;
    
    else if (self.isCollected && fusel.isCollected)
        
        if (self.collectTime <= fusel.collectTime)
            
            applyNewFusel = YES;
    
    if (applyNewFusel) {
        
        //apply fusel changes
        self.isCollected        = fusel.isCollected;
        self.collectTime        = fusel.collectTime;
        self.collectorPlayerId  = fusel.collectorPlayerId;
        
    }
}

- (void)collect
{
    if (!self.isCollected) {
    
        self.isCollected = YES;
        self.hasBeenDisplayed = YES;
        
        self.collectTime = [self.delegate fuselTime];
        
    }
}

- (void)collectByPlayerId:(NSString *)playerId
{
    if (!self.isCollected) {
        
        [self collect];
        
        self.collectorPlayerId = playerId;
        
    }
}

@end
