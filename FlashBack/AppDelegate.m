//
//  AppDelegate.m
//  FlashBack
//
//  Created by Micah Gomez on 3/27/19.
//  Copyright © 2019 Micah Gomez. All rights reserved.
//

#import "AppDelegate.h"
#import "UIBackgroundStyle.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	setuid(0);
	setgid(0);
	
	// Override point for customization after application launch.
    [application _setBackgroundStyle:UIBackgroundStyleExtraDarkBlur];
    
    if (@available(iOS 13.0, *)) {
        UIBarAppearance *barAppearance = [[UIBarAppearance alloc] init];
        [barAppearance configureWithDefaultBackground];
        barAppearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterial];
        barAppearance.backgroundColor = [UIColor colorNamed:@"Cell Background Transparent"];
        
        [UINavigationBar appearance].standardAppearance = [[UINavigationBarAppearance alloc] initWithBarAppearance:barAppearance];
        [UINavigationBar appearance].scrollEdgeAppearance = [UINavigationBar appearance].standardAppearance;
        
        [UITabBar appearance].standardAppearance = [[UITabBarAppearance alloc] initWithBarAppearance:barAppearance];
    } else {
        UIColor *barBackground = [UIColor colorWithWhite:0 alpha:0.3];
        [UINavigationBar appearance].backgroundColor = barBackground;
        [UITabBar appearance].backgroundColor = barBackground;
    }
    
    _window.backgroundColor = [UIColor clearColor];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
