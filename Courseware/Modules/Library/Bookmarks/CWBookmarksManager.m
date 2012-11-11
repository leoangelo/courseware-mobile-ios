//
//  CWBookmarksManager.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/11/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWBookmarksManager.h"

@implementation CWBookmarksManager

+ (CWBookmarksManager *)sharedManager
{
	__strong static CWBookmarksManager *aManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		aManager = [[CWBookmarksManager alloc] init];
	});
	return aManager;
}

- (NSArray *)allBookmarks
{
	return [self fetchObjectsWithClass:[CWBookmark class] withPredicate:nil];
}

@end
