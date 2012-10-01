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
#import "CWMessagesManager.h"

@interface CWMessagingViewController () <CWMessagingModelDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) CWMessagingModel *model;

@property (nonatomic, retain) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, retain) IBOutlet SLSlideMenuView *slideMenu;

@property (nonatomic, retain) IBOutlet UITableView *mainMenu;
@property (nonatomic, retain) IBOutlet UITableView *messageListView;
@property (nonatomic, retain) IBOutlet CWMessageDetailView *messageDetailView;

- (void)reconfigureCell:(UITableViewCell *)theCell withMessage:(CWMessage *)theMessage;

@end

@implementation CWMessagingViewController

- (void)dealloc
{
	[_navBar release];
	[_slideMenu release];
	
	[_mainMenu release];
	[_messageListView release];
	[_messageDetailView release];
	
	[_model release];
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[SLSlideMenuView slideMenuView] attachToNavBar:self.navBar];
	
	[self.model refreshData];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	self.navBar = nil;
	self.slideMenu = nil;
	self.mainMenu = nil;
	self.messageListView = nil;
	self.messageDetailView = nil;
	self.model = nil;
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

- (void)mainMenuSelectedItemChanged
{
	[self.messageListView reloadData];
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
			aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:anId] autorelease];
		}
		aCell.textLabel.text = [self.model.mainMenuList objectAtIndex:indexPath.row];
		return aCell;
	}
	else if (tableView == self.messageListView) {
		NSString *anId = @"message-list";
		UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:anId];
		if (!aCell) {
			aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:anId] autorelease];
		}
		[self reconfigureCell:aCell withMessage:[self.model.messageListForCurrentSelection objectAtIndex:indexPath.row]];
		return aCell;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.mainMenu) {
		[self.model mainMenuItemSelected:indexPath.row];
	}
}

- (void)reconfigureCell:(UITableViewCell *)theCell withMessage:(CWMessage *)theMessage
{
	BOOL isDrafted = ([theMessage.status intValue] & CWMessageStateDrafted) == CWMessageStateDrafted;
	BOOL isSent = ([theMessage.status intValue] & CWMessageStateSent) == CWMessageStateSent;
	
	if (isDrafted || isSent) {
		theCell.textLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", theMessage.receiver_email, theMessage.title, theMessage.date];
	}
	else {
		theCell.textLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", theMessage.sender_email, theMessage.title, theMessage.date];
	}
}

@end
