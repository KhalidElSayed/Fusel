//
//  AboutViewController.m
//  Fusel
//
//  Created by Fränz Friederes on 13.07.12.
//  Copyright (c) 2012 the2f. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize textView = _textView;

- (id)init
{
    self = [super init];
    if (self) {
        
        self.title = NSLocalizedString(@"AboutTitle", @"");
        
        self.textView = [[UITextView alloc] init];
        
        self.textView.scrollEnabled = YES;
        self.textView.text = NSLocalizedString(@"AboutText", @"");
        self.textView.editable = NO;
        self.textView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        self.textView.font = [UIFont systemFontOfSize:15.0];
        self.textView.contentInset = UIEdgeInsetsMake(3.0, 0, 3.0, 0);
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (float)aboutTextHeight
{
    return 150.0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        
        return 2;
    
    else if (section == 1)
        
        return 4;
    
    else if (section == 2)
        
        return 1;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        //text view
        return [self aboutTextHeight];
        
    }
    
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Default";
    
    if (indexPath.section == 0 && indexPath.row == 1)
        
        identifier = @"TextView";
    
    else if (indexPath.section == 2 && indexPath.row == 0)
        
        identifier = @"Back";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        
        cell = [[FuselMenuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = NSLocalizedString(@"AboutTips", @"");
            
        } else if (indexPath.row == 1) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.contentView addSubview:self.textView];
            
            self.textView.frame = CGRectMake(2.0, 0.0, self.tableView.frame.size.width - 64.0, [self aboutTextHeight]);
                        
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.detailTextLabel.text = kAboutDeveloper;
            
            cell.textLabel.text = NSLocalizedString(@"AboutDeveloper", @"");
            
        } else if (indexPath.row == 1) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.detailTextLabel.text = NSLocalizedString(@"Luxembourg", @"");
            
            cell.textLabel.text = NSLocalizedString(@"AboutCountry", @"");
            
        } else if (indexPath.row == 2) {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.detailTextLabel.text = kAboutWebsite;
            
            cell.textLabel.text = NSLocalizedString(@"AboutWebsite", @"");
            
        } else if (indexPath.row == 3) {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.detailTextLabel.text = kAboutFacebook;
            
            cell.textLabel.text = NSLocalizedString(@"AboutFacebook", @"");
            
        }
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = NSLocalizedString(@"Back", @"");
            
        }
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAboutDeveloperUrl]];
            
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            
        } else if (indexPath.row == 2) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAboutWebsiteUrl]];
            
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            
        } else if (indexPath.row == 3) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAboutFacebookUrl]];
            
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }
}

@end
