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

@property (nonatomic, assign) UINavigationController *navController;

- (void)createCWMenuItems;

@end

@implementation SLSlideMenuController

- (void)dealloc
{
	_navController = nil;
	[_menuItems release];
	[super dealloc];
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
					  [SLSlideMenuItem menuItemWithText:@"Courses" icon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/courses.png"]]
					  , [SLSlideMenuItem menuItemWithText:@"Library" icon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/library.png"]]
					  , [SLSlideMenuItem menuItemSeparator]
					  , [SLSlideMenuItem menuItemWithText:@"Messages" icon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/messages.png"]]
					  , [SLSlideMenuItem menuItemWithText:@"Account" icon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/account.png"]]
					  , [SLSlideMenuItem menuItemWithText:@"Settings" icon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/settings.png"]]
					  , [SLSlideMenuItem menuItemWithText:@"Help" icon:[UIImage imageNamed:@"Courseware.bundle/menu-icons/help.png"]]
					  , nil];
	self.menuItems = items;
}

- (void)didPressMenuItemAtIndex:(NSUInteger)theIndex
{
	SLSlideMenuItem *selectedItem = [self.menuItems objectAtIndex:theIndex];
	
	if ([selectedItem.itemText isEqualToString:@"Courses"]) {
	
		CWCourseListingViewController *vc = [[CWCourseListingViewController alloc] initWithItem:nil];
		[self pushViewController:vc];
		[vc release];
		
	} else if ([selectedItem.itemText isEqualToString:@"Library"]) {
		
		CWLibraryBrowserViewController *vc = [[CWLibraryBrowserViewController alloc] init];
		[self pushViewController:vc];
		[vc release];
		
	} else if ([selectedItem.itemText isEqualToString:@"Messages"]) {
		
		CWMessagingViewController *vc = [[CWMessagingViewController alloc] init];
		[self pushViewController:vc];
		[vc release];
	
	} else if ([selectedItem.itemText isEqualToString:@"Account"]) {
		
		CWAccountManagerViewController *vc = [[CWAccountManagerViewController alloc] init];
		[self pushViewController:vc];
		[vc release];
	
	} else if ([selectedItem.itemText isEqualToString:@"Settings"]) {
		
		CWSettingsViewController *vc = [[CWSettingsViewController alloc] init];
		[self pushViewController:vc];
		[vc release];
	
	} else if ([selectedItem.itemText isEqualToString:@"Help"]) {
		
		CWHelpViewController *vc = [[CWHelpViewController alloc] init];
		[self pushViewController:vc];
		[vc release];
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

- (void)dealloc
{
	[_itemIcon release];
	[_itemText release];
	[super dealloc];
}

+ (id)menuItemWithText:(NSString *)text icon:(UIImage *)icon
{
	SLSlideMenuItem *anItem = [[SLSlideMenuItem alloc] init];
	anItem.itemIcon = icon;
	anItem.itemText = text;
	anItem.itemType = SLSlideMenuItemTypeTextAndIcon;
	return [anItem autorelease];
}

+ (id)menuItemSeparator
{
	SLSlideMenuItem *anItem = [[SLSlideMenuItem alloc] init];
	anItem.itemType = SLSlideMenuItemTypeSeparator;
	return [anItem autorelease];
}

@end