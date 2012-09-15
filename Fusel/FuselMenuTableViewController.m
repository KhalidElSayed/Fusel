//
//  FuselMenuTableViewController.m
//  Fusel
//
//  Created by Fränz Friederes on 15.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import "FuselMenuTableViewController.h"

@interface FuselMenuTableViewController ()

@end

@implementation FuselMenuTableViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        //background color
        UIView *backgroundView = [[UIView alloc] init];
        
        backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wood.png"]];
        
        self.tableView.backgroundView = backgroundView;
        
        //table header view
        self.tableView.tableHeaderView = [[FuselMenuHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 140.0)];
        
        //table footer view
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 30.0)];
        
    }
    return self;
}

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0) style:UITableViewStyleGrouped];
    
    self.tableView = tableView;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    if ([self.tableView.tableHeaderView isMemberOfClass:[FuselMenuHeaderView class]])
    
        [(FuselMenuHeaderView *)self.tableView.tableHeaderView setTitle:title];
}

@end
