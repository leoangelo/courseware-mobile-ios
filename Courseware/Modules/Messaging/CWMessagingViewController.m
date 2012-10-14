//
//  CWMessagingViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWMessagingViewController.h"
#import "CWNavigationBar.h"
#import "SLSlideMenuView.h"
#import "CWMessageDetailView.h"
#import "CWMessagingModel.h"
#import "CWMessage.h"
#import "CWThemeHelper.h"

@interface CWMessagingViewController () <CWMessagingModelDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CWMessagingModel *model;

@property (nonatomic, weak) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, weak) IBOutlet SLSlideMenuView *slideMenu;

@property (nonatomic, weak) IBOutlet UITableView *mainMenu;
@property (nonatomic, weak) IBOutlet UITableView *messageListView;
@property (nonatomic, weak) IBOutlet CWMessageDetailView *messageDetailView;

- (void)reconfigureCell:(UITableViewCell *)theCell withMessage:(CWMessage *)theMessage;

@end

@implementation CWMessagingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	[[SLSlideMenuView slideMenuView] attachToNavBar:self.navBar];
	
	self.messageDetailView.model = self.model;
	
	[self.model refreshData];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.mainMenu selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
	[self.model mainMenuItemSelected:1];
	
	self.messageDetailView.hidden = YES;
	self.messageListView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CWMessagingModel *)model
{
	if (!_model) {
		_model = [[CWMessagingModel alloc] init];
		_model.delegate = self;
	}
	return _model;
}

#pragma mark -

- (void)modelMainMenuSelectedItemChanged
{
	[self.messageListView reloadData];
}

- (void)modelNeedMessagePreProcess
{
	[self.messageDetailView preProcessMessage];
}

- (void)modelMessageListingNeedsRefresh
{
	[self.messageListView reloadData];
}

- (void)modelFinishedMessageViewing
{
	self.messageDetailView.hidden = YES;
	self.messageListView.hidden = NO;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.mainMenu) {
		return self.model.mainMenuList.count;
	}
	else if (tableView == self.messageListView) {
		return self.model.messageListForCurrentSelection.count;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.mainMenu) {
		NSString *anId = @"main-menu";
		UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:anId];
		if (!aCell) {
			aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:anId];
		}
		aCell.textLabel.text = [self.model.mainMenuList objectAtIndex:indexPath.row];
		return aCell;
	}
	else if (tableView == self.messageListView) {
		NSString *anId = @"message-list";
		UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:anId];
		if (!aCell) {
			aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:anId];
		}
		[self reconfigureCell:aCell withMessage:[self.model.messageListForCurrentSelection objectAtIndex:indexPath.row]];
		return aCell;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.mainMenu) {
		if (indexPath.row == 0) {
			[self.mainMenu deselectRowAtIndexPath:self.mainMenu.indexPathForSelectedRow animated:YES];
			[self.model setSelectedMessage:[self.model newBlankMessage]];
			self.messageDetailView.hidden = NO;
			self.messageListView.hidden = YES;
			[self.messageDetailView refreshView];
		}
		else {
			self.messageDetailView.hidden = YES;
			self.messageListView.hidden = NO;
			[self.model mainMenuItemSelected:indexPath.row];
		}
	}
	else if (tableView == self.messageListView) {
		// means a message has been selected -- go to that
		
		[self.mainMenu deselectRowAtIndexPath:self.mainMenu.indexPathForSelectedRow animated:YES];
		
		self.model.selectedMessage = [self.model.messageListForCurrentSelection objectAtIndex:indexPath.row];
		self.messageDetailView.hidden = NO;
		self.messageListView.hidden = YES;
		[self.messageDetailView refreshView];
	}
}

- (void)reconfigureCell:(UITableViewCell *)theCell withMessage:(CWMessage *)theMessage
{
	BOOL isDrafted = [CWMessagingModel messageIsDrafted:theMessage];
	BOOL isSent = [CWMessagingModel messageIsSent:theMessage];
	
	if (isDrafted || isSent) {
		theCell.textLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", theMessage.receiver_email, theMessage.title, theMessage.date];
	}
	else {
		theCell.textLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", theMessage.sender_email, theMessage.title, theMessage.date];
	}
}

@end
