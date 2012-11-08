//
//  CWNotesListingModel.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/22/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWNotesListingModel.h"
#import "CWNotesManager.h"

@interface CWNotesListingModel ()

@property (nonatomic, strong) NSArray *allNotes;

@end

@implementation CWNotesListingModel


- (id)init
{
	self = [super init];
	if (self) {
		[self rebuildList];
	}
	return self;
}

- (NSArray *)getAllNotes
{
	return self.allNotes;
}

- (void)rebuildList
{
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	self.allNotes = [[[CWNotesManager sharedManager] allNotes] sortedArrayUsingDescriptors:@[sorter]];
}

- (void)deleteNoteAtIndex:(NSInteger)theIndex
{
	CWNote *noteToDelete = [self.allNotes objectAtIndex:theIndex];
	[[CWNotesManager sharedManager] deleteObject:(NSManagedObject *)noteToDelete];
	[self rebuildList];
}

@end
