//
//  CWCourseReaderModel.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/16/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseReaderModel.h"
#import "ReaderDocument.h"
#import "CWCourseItem.h"
#import "CWUtilities.h"

@interface CWCourseReaderModel ()

@property (nonatomic, strong) NSString *documentPath;
@property (nonatomic, assign) NSUInteger pageNumber;

@end

@implementation CWCourseReaderModel
@synthesize courseDocument = _courseDocument;
@synthesize documentPath = _documentPath;
@synthesize pageNumber = _pageNumber;

- (void)setSelectedCourseItem:(CWCourseItem *)selectedCourseItem
{
	if (_selectedCourseItem != selectedCourseItem) {
		_selectedCourseItem = selectedCourseItem;
		
		self.documentPath = [_selectedCourseItem fullFilePath];
		if ([_selectedCourseItem.data objectForKey:kCourseItemPageNumber]) {
			self.pageNumber = [[_selectedCourseItem.data objectForKey:kCourseItemPageNumber] integerValue];
		}
		else {
			self.pageNumber = 1;
		}
		self.courseDocument.pageNumber = [NSNumber numberWithInteger:self.pageNumber];
		
		[self.delegate modelChangedSelectedCourseItem:_selectedCourseItem];
		[self.delegate modelUpdateDisplayedDocumentPage:self.pageNumber];
	}
}

- (void)setDocumentPath:(NSString *)documentPath
{
	if (documentPath && ![_documentPath isEqualToString:documentPath]) {
		_courseDocument = nil;
		_courseDocument = [self.class documentFromFilePath:documentPath];
		[_courseDocument updateProperties];
		_documentPath = documentPath;
		
		[self.delegate modelUpdateDisplayedDocument:_courseDocument];
	}
}

+ (ReaderDocument *)documentFromFilePath:(NSString *)filePath
{
	return [ReaderDocument withDocumentFilePath:filePath password:nil];
}

//+ (ReaderDocument *)sampleDocument
//{
//	NSString *filePath = [[CWUtilities courseWareBundle] pathForResource:@"sample" ofType:@"pdf" inDirectory:@"sample-data"];
//	return [self documentFromFilePath:filePath];
//}

//- (NSInteger)randomPageIndex
//{
//	return arc4random() % [self.courseDocument.pageCount integerValue];
//}

//- (ReaderDocument *)courseDocument
//{
//	if (!_courseDocument) {
//		_courseDocument = [self.class sampleDocument];
//		[_courseDocument updateProperties];
//	}
//	return _courseDocument;
//}

@end
