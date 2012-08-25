//
//  AboutViewController.h
//  Fusel
//
//  Created by Fränz Friederes on 13.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FuselMenuTableViewController.h"

#define kAboutDeveloper     @"Fränz Friederes"
#define kAboutDeveloperUrl  @"http://the2f.com/"
#define kAboutWebsite       @"fusel.lu"
#define kAboutWebsiteUrl    @"http://www.fusel.lu/"
#define kAboutFacebook      @"fuselgame"
#define kAboutFacebookUrl   @"http://facebook.com/fuselgame"

@interface AboutViewController : FuselMenuTableViewController

@property (strong, nonatomic) UITextView *textView;

- (float)aboutTextHeight;

@end

