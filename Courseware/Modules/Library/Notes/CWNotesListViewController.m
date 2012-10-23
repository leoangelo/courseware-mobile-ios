//
//  CWNotesListViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/22/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWNotesListViewController.h"
#import "CWNotesListingModel.h"
#import "CWNote.h"
#import "CWNotesDetailViewController.h"
#import "CWNotesManager.h"
#import "CWThemeHelper.h"
#import "CWConstants.h"

@interface CWNotesListViewController () <CWThemeDelegate>

@property (nonatomic, strong) CWNotesListingModel *model;

@end

@implementation CWNotesListViewController


- (CWNotesListingModel *)model
{
	if (!_model) {
		_model = [[CWNotesListingModel alloc] init];
	}
	return _model;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.contentSizeForViewInPopover = CGSizeMake(320, 436);

}

- (void)viewDidUnload
{
    [super viewDidUnload];
	 _model = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.model rebuildList];
	[self.tableView reloadData];
	self.editButtonItem.enabled = self.model.getAllNotes.count > 0;
	
	[self updateFontAndColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *theList = [self.model getAllNotes];
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
		static NSString *addNoteCellId = @"AddNoteCell";
		UITableViewCell *addNoteCell = [tableView dequeueReusableCellWithIdentifier:addNoteCellId];
		if (!addNoteCell) {
			addNoteCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addNoteCellId];
			addNoteCell.textLabel.text = @"Add Note";
			addNoteCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		}
		addNoteCell.textLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
		addNoteCell.textLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
		return addNoteCell;
	}
	else if (indexPath.row > 0 && self.model.getAllNotes.count > 0) {
		static NSString *noteCellId = @"NoteCell";
		UITableViewCell *noteCell = [tableView dequeueReusableCellWithIdentifier:noteCellId];
		if (!noteCell) {
			noteCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:noteCellId];
		}
		CWNote *noteForCell = [self.model.getAllNotes objectAtIndex:indexPath.row - 1];
		noteCell.textLabel.text = noteForCell.subject;
		noteCell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:noteForCell.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];

		noteCell.textLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
		noteCell.textLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
		
		noteCell.detailTextLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:YES];
		noteCell.detailTextLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:12]];
		
		return noteCell;
	}
	else {
		static NSString *emptyCellId = @"EmptyCell";
		UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:emptyCellId];
		if (!emptyCell) {
			emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyCellId];
			emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
			emptyCell.textLabel.text = @"No Notes Yet.";
		}
		emptyCell.textLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
		emptyCell.textLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
		return emptyCell;
	}
	return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return indexPath.row > 0 && self.model.getAllNotes.count > 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self.model deleteNoteAtIndex:indexPath.row - 1];
		if (self.model.getAllNotes.count > 0) {
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}
		else {
			[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CWNote *selectedNote = nil;
	if (indexPath.row == 0) {
		selectedNote = [[CWNotesManager sharedManager] createBlankNote];
	}
	else if (self.model.getAllNotes.count > 0 && indexPath.row > 0) {
		selectedNote = [self.model.getAllNotes objectAtIndex:indexPath.row - 1];
	}
	
	if (selectedNote) {
		CWNotesDetailViewController *detailViewController = [[CWNotesDetailViewController alloc] initWithNote:selectedNote];
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
		
}

#pragma mark - Skinning

- (void)updateFontAndColor
{
	self.view.backgroundColor = [[CWThemeHelper sharedHelper] themedBackgroundColor];
	[self.tableView reloadData];
}

@end
