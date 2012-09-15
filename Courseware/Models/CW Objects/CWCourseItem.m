//
//  CWCourseReference.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseItem.h"

@implementation CWCourseItem

- (void)dealloc
{
	[_referenceId release];
	[_title release];
	[_referenceDescription release];
	[_objectives release];
	_parent = nil;
	[_children release];
	[super dealloc];
}

- (NSArray *)siblings
{
	if (_parent) {
		return [_parent children];
	}
	return nil;
}

@end
