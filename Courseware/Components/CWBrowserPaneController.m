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
	if (self.parentCourseItem.siblings && self.parentCourseItem.siblings.count > 1) {
		self.itemsToDisplay = [self.parentCourseItem siblings];
	}
	else if (self.parentCourseItem.parent && self.parentCourseItem.parent.siblings.count > 1) {
		self.itemsToDisplay = [self.parentCourseItem.parent siblings];
	}
	else {
		self.itemsToDisplay = [[CWCourseManager sharedManager] courseListing];
	}
}

- (void)setParentCourseItem:(CWCourseItem *)parentCourseItem
{
	_parentCourseItem = parentCourseItem;
	[self rebuildItems];
}

- (NSArray *)getItemsToDisplay
{
	return self.itemsToDisplay;
}

@end
