//
//  CWMediaAttachment.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/13/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWMediaAttachment.h"
#import "CWCourseItem.h"

@implementation CWMediaAttachment

- (NSString *)fullFilePath
{
	// get the full file path of the parent item.
	// discard the pdf path
	NSString *coursePath = [self.parentItem.fullFilePath stringByDeletingLastPathComponent];
	NSString *mediaPath = [coursePath stringByAppendingPathComponent:@"media"];
	NSString *fullPath = [mediaPath stringByAppendingPathComponent:self.filename];
	
	return fullPath;
}

@end
