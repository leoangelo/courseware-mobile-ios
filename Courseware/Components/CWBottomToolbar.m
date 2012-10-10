//
//  CWBottomToolbar.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/16/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWBottomToolbar.h"
#import "CWBottomToolbarController.h"

@interface CWBottomToolbar ()

@property (nonatomic, retain) CWBottomToolbarController *controller;

- (void)initializeItems;

@end

@implementation CWBottomToolbar

- (void)dealloc
{
	[_controller release];
	[super dealloc];
}

- (void)awakeFromNib
{
	[self initializeItems];
}

- (void)initializeItems
{
	self.controller = [[[CWBottomToolbarController alloc] init] autorelease];
	
	NSMutableArray *anItems = [[NSMutableArray alloc] init];
	
	[anItems addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
	
	UIBarButtonItem *bookmarksButton = [[[UIBarButtonItem alloc] initWithTitle:@"Bookmarks" style:UIBarButtonItemStyleBordered target:self.controller action:@selector(bookmarksAction:)] autorelease];
	[anItems addObject:bookmarksButton];
	
	UIBarButtonItem *notesButton = [[[UIBarButtonItem alloc] initWithTitle:@"Notes" style:UIBarButtonItemStyleBordered target:self.controller action:@selector(notesAction:)] autorelease];
	[anItems addObject:notesButton];
	
	UIBarButtonItem *testsButton = [[[UIBarButtonItem alloc] initWithTitle:@"Take Test" style:UIBarButtonItemStyleBordered target:self.controller action:@selector(testsAction:)] autorelease];
	[anItems addObject:testsButton];
	
	[anItems addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
	
	self.items = anItems;
	
	[anItems release];
}

@end
