//
//  CWBookmarksModel.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/11/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWBookmarksModel.h"
#import "CWBookmarksManager.h"
#import "CWAppDelegate.h"
#import "CWCourseReaderViewController.h"

@interface CWBookmarksModel ()

@property (nonatomic, strong) NSArray *allBookmarks;

- (BOOL)bookmarkAlreadyExistsFilePath:(NSString *)filePath pageNumber:(NSInteger)pageNumber;

@end

@implementation CWBookmarksModel

- (void)refreshBookmarkList
{
	NSArray *allBookmarks = [[CWBookmarksManager sharedManager] allBookmarks];
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	self.allBookmarks = [allBookmarks sortedArrayUsingDescriptors:@[sorter]];
}

- (NSArray *)getAllBookmarks
{
	return self.allBookmarks;
}

- (BOOL)bookmarkAlreadyExistsFilePath:(NSString *)filePath pageNumber:(NSInteger)pageNumber
{
	for (CWBookmark *aBookmark in self.allBookmarks) {
		if ([aBookmark.fullFilePath isEqualToString:filePath] && [aBookmark.pageNumber integerValue] == pageNumber) {
			return YES;
		}
	}
	return NO;
}

- (void)bookmarkCurrentPage
{
	CWAppDelegate *theAppDelegate = (CWAppDelegate *)[[UIApplication sharedApplication] delegate];
	UIViewController *topVC = [theAppDelegate.navigationController topViewController];
	
	if (topVC.class == [CWCourseReaderViewController class]) {
		
		CWCourseReaderViewController *readerVC = (CWCourseReaderViewController *)topVC;
	
		NSString *filePath = [readerVC currentDocumentPath];
		NSInteger pageNumber = [readerVC currentDocumentPage];
		
		if (![self bookmarkAlreadyExistsFilePath:filePath pageNumber:pageNumber]) {
			
			CWBookmarksManager *aManager = [CWBookmarksManager sharedManager];
			CWBookmark *createdBookmark = [aManager createNewObjectWithClass:[CWBookmark class]];
			
			// extract the title from the file path
			NSString *title = [[[filePath pathComponents] lastObject] stringByDeletingPathExtension];
			
			// assign attributes
			createdBookmark.fullFilePath = filePath;
			createdBookmark.pageNumber = [NSNumber numberWithInteger:pageNumber];
			createdBookmark.date = [NSDate date];
			createdBookmark.title = title;
			
			[aManager saveContext];
			
			[self refreshBookmarkList];
		}
	}
}

- (void)openBookmarkAtIndex:(NSInteger)index
{
	CWAppDelegate *theAppDelegate = (CWAppDelegate *)[[UIApplication sharedApplication] delegate];
	UIViewController *topVC = [theAppDelegate.navigationController topViewController];
	
	if (topVC.class == [CWCourseReaderViewController class]) {
		
		CWCourseReaderViewController *readerVC = (CWCourseReaderViewController *)topVC;
		
		CWBookmark *selectedBookmark = [self.getAllBookmarks objectAtIndex:index];
		[readerVC openFile:selectedBookmark.fullFilePath page:selectedBookmark.pageNumber.integerValue];
	}
}

- (void)deleteBookmarkAtIndex:(NSUInteger)index
{
	CWBookmarksManager *aManager = [CWBookmarksManager sharedManager];
	
	CWBookmark *bookmarkAtI = [self.getAllBookmarks objectAtIndex:index];
	[aManager deleteObject:bookmarkAtI];
	[aManager saveContext];
	
	[self refreshBookmarkList];
}

@end
