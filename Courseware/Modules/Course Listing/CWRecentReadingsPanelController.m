//
//  CWRecentReadingsPanelController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWRecentReadingsPanelController.h"
#import "CWCourseManager.h"

@interface CWRecentReadingsPanelController ()

@property (nonatomic, retain) NSArray *recentReads;

@end

@implementation CWRecentReadingsPanelController

- (void)dealloc
{
	[_recentReads release];
	[super dealloc];
}

- (id)init
{
	self = [super init];
	if (self) {
		[self rebuildLessonsIndex];
	}
	return self;
}

- (void)rebuildLessonsIndex
{
	NSArray *allLessons = [[CWCourseManager sharedManager] allLessons];
	NSSortDescriptor *sorterByDate = [[NSSortDescriptor alloc] initWithKey:@"lastDateRead" ascending:NO];
	allLessons = [allLessons sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorterByDate]];
	[sorterByDate release];
		
	NSInteger retSize = MIN([allLessons count], 5);
	allLessons = [allLessons subarrayWithRange:NSMakeRange(0, retSize)];
	
//	NSLog(@"lessons: %@", allLessons);
	
	self.recentReads = allLessons;
}

- (NSArray *)getRecentReads
{
	return self.recentReads;
}

@end
