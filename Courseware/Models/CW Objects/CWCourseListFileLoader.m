//
//  CWCourseListFileLoader.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseListFileLoader.h"
#import "CWCourseItem.h"
#import "NSString+SLUtilities.h"
#import "CWUtilities.h"

@interface CWCourseListFileLoader ()

- (void)readCourseItemsFromJSON:(id)jsonData fromParentItem:(CWCourseItem *)parentItem;
- (NSString *)coursesFolder;

@end

@implementation CWCourseListFileLoader


- (id)initWithDelegate:(id<CWCourseListFileLoaderDelegate>)theDelegate
{
	self = [super init];
	if (self) {
		self.loaderDelegate = theDelegate;
	}
	return self;
}

- (void)loadFilePath:(NSString *)theFilePath
{
	// Typically, the file we will load comes from the filesystem, and not from the app bundle.
	
	NSData *fileData = [NSData dataWithContentsOfFile:theFilePath];
	if (fileData) {
		NSError *readError = nil;
		id jsonData = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:&readError];
		if (readError) {
			NSLog(@"Error parsing JSON: %@", readError.localizedDescription);
			return;
		}
		[self readCourseItemsFromJSON:jsonData fromParentItem:nil];
	}
	else {
		NSLog(@"File not found.");
	}
}

- (void)readCourseItemsFromJSON:(id)jsonData fromParentItem:(CWCourseItem *)parentItem
{
	if ([jsonData isKindOfClass:[NSArray class]]) {
		for (id child in jsonData) {
			[self readCourseItemsFromJSON:child fromParentItem:parentItem];
		}
	}
	else if ([jsonData isKindOfClass:[NSDictionary class]]) {
		NSDictionary *jsonDict = (NSDictionary *)jsonData;
		CWCourseItem *anItem = [[CWCourseItem alloc] init];
		
		if ([jsonDict objectForKey:@"title"]) {
			[anItem.data setObject:[jsonDict objectForKey:@"title"] forKey:kCourseItemTitle];
		}
		
		if ([jsonDict objectForKey:@"description"]) {
			[anItem.data setObject:[jsonDict objectForKey:@"description"] forKey:kCourseItemDescription];
		}
		
		if ([jsonDict objectForKey:@"directory-name"]) {
			[anItem.data setObject:[jsonDict objectForKey:@"directory-name"] forKey:kCourseItemDirectoryName];
		}
		
		if ([jsonDict objectForKey:@"filename"]) {
			[anItem.data setObject:[jsonDict objectForKey:@"filename"] forKey:kCourseItemFileName];
		}
		
		if ([jsonDict objectForKey:@"page-number"]) {
			[anItem.data setObject:[jsonDict objectForKey:@"page-number"] forKey:kCourseItemPageNumber];
		}
		
		if ([jsonDict objectForKey:@"children"]) {
			[self readCourseItemsFromJSON:[jsonDict objectForKey:@"children"] fromParentItem:anItem];
		}
		
		anItem.parent = parentItem;
		[parentItem.children addObject:anItem];
		
		if (!anItem.parent) {
			[self.loaderDelegate loader:self coursePrepared:anItem];
		}
		
	}
	else if ([jsonData isKindOfClass:[NSString class]]) {
		CWCourseItem *anItem = [[CWCourseItem alloc] init];
		[anItem.data setObject:jsonData forKey:kCourseItemTitle];
		
		anItem.parent = parentItem;
		[parentItem.children addObject:anItem];
		
	}
}

#pragma mark - Sample Data

- (void)saveMediaDirectory:(NSArray *)files
{
	for (NSString *aFile in files) {
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		NSData *sourceData = [NSData dataWithContentsOfFile:aFile];
		
		NSString *filename = [[aFile pathComponents] lastObject];
		NSString *courseDir = [[aFile pathComponents] objectAtIndex:[[aFile pathComponents] count] - 3];
		NSString *mediaDir = [[aFile pathComponents] objectAtIndex:[[aFile pathComponents] count] - 2];
		
		// save to courses folder
		NSString *targetPath = [[[self coursesFolder] stringByAppendingPathComponent:courseDir] stringByAppendingPathComponent:mediaDir];
		
		if (![fileManager fileExistsAtPath:targetPath]) {
			[fileManager createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
		}
		
		targetPath = [targetPath stringByAppendingPathComponent:filename];
		
		if (![fileManager fileExistsAtPath:targetPath]) {
			[fileManager createFileAtPath:targetPath contents:sourceData attributes:nil];
		}
	}
}

- (void)saveFiletoCourseFolder:(NSString *)filePath
{
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSData *sourceData = [NSData dataWithContentsOfFile:filePath];
	
	NSString *filename = [[filePath pathComponents] lastObject];
	NSString *directory = [[filePath pathComponents] objectAtIndex:[[filePath pathComponents] count] - 2];
	
	// save to courses folder
	NSString *targetPath = [[self coursesFolder] stringByAppendingPathComponent:directory];
	
	if (![fileManager fileExistsAtPath:targetPath]) {
		[fileManager createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	targetPath = [targetPath stringByAppendingPathComponent:filename];
	
	if (![fileManager fileExistsAtPath:targetPath]) {
		[fileManager createFileAtPath:targetPath contents:sourceData attributes:nil];
	}
}

- (void)loadSampleFile
{
	NSBundle *courseWareBundle = [CWUtilities courseWareBundle];
	NSAssert(courseWareBundle, @"must not be nil");
	NSString *sampleXMLPath = [courseWareBundle pathForResource:@"courses" ofType:@"json" inDirectory:@"sample-data"];
	[self loadFilePath:sampleXMLPath];
	
	[self saveFiletoCourseFolder:[courseWareBundle pathForResource:@"D1-M1-T5" ofType:@"pdf" inDirectory:@"sample-data/function-1-deck"]];
	[self saveFiletoCourseFolder:[courseWareBundle pathForResource:@"Engine - Function 1" ofType:@"pdf" inDirectory:@"sample-data/function-1-engine"]];
	[self saveFiletoCourseFolder:[courseWareBundle pathForResource:@"Presentation - Module 3" ofType:@"pdf" inDirectory:@"sample-data/function-2-deck"]];
	
	[self saveMediaDirectory:[courseWareBundle pathsForResourcesOfType:@"mp4" inDirectory:@"sample-data/function-1-deck/media"]];
	[self saveMediaDirectory:[courseWareBundle pathsForResourcesOfType:@"jpg" inDirectory:@"sample-data/function-1-engine/media"]];
	[self saveMediaDirectory:[courseWareBundle pathsForResourcesOfType:@"docx" inDirectory:@"sample-data/function-1-engine/documents"]];
	[self saveMediaDirectory:[courseWareBundle pathsForResourcesOfType:@"jpg" inDirectory:@"sample-data/function-2-deck/media"]];
	[self saveMediaDirectory:[courseWareBundle pathsForResourcesOfType:@"gif" inDirectory:@"sample-data/function-2-deck/media"]];
}

- (NSString *)coursesFolder
{
	NSString *mediaPath = [[CWUtilities documentRootPath] stringByAppendingPathComponent:@"courses"];
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	if (![fileMgr fileExistsAtPath:mediaPath isDirectory:NULL]) {
		NSError *error = nil;
		if (![fileMgr createDirectoryAtPath:mediaPath withIntermediateDirectories:YES attributes:nil error:&error]) {
			NSLog(@"Error occured while creating folder: %@", error);
		}
	}
	return mediaPath;
}

@end
