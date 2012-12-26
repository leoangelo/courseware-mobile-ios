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

@property (nonatomic, strong) CWBottomToolbarController *controller;

- (void)initializeItems;

@end

@implementation CWBottomToolbar


- (void)awakeFromNib
{
	[self initializeItems];
}

- (void)initializeItems
{
	self.controller = [[CWBottomToolbarController alloc] init];
	
	NSMutableArray *anItems = [[NSMutableArray alloc] init];
	
	[anItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
	
	UIBarButtonItem *bookmarksButton = [[UIBarButtonItem alloc] initWithTitle:@"Bookmarks" style:UIBarButtonItemStyleBordered target:self.controller action:@selector(bookmarksAction:)];
	[anItems addObject:bookmarksButton];
	
	UIBarButtonItem *notesButton = [[UIBarButtonItem alloc] initWithTitle:@"Notes" style:UIBarButtonItemStyleBordered target:self.controller action:@selector(notesAction:)];
	[anItems addObject:notesButton];
	
	UIBarButtonItem *testsButton = [[UIBarButtonItem alloc] initWithTitle:@"Take Test" style:UIBarButtonItemStyleBordered target:self.controller action:@selector(testsAction:)];
	[anItems addObject:testsButton];
	
	UIBarButtonItem *videoButton = [[UIBarButtonItem alloc] initWithTitle:@"Record Video" style:UIBarButtonItemStyleBordered target:self.controller action:@selector(videoCaptureAction:)];
	[anItems addObject:videoButton];
	
	[anItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
	
	self.items = anItems;
	
}

- (void)updateFontAndColor
{
	// self.barStyle = [[CWThemeHelper sharedHelper] colorTheme] == CWUserPrefsColorThemeDark ? UIBarStyleBlack : UIBarStyleDefault;
}

- (void)dismissPopups
{
	[self.controller dismissAllActivePopups];
}

@end
