//
//  CWLibraryMediaManager.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWLibraryMediaManager.h"
#import "CWMedia.h"
#import "CWUtilities.h"

static NSString * const kUserDefsHasImportedSampleMedia = @"UserDefsHasImportedSampleMedia";

@interface CWLibraryMediaManager ()

- (void)importSampleData;
- (NSString *)mediaFolder;

- (void)removeDeadLinks;
- (void)buildLibraryDatabase;

- (CWMedia *)mediaWithFileName:(NSString *)theFileName;

@end

@implementation CWLibraryMediaManager

+ (CWLibraryMediaManager *)sharedManager
{
	__strong static CWLibraryMediaManager *aManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		aManager = [[CWLibraryMediaManager alloc] init];
	});
	return aManager;
}

- (id)init
{
	self = [super init];
	if (self) {
//		NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
//		if (![userDefs boolForKey:kUserDefsHasImportedSampleMedia]) {
		[self importSampleData];
//		[userDefs setBool:YES forKey:kUserDefsHasImportedSampleMedia];
//		[userDefs synchronize];
//		}
	}
	return self;
}

- (void)removeDeadLinks
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *indexedMedia = [self fetchObjectsWithClass:[CWMedia class] withPredicate:nil];
	for (CWMedia *aMedium in indexedMedia) {
		NSString *filePath = aMedium.mediaPath;
		if (![fileManager fileExistsAtPath:filePath]) {
			[self deleteObject:aMedium];
		}
	}
	[self saveContext];
}

- (void)buildLibraryDatabase
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentRoot = [CWUtilities documentRootPath];
	NSSet *supportedTypes = [[self class] supportedFileTypes];
	NSDirectoryEnumerator *scanner = [fileManager enumeratorAtPath:documentRoot];
	NSString *fileName = nil;
	while (fileName = [scanner nextObject]) {
		
		// if the current file is a medium (i.e. a supported file type), create a core data object for it
		NSString *fullPath = [documentRoot stringByAppendingPathComponent:fileName];
		if ([supportedTypes member:[fullPath pathExtension]]) {
			
			// last check: only create one if it does not exist in the database yet
			if (![self mediaWithFileName:fullPath]) {
				CWMedia *aNewFile = [self createNewObjectWithClass:[CWMedia class]];
				aNewFile.mediaPath = fullPath;
				aNewFile.lastDateOpened = [NSDate date];
			}
		}
	}
	[self saveContext];
}

- (CWMedia *)mediaWithFileName:(NSString *)theFileName
{
	NSPredicate *query = [NSPredicate predicateWithFormat:@"mediaPath == %@", theFileName];
	NSArray *queryResult = [self fetchObjectsWithClass:[CWMedia class] withPredicate:query];
	if ([queryResult count] > 0) {
		return [queryResult objectAtIndex:0];
	}
	return nil;
}

- (void)rescanMedia
{
	// Step 1: Check the existence of the indexed media on the core data in the file system. Delete if its not there. For consistency purposes
	[self removeDeadLinks];
	// Step 2: Scan the media folder in the app filesystem. Saved what is found to core data.
	[self buildLibraryDatabase];
}

// Copies the media found in the bundle to the filesystem.
- (void)importSampleData
{
	NSMutableArray *sourcePaths = [NSMutableArray array];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	for (NSString *fileExtension in [[self class] supportedFileTypes]) {
		[sourcePaths addObjectsFromArray:[[CWUtilities courseWareBundle] pathsForResourcesOfType:fileExtension inDirectory:@"sample-data"]];
	}

	for (NSString *filePath in sourcePaths) {
		NSString *fileName = [filePath lastPathComponent];
		NSData *sourceData = [NSData dataWithContentsOfFile:filePath];
		
		// save to media folder
		NSString *targetPath = [[self mediaFolder] stringByAppendingPathComponent:fileName];
		if (![fileManager fileExistsAtPath:targetPath]) {
			[fileManager createFileAtPath:targetPath contents:sourceData attributes:nil];
		}
	}
}

// Full path of the where we host media. Creates the folder if not present yet.
- (NSString *)mediaFolder
{
	NSString *mediaPath = [[CWUtilities documentRootPath] stringByAppendingPathComponent:@"media"];
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	if (![fileMgr fileExistsAtPath:mediaPath isDirectory:NULL]) {
		NSError *error = nil;
		if (![fileMgr createDirectoryAtPath:mediaPath withIntermediateDirectories:YES attributes:nil error:&error]) {
			NSLog(@"Error occured while creating folder: %@", error);
		}
	}
	return mediaPath;
}

+ (NSSet *)supportedFileTypes
{
	return [NSSet setWithObjects:
			@"key"
			, @"ppt"
			, @"pptx"
			, @"pdf"
			, @"png"
			, @"gif"
			, @"jpg"
			, @"jpeg"
			, @"txt"
			, @"rtf"
			, @"xls"
			, @"xlsx"
			, @"doc"
			, @"docx"
			, @"aac"
			, @"mp3"
			, @"mp4"
			, nil];
}

@end
