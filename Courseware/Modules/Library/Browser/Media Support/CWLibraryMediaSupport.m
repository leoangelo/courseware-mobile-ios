//
//  CWLibraryMediaSupport.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWLibraryMediaSupport.h"

@implementation CWLibraryMediaSupport

+ (void)openPreview:(NSString *)fullFilePath
{
	id mediaSupport = [(CWLibraryMediaSupport *)[self alloc] initWithFilePath:fullFilePath dateRead:[NSDate date]];
	[(CWLibraryMediaSupport *)mediaSupport openPreview];
}

- (id)initWithFilePath:(NSString *)theFilePath dateRead:(NSDate *)lastDateRead
{
	self = [super init];
	if (self) {
		self.filePath = theFilePath;
		self.lastDateRead = lastDateRead;
		self.type = [theFilePath pathExtension];
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
