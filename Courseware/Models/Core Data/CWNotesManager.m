//
//  CWNotesManager.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/22/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWNotesManager.h"
#import "CWNote.h"
#import "NSString+SLUtilities.h"

@implementation CWNotesManager


+ (CWNotesManager *)sharedManager
{
	__strong static CWNotesManager *aManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (!aManager) {
			aManager = [[CWNotesManager alloc] init];
		}
	});
	return aManager;
}

- (id)init
{
	self = [super init];
	if (self) {
		
	}
	return self;
}

- (NSArray *)allNotes
{
	return [self fetchObjectsWithClass:[CWNote class] withPredicate:nil];
}

- (CWNote *)createBlankNote
{
	CWNote *aNote = [self createNewObjectWithClass:[CWNote class]];
	aNote.noteId = [NSString generateRandomString];
	[self saveContext];
	return aNote;
}

- (void)updateNotesAsynchrous:(BOOL)asynchronous
{
	if (asynchronous) {
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
		dispatch_async(queue, ^{
			[self saveContext];
		});
	}
	else {
		[self saveContext];
	}
}

@end
