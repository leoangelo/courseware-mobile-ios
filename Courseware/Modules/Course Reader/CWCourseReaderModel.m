//
//  CWCourseReaderModel.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/16/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseReaderModel.h"
#import "ReaderDocument.h"
#import "CWUtilities.h"

@implementation CWCourseReaderModel

+ (ReaderDocument *)documentFromFilePath:(NSString *)filePath
{
	return [ReaderDocument withDocumentFilePath:filePath password:nil];
}

+ (ReaderDocument *)sampleDocument
{
	NSString *filePath = [[CWUtilities courseWareBundle] pathForResource:@"sample" ofType:@"pdf"];
	return [self documentFromFilePath:filePath];
}

- (NSInteger)randomPageIndex
{
	return arc4random() % [self.courseDocument.pageCount integerValue];
}

- (ReaderDocument *)courseDocument
{
	if (!_courseDocument) {
		_courseDocument = [self.class sampleDocument];
		[_courseDocument updateProperties];
	}
	return _courseDocument;
}

@end
