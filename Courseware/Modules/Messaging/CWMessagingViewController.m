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
#import "CWConstants.h"
#import "CWMessageTableViewCell.h"

@interface CWMessagingViewController () <CWMessagingModelDelegate, UITableViewDataSource, UITableViewDelegate, CWThemeDelegate>

@property (nonatomic, strong) CWMessagingModel *model;

@property (nonatomic, weak) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, weak) IBOutlet SLSlideMenuView *slideMenu;

@property (nonatomic, weak) IBOutlet UITableView *mainMenu;
@property (nonatomic, weak) IBOutlet UITableView *messageListView;
@property (nonatomic, weak) IBOutlet CWMessageDetailView *messageDetailView;

@property (nonatomic, weak) IBOutlet UIImageView *menuContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *messageContainerView;
@property (nonatomic, weak) IBOutlet UILabel *messageTitleLabel;

@end

@implementation CWMessagingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navBar setTitle:@"Messages"];
	SLSlideMenuView *slideMenu =  [SLSlideMenuView slideMenuView];
	[slideMenu attachToNavBar:self.navBar];
	[slideMenu setSticky:YES];
	
	self.menuContainerView.image = [[UIImage imageNamed:@"Courseware.bundle/backgrounds/message-oval-bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
	self.messageContainerView.image = [UIImage imageNamed:@"Courseware.bundle/backgrounds/message-square-bg.png"];
	
	self.messageDetailView.model = self.model;
	
	[self.model refreshData];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self updateFontAndColor];
	
	[self.mainMenu selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
	[self.model mainMenuItemSelected:0];
	
	self.messageDetailView.hidden = YES;
	self.messageListView.hidden = NO;
	
	[self.messageDetailView beginAutoFocus];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self.messageDetailView stopAutoFocus];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.mainMenu) {
		return 60;
	}
	return 36;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.mainMenu) {
		NSString *anId = @"main-menu";
		UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:anId];
		if (!aCell) {
			aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:anId];
			
			UIView *selectionView = [[UIView alloc] init];
			selectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
			aCell.selectedBackgroundView = selectionView;
		}
		aCell.textLabel.text = [[self.model.mainMenuList objectAtIndex:indexPath.row] uppercaseString];
		aCell.textLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
		aCell.textLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:24]];
		return aCell;
	}
	else if (tableView == self.messageListView) {
		NSString *anId = [CWThemeHelper sharedHelper].colorTheme == CWUserPrefsColorThemeDark ? kMessageTableViewCellIdentifierDark : kMessageTableViewCellIdentifierLight;
		CWMessageTableViewCell *aCell = (CWMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:anId];
		if (!aCell) {
			aCell = [[CWMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:anId];
		}
		CWMessage *theMessage = [self.model.messageListForCurrentSelection objectAtIndex:indexPath.row];
		aCell.sender = [CWMessagingModel formattedSender:theMessage];
		aCell.title = [CWMessagingModel formattedTitle:theMessage];
		aCell.date = [CWMessagingModel formattedDate:theMessage];
		
		[aCell setNeedsDisplay];
		[aCell setNeedsLayout];
		return aCell;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.mainMenu) {
		self.messageDetailView.hidden = YES;
		self.messageListView.hidden = NO;
		[self.model mainMenuItemSelected:indexPath.row];
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

- (void)updateFontAndColor
{
	self.view.backgroundColor = [[CWThemeHelper sharedHelper] themedBackgroundColor];
	[self.messageListView reloadData];
	[self.mainMenu reloadData];
	[self.messageDetailView updateFontAndColor];
	
	self.messageTitleLabel.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:20]];
	self.messageTitleLabel.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
}

@end
