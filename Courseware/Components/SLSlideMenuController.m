//
//  SLSlideMenuController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/10/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "SLSlideMenuController.h"
#import "CWAppDelegate.h"

#import "CWCourseListingViewController.h"
#import "CWLibraryBrowserViewController.h"
#import "CWMessagingViewController.h"
#import "CWAccountManagerViewController.h"
#import "CWSettingsViewController.h"
#import "CWHelpViewController.h"

@interface SLSlideMenuController ()

@property (nonatomic, weak) UINavigationController *navController;

- (void)createCWMenuItems;

@end

@implementation SLSlideMenuController

- (void)dealloc
{
	_navController = nil;
}

- (id)init
{
	self = [super init];
	if (self) {
		_navController = [(CWAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
		[self createCWMenuItems];
	}
	return self;
}

- (void)createCWMenuItems
{
	NSArray *items = [NSArray arrayWithObjects:
					  [SLSlideMenuItem menuItemWithText:@"Courses"
											  lightIcon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/courses-light"]
											   darkIcon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/courses-dark.png"]]
					  , [SLSlideMenuItem menuItemWithText:@"Library"
												lightIcon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/library-light"]
												 darkIcon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/library-dark.png"]]
					  , [SLSlideMenuItem menuItemSeparator]
					  , [SLSlideMenuItem menuItemWithText:@"Messages"
												lightIcon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/messages-light"]
												 darkIcon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/messages-dark.png"]]
					  , [SLSlideMenuItem menuItemWithText:@"Account"
												lightIcon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/account-light"]
												 darkIcon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/account-dark.png"]]
					  , [SLSlideMenuItem menuItemWithText:@"Settings"
												lightIcon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/settings-light"]
												 darkIcon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/settings-dark.png"]]
					  , [SLSlideMenuItem menuItemWithText:@"Help"
												lightIcon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/help-light"]
												 darkIcon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/help-dark.png"]]
					  , nil];
	self.menuItems = items;
}

- (void)didPressMenuItemAtIndex:(NSUInteger)theIndex
{
	SLSlideMenuItem *selectedItem = [self.menuItems objectAtIndex:theIndex];
	
	if ([selectedItem.itemText isEqualToString:@"Courses"]) {
	
		CWCourseListingViewController *vc = [[CWCourseListingViewController alloc] initWithItem:[CWCourseListingViewController defaultSelectedItem]];
		[self pushViewController:vc];
		
	} else if ([selectedItem.itemText isEqualToString:@"Library"]) {
		
		CWLibraryBrowserViewController *vc = [[CWLibraryBrowserViewController alloc] init];
		[self pushViewController:vc];
		
	} else if ([selectedItem.itemText isEqualToString:@"Messages"]) {
		
		CWMessagingViewController *vc = [[CWMessagingViewController alloc] init];
		[self pushViewController:vc];
	
	} else if ([selectedItem.itemText isEqualToString:@"Account"]) {
		
		CWAccountManagerViewController *vc = [[CWAccountManagerViewController alloc] init];
		[self pushViewController:vc];
	
	} else if ([selectedItem.itemText isEqualToString:@"Settings"]) {
		
		CWSettingsViewController *vc = [[CWSettingsViewController alloc] init];
		[self pushViewController:vc];
	
	} else if ([selectedItem.itemText isEqualToString:@"Help"]) {
		
		CWHelpViewController *vc = [[CWHelpViewController alloc] init];
		[self pushViewController:vc];
	}
}

- (void)pushViewController:(UIViewController *)theVC
{
	// first, look for the vc on the navigation stack.	
	UIViewController *existingVC = nil;
	for (UIViewController *aVC in _navController.viewControllers) {
		if ([aVC class] == [theVC class]) {
			existingVC = aVC;
			break;
		}
	}
	if (existingVC) {
		[_navController popToViewController:existingVC animated:YES];
	}
	else {
		// else-wise, the vc is not on the stack yet so lets push a new instance out there.
		[_navController pushViewController:theVC animated:YES];
	}
}

@end

@implementation SLSlideMenuItem


+ (id)menuItemWithText:(NSString *)text lightIcon:(UIImage *)lightIcon darkIcon:(UIImage *)darkIcon
{
	SLSlideMenuItem *anItem = [[SLSlideMenuItem alloc] init];
	anItem.itemText = text;
	anItem.lightItemIcon = lightIcon;
	anItem.darkItemIcon = darkIcon;
	anItem.itemType = SLSlideMenuItemTypeTextAndIcon;
	return anItem;
}

+ (id)menuItemSeparator
{
	SLSlideMenuItem *anItem = [[SLSlideMenuItem alloc] init];
	anItem.itemType = SLSlideMenuItemTypeSeparator;
	return anItem;
}

@end