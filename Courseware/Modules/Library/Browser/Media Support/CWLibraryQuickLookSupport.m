//
//  CWLibraryQuickLookSupport.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <QuickLook/QuickLook.h>
#import "CWLibraryQuickLookSupport.h"
#import "CWUtilities.h"

@interface CWLibraryQuickLookSupport () <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *document;

@end

@implementation CWLibraryQuickLookSupport

- (id)initWithFilePath:(NSString *)theFilePath dateRead:(NSDate *)lastDateRead
{
	self = [super initWithFilePath:theFilePath dateRead:lastDateRead];
	if (self) {
		self.document = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:self.filePath]];
		self.document.delegate = self;
	}
	return self;
}

- (NSString *)name
{
	return self.document.name;
}

- (UIImage *)previewIcon
{
	return [self.document.icons objectAtIndex:0];
}

- (void)openPreview
{
	[self.document presentPreviewAnimated:YES];
}

+ (NSSet *)supportedFileTypes
{
	return nil;
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
	return [CWUtilities getTopViewController];
}

@end
