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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
		[cell setIndentationWidth:30];
	}
	CWCourseItem *itemAtI = [self.model.getItemList objectAtIndex:indexPath.row];
	cell.textLabel.text = [itemAtI.data objectForKey:kCourseItemTitle];
	
	[cell setIndentationLevel:itemAtI.depth];
	
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

@end
