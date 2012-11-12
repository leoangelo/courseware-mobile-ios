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
#import "CWMediaAttachment.h"
#import "CWLibraryQuickLookSupport.h"

@interface CWCourseReaderModel ()

@property (nonatomic, strong) NSString *documentPath;
@property (nonatomic, assign) NSUInteger pageNumber;

@end

@implementation CWCourseReaderModel
@synthesize courseDocument = _courseDocument;
@synthesize documentPath = _documentPath;
@synthesize pageNumber = _pageNumber;

- (void)openFile:(NSString *)filePath page:(NSInteger)pageNumber
{
	self.documentPath = filePath;
	self.pageNumber = pageNumber;
	self.courseDocument.pageNumber = [NSNumber numberWithInt:pageNumber];
	[self.delegate modelUpdateDisplayedDocumentPage:self.pageNumber];
}

- (void)setSelectedCourseItem:(CWCourseItem *)selectedCourseItem
{
	if (_selectedCourseItem != selectedCourseItem) {
		_selectedCourseItem = selectedCourseItem;
		
		if (_selectedCourseItem) {
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

- (BOOL)handleDocumentTapAtPage:(NSInteger)atPage atPoint:(CGPoint)atPoint
{
	for (CWMediaAttachment *anAttachment in self.selectedCourseItem.getAllAttachments) {
		
		if (anAttachment.pageNumber == atPage && CGRectContainsPoint(anAttachment.coordinates, atPoint)) {
			[CWLibraryQuickLookSupport openPreview:[anAttachment fullFilePath]];
			return YES;
		}
	}
	
	return NO;
}

@end
