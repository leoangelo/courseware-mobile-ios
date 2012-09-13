//
//  SLSlideMenuController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/10/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "SLSlideMenuController.h"

@interface SLSlideMenuController ()

- (void)createCWMenuItems;

@end

@implementation SLSlideMenuController

- (void)dealloc
{
	[_menuItems release];
	[super dealloc];
}

- (id)init
{
	self = [super init];
	if (self) {
		[self createCWMenuItems];
	}
	return self;
}

- (void)createCWMenuItems
{
	NSArray *items = [NSArray arrayWithObjects:
					  [SLSlideMenuItem menuItemWithText:@"Courses" icon:nil]
					  , [SLSlideMenuItem menuItemWithText:@"Library" icon:nil]
					  , [SLSlideMenuItem menuItemSeparator]
					  , [SLSlideMenuItem menuItemWithText:@"Messages" icon:nil]
					  , [SLSlideMenuItem menuItemWithText:@"Account" icon:nil]
					  , [SLSlideMenuItem menuItemWithText:@"Settings" icon:nil]
					  , [SLSlideMenuItem menuItemWithText:@"Help" icon:nil]
					  , nil];
	self.menuItems = items;
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