//
//  CWCourseReference.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseItem.h"

NSString * const kCourseItemId = @"id";
NSString * const kCourseItemTitle = @"title";
NSString * const kCourseItemDescription = @"description";

NSString * const kCourseItemLastDateRead = @"lastDateRead";
NSString * const kCourseItemFilePath = @"path";
NSString * const kCourseItemPageNumber = @"pageNumber";

@implementation CWCourseItem

- (void)dealloc
{
	_parent = nil;
	[_children release];
	[_data release];
	[super dealloc];
}
 
- (id)init
{
	self = [super init];
	if (self) {
		_data = [[NSMutableDictionary alloc] init];
		_children = [[NSMutableArray alloc] init];
		
		[_data setObject:[NSDate date] forKey:kCourseItemLastDateRead];
	}
	return self;
}

- (NSArray *)siblings
{
	if (_parent) {
		return [_parent children];
	}
	return nil;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"ITEM: %@; CHILDREN: %@", self.data, self.children];
}

@end
