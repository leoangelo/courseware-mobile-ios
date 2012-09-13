//
//  CWCourseListFileLoader.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseListFileLoader.h"
#import "CWCourse.h"
#import "CWCourseModule.h"
#import "CWChapter.h"
#import "CWLesson.h"

@interface CWCourseListFileLoader () <NSXMLParserDelegate>

@property (nonatomic, retain) CWCourse *currentCourse;
@property (nonatomic, retain) CWCourseModule *currentModule;
@property (nonatomic, retain) CWChapter *currentChapter;
@property (nonatomic, retain) CWLesson *currentLesson;

@property (nonatomic, retain) NSMutableArray *lessonList;
@property (nonatomic, retain) NSMutableArray *chapterList;
@property (nonatomic, retain) NSMutableArray *moduleList;
@property (nonatomic, retain) NSXMLParser *xmlParser;

@end

@implementation CWCourseListFileLoader

- (void)dealloc
{
	[_currentLesson release];
	[_currentChapter release];
	[_currentModule release];
	[_currentCourse release];
	
	[_lessonList release];
	[_chapterList release];
	[_moduleList release];
	
	_loaderDelegate = nil;
	_xmlParser.delegate = nil;
	[_xmlParser abortParsing];
	[_xmlParser release];
	[super dealloc];
}

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
	// Do nothing yet!
}

- (void)loadSampleFile
{
	NSBundle *courseWareBundle = [self.class courseWareBundle];
	NSAssert(courseWareBundle, @"must not be nil");
	NSString *sampleXMLPath = [courseWareBundle pathForResource:@"sample-data" ofType:@"xml"];
	NSData *xmlData = [NSData dataWithContentsOfFile:sampleXMLPath];
	NSAssert(xmlData, @"must not be nil!");
	
	[self.xmlParser setDelegate:nil];
	[self.xmlParser abortParsing];
	
	self.xmlParser = [[[NSXMLParser alloc] initWithData:xmlData] autorelease];
	self.xmlParser.delegate = self;
	self.xmlParser.shouldProcessNamespaces = NO;
	[self.xmlParser parse];
}

+ (NSBundle *)courseWareBundle
{
	NSArray *bundles = [[NSBundle mainBundle] pathsForResourcesOfType:@"bundle" inDirectory:@""];
	NSBundle *cwBundle = nil;
	
	// locate the bundle.
	for (NSString *bundlePath in bundles) {
		if ([bundlePath rangeOfString:@"Courseware"].location != NSNotFound) {
			cwBundle = [NSBundle bundleWithPath:bundlePath];
			break;
		}
	}
	return cwBundle;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"course"]) {
		self.currentCourse = [[[CWCourse alloc] init] autorelease];
		self.currentCourse.title = [attributeDict objectForKey:@"title"];
		self.moduleList = [NSMutableArray array];
	}
	else if ([elementName isEqualToString:@"module"]) {
		self.currentModule = [[[CWCourseModule alloc] init] autorelease];
		self.currentModule.title = [attributeDict objectForKey:@"title"];
		self.chapterList = [NSMutableArray array];
	}
	else if ([elementName isEqualToString:@"chapter"]) {
		self.currentChapter = [[[CWChapter alloc] init] autorelease];
		self.currentChapter.title = [attributeDict objectForKey:@"title"];
		self.lessonList = [NSMutableArray array];
	}
	else if ([elementName isEqualToString:@"lesson"]) {
		self.currentLesson = [[[CWLesson alloc] init] autorelease];
		self.currentLesson.title = [attributeDict objectForKey:@"title"];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"course"]) {
		self.currentCourse.children = [NSArray arrayWithArray:self.moduleList];
		if ([self.loaderDelegate respondsToSelector:@selector(loader:coursePrepared:)]) {
			[self.loaderDelegate loader:self coursePrepared:self.currentCourse];
		}
	}
	else if ([elementName isEqualToString:@"module"]) {
		self.currentModule.children = [NSArray arrayWithArray:self.chapterList];
		self.currentModule.parent = self.currentCourse;
		[self.moduleList addObject:self.currentModule];
	}
	else if ([elementName isEqualToString:@"chapter"]) {
		self.currentChapter.children = [NSArray arrayWithArray:self.lessonList];
		self.currentChapter.parent = self.currentModule;
		[self.chapterList addObject:self.currentChapter];
	}
	else if ([elementName isEqualToString:@"lesson"]) {
		self.currentLesson.parent = self.currentChapter;
		[self.lessonList addObject:self.currentLesson];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	if ([self.loaderDelegate respondsToSelector:@selector(loaderFinished:)]) {
		[self.loaderDelegate loaderFinished:self];
	}
}

@end
