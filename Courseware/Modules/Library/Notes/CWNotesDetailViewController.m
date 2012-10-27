//
//  CWNotesDetailViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/22/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWNotesDetailViewController.h"
#import "CWNotesDetailModel.h"
#import "CWThemeHelper.h"
#import "CWConstants.h"

@interface CWNotesDetailViewController () <UITextFieldDelegate, UITextViewDelegate, CWThemeDelegate>

@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) CWNotesDetailModel *model;

@end

@implementation CWNotesDetailViewController


- (id)initWithNote:(CWNote *)aNote
{
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		_model = [[CWNotesDetailModel alloc] initWithNote:aNote];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.contentSizeForViewInPopover = CGSizeMake(320, 436);
	self.tableView.allowsSelection = NO;
	self.tableView.scrollEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self updateFontAndColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self.model updateNoteWithTitle:self.titleField.text content:self.contentTextView.text];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Custom Getters

- (UITextField *)titleField
{
	if (!_titleField) {
		_titleField = [[UITextField alloc] init];
		_titleField.backgroundColor = [UIColor clearColor];
		_titleField.delegate = self;
	}
	return _titleField;
}

- (UITextView *)contentTextView
{
	if (!_contentTextView) {
		_contentTextView = [[UITextView alloc] init];
		_contentTextView.backgroundColor = [UIColor clearColor];
		_contentTextView.delegate = self;
	}
	return _contentTextView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	return section == 0 ? @"Title" : @"Content";
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1) {
		return 140;
	}
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
		static NSString *anId = @"Title-Cell";
		UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:anId];
		if (!aCell) {
			aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:anId];
			self.titleField.frame = (CGRect) {
				0, 0, tableView.frame.size.width , 44
			};
			[aCell.contentView addSubview:self.titleField];
		}
		self.titleField.text = [self.model getNoteTitle];
		// self.titleField.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
		self.titleField.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
		return aCell;
	}
	else {
		static NSString *anId = @"Body-Cell";
		UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:anId];
		if (!aCell) {
			aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:anId];
			self.contentTextView.frame = (CGRect) {
				0, 0, tableView.frame.size.width, 140
			};
			[aCell.contentView addSubview:self.contentTextView];
		}
		self.contentTextView.text = [self.model getNoteContent];
		// self.contentTextView.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
		self.contentTextView.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:16]];
		return aCell;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	CGFloat sectionHeight = [self tableView:tableView heightForHeaderInSection:section];
	UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, sectionHeight)];
	sectionLabel.backgroundColor = [UIColor clearColor];
	sectionLabel.text = section == 0 ? @"Title" : @"Content";
	sectionLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontBold size:20]];
	sectionLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:YES];
	return sectionLabel;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if ([textField.text isEqualToString:DEFAULT_TITLE])	{
		textField.text = @"";
	}
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *currentString = textField.text;
	currentString = [currentString stringByReplacingCharactersInRange:range withString:string];
	
	[_model updateNoteWithTitle:currentString content:self.contentTextView.text];
	
	return YES;
}

#pragma mark - UITextView

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	if ([textView.text isEqualToString:DEFAULT_CONTENT]) {
		textView.text = @"";
	}
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	[_model updateNoteWithTitle:self.titleField.text content:textView.text];
}

#pragma mark - Skinning

- (void)updateFontAndColor
{
	self.tableView.backgroundView = nil;
	self.view.backgroundColor = [[CWThemeHelper sharedHelper] themedBackgroundColor];
	[self.tableView reloadData];
}

@end
