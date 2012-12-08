//
//  CWCourseManager.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseManager.h"
#import "CWCourseItem.h"
#import "CWCourseListFileLoader.h"
#import "CWPersistentCourseItem.h"

#define USE_SAMPLE_DATA 1

@interface CWCourseManager () <CWCourseListFileLoaderDelegate>

@property (nonatomic, strong) NSMutableSet *fileLoaders;

- (void)buildSampleData;
- (void)addLessonsToArray:(NSMutableArray *)aLessonsArr fromItem:(CWCourseItem *)theItem;

@end

@implementation CWCourseManager


+ (CWCourseManager *)sharedManager
{
	static dispatch_once_t pred = 0;
	__strong static CWCourseManager *thisManager = nil;
	dispatch_once(&pred, ^{
		if (!thisManager) {
			thisManager = [[CWCourseManager alloc] init];
		}
	});
	return thisManager;
}

- (id)init
{
	self = [super init];
	if (self) {
		if (USE_SAMPLE_DATA) {
			[self buildSampleData];
		}
	}
	return self;
}

#pragma mark - Lazy Loading Instances

- (NSMutableArray *)courseListing
{
	if (!_courseListing) {
		_courseListing = [[NSMutableArray alloc] init];
	}
	return _courseListing;
}

- (NSMutableSet *)fileLoaders
{
	if (!_fileLoaders) {
		_fileLoaders = [[NSMutableSet alloc] init];
	}
	return _fileLoaders;
}

+ (CWCourseItem *)defaultSelectedCourse
{
	if ([[[self sharedManager] courseListing] count] > 0) {
		return [[[self sharedManager] courseListing] objectAtIndex:0];
	}
	return nil;
}

#pragma mark - Producing sample data

- (void)buildSampleData
{
	CWCourseListFileLoader *fileLoader = [[CWCourseListFileLoader alloc] initWithDelegate:self];
	[self.fileLoaders addObject:fileLoader];
	[fileLoader loadSampleFile];
}

#pragma mark - Querying Course Data

- (NSArray *)allLessons
{
	NSMutableArray *retLessons = [NSMutableArray array];
	for (CWCourseItem *aCourse in self.courseListing) {
		[self addLessonsToArray:retLessons fromItem:aCourse];
	}
	return retLessons;
}

- (void)addLessonsToArray:(NSMutableArray *)aLessonsArr fromItem:(CWCourseItem *)theItem
{
	if (theItem.children.count == 0) {
		[aLessonsArr addObject:theItem];
		
	}
	else {
		for (CWCourseItem *aChild in theItem.children) {
			[self addLessonsToArray:aLessonsArr fromItem:aChild];
		}
	}
}

#pragma mark - CWCourseListFileLoaderDelegate

- (void)loader:(CWCourseListFileLoader *)theLoader coursePrepared:(CWCourseItem *)theCourse
{
//	NSLog(@"Course added: %@", theCourse);
	[self.courseListing addObject:theCourse];
}

- (void)loaderFinished:(CWCourseListFileLoader *)theLoader
{
	[self.fileLoaders removeObject:theLoader];

}

#pragma mark - Handling last date read

- (NSDate *)getLastDateReadOfCourseItem:(CWCourseItem *)theItem
{
	NSPredicate *equalToId = [NSPredicate predicateWithFormat:@"courseId == %@", [theItem.data objectForKey:kCourseItemId]];
	NSArray *result = [self fetchObjectsWithClass:[CWPersistentCourseItem class] withPredicate:equalToId];
	if ([result count] > 0) {
		return [[result objectAtIndex:0] lastDateRead];
	}
	return [NSDate dateWithTimeIntervalSince1970:0];
}

- (void)updateLastDateReadForCourseItem:(CWCourseItem *)theItem
{
	NSPredicate *equalToId = [NSPredicate predicateWithFormat:@"courseId == %@", [theItem.data objectForKey:kCourseItemId]];
	NSArray *result = [self fetchObjectsWithClass:[CWPersistentCourseItem class] withPredicate:equalToId];
	if ([result count] > 0) {
		CWPersistentCourseItem *itemToUpdate = [result objectAtIndex:0];
		itemToUpdate.lastDateRead = [NSDate date];
	}
	else {
		CWPersistentCourseItem *newItem = [self createNewObjectWithClass:[CWPersistentCourseItem class]];
		newItem.courseId = [theItem.data objectForKey:kCourseItemId];
		newItem.lastDateRead = [NSDate date];
	}
	[self saveContext];
}


@end
