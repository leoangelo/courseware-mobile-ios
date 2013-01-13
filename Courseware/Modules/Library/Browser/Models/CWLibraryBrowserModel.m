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

@property (nonatomic, strong) NSArray *baseMediaList;
@property (nonatomic, strong) NSArray *derivedMediaList;

- (NSArray *)convertedLibraryList:(NSArray *)theList;

@end

@implementation CWLibraryBrowserModel

- (void)rescanMedia
{
	[[CWLibraryMediaManager sharedManager] rescanMedia];
	self.baseMediaList = [self convertedLibraryList:[[CWLibraryMediaManager sharedManager] fetchObjectsWithClass:[CWMedia class] withPredicate:nil]];
	
	self.sortOptions = CWLibrarySortOptionsByDateRead;
}

// Returns the Media support versions of their CWMedia counterpart;
- (NSArray *)convertedLibraryList:(NSArray *)theList
{
	NSMutableArray *convertedArr = [NSMutableArray array];
	
	for (CWMedia *indexedMedium in theList) {
		
		// determine what support subclass will the media be in
		CWLibraryQuickLookSupport *qlSupport = [[CWLibraryQuickLookSupport alloc] initWithFilePath:indexedMedium.mediaPath dateRead:indexedMedium.lastDateOpened];
		[convertedArr addObject:qlSupport];
	}
	
	return convertedArr;
}

- (NSArray *)displayedMediaList
{
	return self.derivedMediaList;
}

- (void)setSearchFilter:(NSString *)searchFilter
{
	_searchFilter = nil;
	_searchFilter = searchFilter;
	
	if (!_searchFilter || [_searchFilter length] == 0) {
		self.derivedMediaList = self.baseMediaList;
		return;
	}
	
	NSMutableArray *arr = [NSMutableArray array];
	for (CWLibraryQuickLookSupport *aMedium in self.baseMediaList) {
		if ([aMedium.name rangeOfString:_searchFilter options:NSCaseInsensitiveSearch].location != NSNotFound) {
			[arr addObject:aMedium];
		}
	}
	self.derivedMediaList = arr;
}

- (void)setSortOptions:(CWLibrarySortOptions)sortOptions
{
	_sortOptions = sortOptions;
	NSString *sortKey = nil;
	BOOL isAscending = NO;
	
	switch (_sortOptions) {
		case CWLibrarySortOptionsByName: {
			sortKey = @"name";
			isAscending = YES;
			break;
		}
		case CWLibrarySortOptionsByType: {
			sortKey = @"type";
			isAscending = YES;
			break;
		}
		case CWLibrarySortOptionsByDateRead: {
			sortKey = @"lastDateRead";
			isAscending = NO;
			break;
		}
	}
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:isAscending];
	self.derivedMediaList = [self.baseMediaList sortedArrayUsingDescriptors:@[sorter]];
}

- (void)didOpenMedia:(CWLibraryMediaSupport *)theMedium
{
	// update the read date
	theMedium.lastDateRead = [NSDate date];
	
	// also update the core data version
	CWMedia *mediaForSupport = [[CWLibraryMediaManager sharedManager] mediaWithFileName:theMedium.filePath];
	if (mediaForSupport) {
		mediaForSupport.lastDateOpened = [NSDate date];
		[[CWLibraryMediaManager sharedManager] saveContext];
	}
}

@end
