//
//  CWCourseReference.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseItem.h"
#import "CWUtilities.h"
#import "NSArray+SLUtilities.h"

NSString * const kCourseItemId = @"id";
NSString * const kCourseItemTitle = @"title";
NSString * const kCourseItemDescription = @"description";

NSString * const kCourseItemDirectoryName = @"directory";
NSString * const kCourseItemLastDateRead = @"lastDateRead";
NSString * const kCourseItemFileName = @"filename";
NSString * const kCourseItemPageNumber = @"pageNumber";

@implementation CWCourseItem

- (void)dealloc
{
	_parent = nil;
}
 
- (id)init
{
	self = [super init];
	if (self) {
		_data = [[NSMutableDictionary alloc] init];
		_children = [[NSMutableArray alloc] init];
		_attachments = [[NSMutableArray alloc] init];
		
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

- (NSInteger)depth
{
	NSInteger currentDepth = 0;
	for (CWCourseItem *parentNode = self.parent; parentNode != nil; parentNode = parentNode.parent) {
		currentDepth++;
	}
	return currentDepth;
}

- (CWCourseItem *)rootItem
{
	CWCourseItem *root = nil;
	for (CWCourseItem *parentNode = self.parent; parentNode != nil; parentNode = parentNode.parent) {
		root = parentNode;
	}
	return root;
}

- (BOOL)hasFileContent
{
	NSString *filename = @"";
	for (CWCourseItem *currentNode = self; currentNode != nil; currentNode = currentNode.parent) {
		if ([currentNode.data objectForKey:kCourseItemFileName]) {
			filename = [currentNode.data objectForKey:kCourseItemFileName];
		}
	}
	return [filename length] > 0;
}

- (NSString *)fullFilePath
{
	NSString *fullPath = [[CWUtilities documentRootPath] stringByAppendingPathComponent:@"courses"];
	NSString *filename = @"";
	NSMutableArray *directories = [NSMutableArray array];
	for (CWCourseItem *currentNode = self; currentNode != nil; currentNode = currentNode.parent) {
		if ([currentNode.data objectForKey:kCourseItemFileName]) {
			filename = [currentNode.data objectForKey:kCourseItemFileName];
		}
		if ([currentNode.data objectForKey:kCourseItemDirectoryName]) {
			[directories addObject:[currentNode.data objectForKey:kCourseItemDirectoryName]];
		}
	}
	// reverse the array to get the directory hierarchy from the root
	NSEnumerator *enumerator = [directories reverseObjectEnumerator];
    for (id element in enumerator) {
		fullPath = [fullPath stringByAppendingPathComponent:element];
    }
	// finally, append the filename
	fullPath = [fullPath stringByAppendingPathComponent:filename];
	
	return fullPath;
}

- (NSArray *)getAllAttachments
{
	// the media metadata is usually along the filename attribute. this means we could point the course item holding the media as the item holding the filename as well.
	// move upwards the tree until we find the node holding the filename
	for (CWCourseItem *currentItem = self; currentItem != nil; currentItem = currentItem.parent) {
		if ([currentItem.data objectForKey:kCourseItemFileName]) {
			return currentItem.attachments;
		}
	}
	return nil;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"ITEM: %@; MEDIA: %@; CHILDREN: %@", self.data, self.attachments, self.children];
}

@end
