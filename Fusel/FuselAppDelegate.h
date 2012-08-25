//
//  FuselAppDelegate.h
//  Fusel
//
//  Created by Fränz Friederes on 07.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FuselLevelViewController.h"
#import "FuselMainViewController.h"
#import "FuselStatistics.h"

@interface FuselAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UIImageView *defaultImageView;

- (void)hideDefaultImageView;

@end
