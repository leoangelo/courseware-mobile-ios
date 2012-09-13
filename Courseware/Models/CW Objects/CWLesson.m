//
//  CWLesson.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWLesson.h"
#import "CWCourseManager.h"

@implementation CWLesson

- (void)dealloc
{
	[_lastDateRead release];
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Lesson title: %@", self.title];
}

@end
