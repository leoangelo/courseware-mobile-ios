//
//  CWLibraryMediaSupport.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWLibraryMediaSupport.h"

@implementation CWLibraryMediaSupport

- (id)initWithFilePath:(NSString *)theFilePath
{
	self = [super init];
	if (self) {
		self.filePath = theFilePath;
	}
	return self;
}

- (NSString *)name
{
	return nil;
}

- (UIImage *)previewIcon
{
	return nil;
}

- (void)openPreview
{
	
}

+ (NSSet *)supportedFileTypes
{
	return nil;
}

@end
