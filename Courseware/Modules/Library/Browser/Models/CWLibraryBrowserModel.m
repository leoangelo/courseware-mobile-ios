//
//  CWLibraryBrowserModel.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWLibraryBrowserModel.h"
#import "CWLibraryMediaManager.h"

@interface CWLibraryBrowserModel ()

@end

@implementation CWLibraryBrowserModel

- (void)rescanMedia
{
	[[CWLibraryMediaManager sharedManager] rescanMedia];
	self.mediaList = [[CWLibraryMediaManager sharedManager] fetchObjectsWithClass:[CWMedia class] withPredicate:nil];
}

@end
