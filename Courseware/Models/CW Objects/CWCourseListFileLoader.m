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

- (void)loadSampleFile
{
	NSBundle *courseWareBundle = [CWUtilities courseWareBundle];
	NSAssert(courseWareBundle, @"must not be nil");
	NSString *sampleXMLPath = [courseWareBundle pathForResource:@"courses" ofType:@"json" inDirectory:@"sample-data"];
	[self loadFilePath:sampleXMLPath];
}

@end
