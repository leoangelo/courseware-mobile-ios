//
//  CWCourseListingViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/11/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseListingViewController.h"
#import "CWBrowserPaneView.h"
#import "CWNavigationBar.h"
#import "CWCourseItem.h"
#import "CWCourseListingScreenModel.h"

@interface CWCourseListingViewController () <UITableViewDataSource, UITableViewDelegate, CWBrowserPaneViewDelegate>

@property (nonatomic, retain) IBOutlet CWBrowserPaneView *browserPane;
@property (nonatomic, retain) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UITableView *listView;
@property (nonatomic, retain) CWCourseListingScreenModel *model;

- (void)scrollToCourseItem:(CWCourseItem *)item;

@end

@implementation CWCourseListingViewController

- (void)dealloc
{
	[_browserPane release];
	[_navBar release];
	[_listView release];
	[_model release];
	[super dealloc];
}

- (id)initWithItem:(CWCourseItem *)selectedItem
{
	self = [super init];
	if (self) {
		_model = [[CWCourseListingScreenModel alloc] init];
		_model.selectedCourseItem = selectedItem;
	}
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.browserPane setActiveItem:_model.selectedCourseItem];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.listView = nil;
	self.navBar = nil;
	self.browserPane = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.model.getItemList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CWCourseItem *itemAtI = [self.model.getItemList objectAtIndex:indexPath.row];
	return [self cellHeightForDepth:itemAtI.depth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CWCourseItem *itemAtI = [self.model.getItemList objectAtIndex:indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForDepth:itemAtI.depth]];
	if (!cell) {
		cell = [self cellTemplateForDepth:itemAtI.depth];
	}
	[self reconfigureCell:cell withCourseItem:itemAtI];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	// self.model.selectedCourseItem = [self.model.getItemList objectAtIndex:indexPath.row];
	[self.browserPane setActiveItem:[self.model.getItemList objectAtIndex:indexPath.row]];
	// [self.listView reloadData];
}

- (void)browser:(CWBrowserPaneView *)browser selectedItem:(CWCourseItem *)item
{
	self.model.selectedCourseItem = item;
	[self.listView reloadData];
	
	[self scrollToCourseItem:item];
}

- (void)scrollToCourseItem:(CWCourseItem *)item
{
	NSInteger indexForItem = [self.model.getItemList indexOfObject:item];
	if (indexForItem != NSNotFound) {
		[self.listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexForItem inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
}

#pragma mark - Configuring Cell Appearance

- (CGFloat)cellHeightForDepth:(NSInteger)depth
{
	switch (depth) {
		case 0: return 70.f;
		case 1: return 70.0f;
		case 2: return 65;
	}
	return 50.0f;
}

- (NSString *)cellIdentifierForDepth:(NSInteger)depth
{
	return [NSString stringWithFormat:@"course-list-depth-%i", depth];
}

- (UITableViewCell *)cellTemplateForDepth:(NSInteger)depth
{
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[self cellIdentifierForDepth:depth]];
	
	NSString *fontName = nil;
	CGFloat fontSize = 0;
	// UITableViewCellAccessoryType accessoryType;
	
	if (depth <= 1) {
		fontName = @"FuturaLT-Heavy";
	} else if (depth <= 2) {
		fontName = @"FuturaLT";
	} else {
		fontName = @"FuturaLT-Light";
	}
	
	switch (depth) {
		case 0: fontSize = 23; break;
		case 1: fontSize = 21; break;
		case 2: fontSize = 20; break;
		default: fontSize = 18; break;
	}
	
	cell.textLabel.font = [UIFont fontWithName:fontName size:fontSize];
	cell.detailTextLabel.font = [UIFont fontWithName:fontName size:fontSize - 3];
	
	return [cell autorelease];
}

- (void)reconfigureCell:(UITableViewCell *)cell withCourseItem:(CWCourseItem *)item
{
	cell.textLabel.text = [item.data objectForKey:kCourseItemTitle];
	
	if ([item.data objectForKey:kCourseItemDescription]) {
		cell.detailTextLabel.text = [item.data objectForKey:kCourseItemDescription];
	}
	
	[cell setIndentationLevel:item.depth];
}

@end
