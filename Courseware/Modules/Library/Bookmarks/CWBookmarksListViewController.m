//
//  CWBookmarksListViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/11/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWBookmarksListViewController.h"
#import "CWBookmarksModel.h"
#import "CWThemeHelper.h"
#import "CWConstants.h"

@interface CWBookmarksListViewController () <CWThemeDelegate>

@property (nonatomic, strong) CWBookmarksModel *model;

- (void)confirmEditButtonState;
- (void)insertNewBookmark;

@end

@implementation CWBookmarksListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.contentSizeForViewInPopover = CGSizeMake(320, 436);
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.model refreshBookmarkList];
	[self.tableView reloadData];
	[self updateFontAndColor];
	[self confirmEditButtonState];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)confirmEditButtonState
{
	self.editButtonItem.enabled = self.model.getAllBookmarks.count > 0;
	if (!self.editButtonItem.enabled) {
		[self setEditing:NO animated:NO];
	}
}

- (void)insertNewBookmark
{
	NSInteger oldListCount = [[self.model getAllBookmarks] count];
	[self.model bookmarkCurrentPage];
	NSInteger newListCount = [[self.model getAllBookmarks] count];
	if (newListCount > oldListCount) {
		[self.tableView beginUpdates];
		if (self.model.getAllBookmarks.count == 1) {
			[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
		else {
			[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
		[self.tableView endUpdates];
		
		[self confirmEditButtonState];
	}
}

#pragma mark - Model

- (CWBookmarksModel *)model
{
	if (!_model) {
		_model = [[CWBookmarksModel alloc] init];
	}
	return _model;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *theList = [self.model getAllBookmarks];
	if ([theList count] > 0) {
		return [theList count] + 1;
	}
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch ([[CWThemeHelper sharedHelper] fontTheme]) {
		case CWUserPrefsFontThemeSmall: return 40;
		case CWUserPrefsFontThemeMedium: return 50;
		case CWUserPrefsFontThemeLarge: return 64;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		static NSString *addBookmarkCellId = @"AddBookmarkCell";
		UITableViewCell *addBookmarkCell = [tableView dequeueReusableCellWithIdentifier:addBookmarkCellId];
		if (!addBookmarkCell) {
			addBookmarkCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addBookmarkCellId];
			addBookmarkCell.textLabel.text = @"Bookmark Page";
			addBookmarkCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		}
		addBookmarkCell.selectionStyle = UITableViewCellSelectionStyleBlue;
		addBookmarkCell.textLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
		addBookmarkCell.textLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
		return addBookmarkCell;
	}
	else if (self.model.getAllBookmarks.count > 0) {
		static NSString *bookmarkCellId = @"NoteCell";
		UITableViewCell *bookmarkCell = [tableView dequeueReusableCellWithIdentifier:bookmarkCellId];
		if (!bookmarkCell) {
			bookmarkCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:bookmarkCellId];
		}
		CWBookmark *bookmarkAtIndex = [self.model.getAllBookmarks objectAtIndex:indexPath.row - 1];
		bookmarkCell.textLabel.text = bookmarkAtIndex.title;
		bookmarkCell.detailTextLabel.text = [NSString stringWithFormat:@"Page %@", bookmarkAtIndex.pageNumber];
		
		bookmarkCell.textLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
		bookmarkCell.textLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
		
		bookmarkCell.detailTextLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:YES];
		bookmarkCell.detailTextLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:12]];
		
		return bookmarkCell;
	}
	else {
		static NSString *emptyCellId = @"EmptyCell";
		UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:emptyCellId];
		if (!emptyCell) {
			emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyCellId];
			emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
			emptyCell.textLabel.text = @"No Bookmarks Yet.";
		}
		emptyCell.textLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
		emptyCell.textLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
		return emptyCell;
	}
	return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return indexPath.row > 0 && self.model.getAllBookmarks.count > 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self.model deleteBookmarkAtIndex:indexPath.row - 1];
		if (self.model.getAllBookmarks.count > 0) {
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
		else {
			[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
		
		[self confirmEditButtonState];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row == 0) {
		[self insertNewBookmark];
	}
	else if (self.model.getAllBookmarks.count > 0) {
		[self.model openBookmarkAtIndex:indexPath.row - 1];
	}
}


#pragma mark - Theming

- (void)updateFontAndColor
{
	self.view.backgroundColor = [[CWThemeHelper sharedHelper] themedBackgroundColor];
	[self.tableView reloadData];
}

@end
