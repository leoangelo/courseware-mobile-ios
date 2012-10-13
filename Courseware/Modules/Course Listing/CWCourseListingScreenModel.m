//
//  CWCourseListingScreenModel.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/15/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseListingScreenModel.h"
#import "CWCourseItem.h"

@interface CWCourseListingScreenModel ()

@property (nonatomic, strong) NSArray *itemList;

- (void)rebuildItemList;
- (void)addItem:(CWCourseItem *)anItem toList:(NSMutableArray *)aList;

@end

@implementation CWCourseListingScreenModel

- (void)dealloc
{
	_selectedCourseItem = nil;
}

- (void)setSelectedCourseItem:(CWCourseItem *)selectedCourseItem
{
	_selectedCourseItem = selectedCourseItem;
	[self rebuildItemList];
}

- (NSArray *)getItemList
{
	return self.itemList;
}

- (void)rebuildItemList
{
	if (!_selectedCourseItem) return;
	NSMutableArray *items = [[NSMutableArray alloc] init];

	if (_selectedCourseItem.rootItem) {
		[self addItem:_selectedCourseItem.rootItem toList:items];
	}
	else { // Might be that the course item is the root itself.
		[self addItem:_selectedCourseItem toList:items];
	}

	self.itemList = items;
}

- (void)addItem:(CWCourseItem *)anItem toList:(NSMutableArray *)aList
{
	[aList addObject:anItem];
	for (CWCourseItem *itemChild in anItem.children) {
		[self addItem:itemChild toList:aList];
	}
}

@end
