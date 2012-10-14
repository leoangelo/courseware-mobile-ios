//
//  CWAppDelegate.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 8/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWAppDelegate.h"
#import "CWThemeHelper.h"

#import "CWUserLoginViewController.h"

@implementation CWAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[CWThemeHelper sharedHelper] initializeThemePresets];
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	UIViewController *rootVC = [[CWUserLoginViewController alloc] init];
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
	self.navigationController.navigationBarHidden = YES;
	self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Saves changes in the application's managed object context before the application terminates.
}

@end
