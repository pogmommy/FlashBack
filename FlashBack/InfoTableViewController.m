//
//  InfoTableViewController.m
//  FlashBack
//
//  Created by 23 Aaron on 1/15/20.
//  Copyright © 2020 Micah Gomez. All rights reserved.
//

#import "InfoTableViewController.h"
#import "UIBackgroundStyle.h"
#import "globalVars.h"

@interface InfoTableViewController ()

@end


@implementation InfoTableViewController

- (IBAction)tweaksSwitch:(id)sender {

    tweaksEnabled = [sender isOn];
    stringTweaksEnabled = tweaksEnabled == YES ? @"YES" : @"NO";
    NSLog(@"%@", stringTweaksEnabled);
}

- (IBAction)iconsSwitch:(id)sender {
    
    iconsEnabled = [sender isOn];
    stringIconsEnabled = iconsEnabled == YES ? @"YES" : @"NO";
    NSLog(@"%@", stringIconsEnabled);
}

- (IBAction)wallpaperSwitch:(id)sender {
    
	wallpaperEnabled = [sender isOn];
    stringWallpaperEnabled = wallpaperEnabled == YES ? @"YES" : @"NO";
    NSLog(@"%@", stringWallpaperEnabled);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.micahImageView sd_setImageWithURL:[NSURL URLWithString:@"https://github.com/mpg13.png"]
    placeholderImage:nil];

   [self.aaronImageView sd_setImageWithURL:[NSURL URLWithString:@"https://github.com/23aaron.png"]
    placeholderImage:nil];
    
}

+ (NSURL *)openTwitterProfile:(NSString *)userName {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///user_profile/%@", userName]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific://"]]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"twitterrific:///profile?screen_name=%@", userName]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings://"]]) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"tweetings:///user?screen_name=%@", userName]];
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://mobile.twitter.com/%@", userName]];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.textLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)micahTwitterProfile{
    [[UIApplication sharedApplication] openURL:[InfoTableViewController openTwitterProfile:@"MicahPGomez"]];
}
    
-(void)aaronTwitterProfile{
    [[UIApplication sharedApplication] openURL:[InfoTableViewController openTwitterProfile:@"23Aaron_"]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self micahTwitterProfile];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        [self aaronTwitterProfile];
    }
}
@end
