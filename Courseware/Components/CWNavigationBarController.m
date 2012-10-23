//
//  CWNavigationBarController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/19/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWNavigationBarController.h"
#import "CWAppDelegate.h"
#import "CWHomeViewController.h"
#import "CWLibraryBrowserViewController.h"

@interface CWNavigationBarController ()

@property (nonatomic, weak) UINavigationController *navController;

- (UIViewController *)getHomeViewController;

@end

@implementation CWNavigationBarController

- (void)dealloc
{
	_navController = nil;
}

- (id)init
{
	self = [super init];
	if (self) {
		_navController = [(CWAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
	}
	return self;
}

- (BOOL)shouldDisplayBackButton
{
	UIViewController *homeVC = [self getHomeViewController];
	if (homeVC) {
		NSInteger homeIndex = [self.navController.viewControllers indexOfObject:homeVC];
		return homeIndex < (self.navController.viewControllers.count - 1);
	}
	return NO;
}

- (BOOL)shouldDisplayHomeButton
{
	UIViewController *homeVC = [self getHomeViewController];
	if (homeVC) {
		NSInteger homeIndex = [self.navController.viewControllers indexOfObject:homeVC];
		return homeIndex < (self.navController.viewControllers.count - 1);
	}
	return NO;
}

- (BOOL)shouldDisplaySearchButton
{
	return [self.navController.topViewController class] == [CWLibraryBrowserViewController class];
}

- (BOOL)shouldDisplaySortButton
{
	return [self.navController.topViewController class] == [CWLibraryBrowserViewController class];
}

- (void)backButtonAction
{
	[_navController popViewControllerAnimated:YES];
}

- (void)homeButtonAction
{
	UIViewController *aHomeVC = [self getHomeViewController];
	if (aHomeVC) {
		[_navController popToViewController:aHomeVC animated:YES];
	}
	else {
		NSLog(@"No home view controller found.");
	}
}

- (UIViewController *)getHomeViewController
{
	for (UIViewController *aVC in self.navController.viewControllers) {
		if ([aVC isKindOfClass:[CWHomeViewController class]]) {
			return aVC;
		}
	}
	return nil;
}



@end
