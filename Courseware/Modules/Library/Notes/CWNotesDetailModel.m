//
//  CWNotesDetailModel.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/22/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWNotesDetailModel.h"
#import "CWNotesManager.h"
#import "CWNote.h"
#import "NSString+SLUtilities.h"

@interface CWNotesDetailModel () {
	CWNote *note;
}

@end

@implementation CWNotesDetailModel


- (id)initWithNote:(CWNote *)theNote
{
	self = [super init];
	if (self) {
		note = theNote;
	}
	return self;
}

- (NSString *)getNoteTitle
{
	if (note.subject && ![[note.subject trim] isEqualToString:@""]) {
		return note.subject;
	}
	return DEFAULT_TITLE;
}

- (NSString *)getNoteContent
{
	if (note.body && ![[note.body trim] isEqualToString:@""]) {
		return note.body;
	}
	return DEFAULT_CONTENT;
}

- (void)updateNoteWithTitle:(NSString *)theTitle content:(NSString *)theContent
{
	if ([[theTitle trim] isEqualToString:@""]) {
		theTitle = DEFAULT_TITLE;
	}
	
	if ([[theContent trim] isEqualToString:@""]) {
		theContent = DEFAULT_CONTENT;
	}
	
	note.subject = theTitle;
	note.body = theContent;
	
	[[CWNotesManager sharedManager] saveContext];
}

@end
