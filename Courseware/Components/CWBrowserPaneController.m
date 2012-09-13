//
//  CWBrowserPaneController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWBrowserPaneController.h"
#import "CWCourseManager.h"
#import "CWCourseItem.h"

@interface CWBrowserPaneController ()

@property (nonatomic, retain) NSArray *itemsToDisplay;

@end

@implementation CWBrowserPaneController

- (void)dealloc
{
	[_itemsToDisplay release];
	[super dealloc];
}

- (id)init
{
	self = [super init];
	if (self) {
		[self rebuildItems];
	}
	return self;
}

- (void)rebuildItems
{
	CWCourseItem *activeItem = [[CWCourseManager sharedManager] activeCourseItem];
	if (!activeItem) {
		self.itemsToDisplay = [[CWCourseManager sharedManager] courseListing];
	}
	else {
		self.itemsToDisplay = activeItem.children;
	}
}

- (NSArray *)getItemsToDisplay
{
	return self.itemsToDisplay;
}

@end
