//
//  FuselMenuCell.m
//  Fusel
//
//  Created by Fränz Friederes on 15.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import "FuselMenuCell.h"

@implementation FuselMenuCell

@synthesize originalFrame = _originalFrame, sideMargin = _sideMargin;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.originalFrame = CGRectNull;
        self.sideMargin = kDefaultFuselMenuCellSideMargin;
        
        UIColor *cellBackgroundColor = [UIColor colorWithWhite:1 alpha:0.55];
        UIColor *transparentColor = [UIColor colorWithWhite:1 alpha:0.0];
        
        //adapt background color
        self.backgroundColor = cellBackgroundColor;
        self.textLabel.backgroundColor = transparentColor;
        self.detailTextLabel.backgroundColor = transparentColor;
        self.accessoryView.backgroundColor = transparentColor;
        
        //add detail label color
        self.detailTextLabel.textColor = [UIColor colorWithHue:18/360.0 saturation:0 brightness:0.32 alpha:1.0];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (CGRectIsNull(self.originalFrame))
        
        //first frame is the original
        self.originalFrame = self.frame;
    
    //create new frame with original frame
    self.frame = CGRectMake(self.originalFrame.origin.x + self.sideMargin, self.originalFrame.origin.y, self.originalFrame.size.width - self.sideMargin * 2, self.originalFrame.size.height);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
