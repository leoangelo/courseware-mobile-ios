//
//  CWLibraryBrowserModel.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWLibraryBrowserModel.h"
#import "CWLibraryMediaManager.h"
#import "CWMedia.h"

#import "CWLibraryQuickLookSupport.h"

@interface CWLibraryBrowserModel ()

- (NSArray *)convertedLibraryList:(NSArray *)theList;

@end

@implementation CWLibraryBrowserModel

- (void)rescanMedia
{
	[[CWLibraryMediaManager sharedManager] rescanMedia];
	self.mediaList = [self convertedLibraryList:[[CWLibraryMediaManager sharedManager] fetchObjectsWithClass:[CWMedia class] withPredicate:nil]];
}

// Returns the Media support versions of their CWMedia counterpart;
- (NSArray *)convertedLibraryList:(NSArray *)theList
{
	NSMutableArray *convertedArr = [NSMutableArray array];
	
	for (CWMedia *indexedMedium in theList) {
		
		// determine what support subclass will the media be in
		CWLibraryQuickLookSupport *qlSupport = [[CWLibraryQuickLookSupport alloc] initWithFilePath:indexedMedium.mediaPath];
		[convertedArr addObject:qlSupport];
	}
	
	return convertedArr;
}

@end
