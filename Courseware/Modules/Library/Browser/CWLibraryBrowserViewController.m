//
//  CWLibraryBrowserViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWLibraryBrowserViewController.h"
#import "CWNavigationBar.h"
#import "GMGridView.h"
#import "SLSlideMenuView.h"
#import "CWLibraryBrowserModel.h"
#import "CWLibraryGridCellContentView.h"
#import "CWLibraryMediaSupport.h"
#import "CWLibrarySearchFilterViewController.h"
#import "CWLibrarySortOptionsViewController.h"

static CGFloat kGridSpacing = 15;
static CGSize kItemSize = (CGSize) { 240, 142 };

@interface CWLibraryBrowserViewController () <GMGridViewDataSource, GMGridViewActionDelegate, CWLibrarySearchFilterViewControllerDelegate, CWLibrarySortOptionsViewControllerDelegate>

@property (nonatomic, weak) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, weak) IBOutlet GMGridView *gridView;
@property (nonatomic, strong) CWLibraryBrowserModel *libraryModel;
@property (nonatomic, strong) UIPopoverController *toolsPopover;
@property (nonatomic, strong) CWLibrarySearchFilterViewController *searchFilterVC;
@property (nonatomic, strong) CWLibrarySortOptionsViewController *sortOptionsVC;

- (void)installLibraryTools;
- (void)searchFilterAction:(id)target;
- (void)sortAction:(id)target;

@end

@implementation CWLibraryBrowserViewController

- (CWLibraryBrowserModel *)libraryModel
{
	if (!_libraryModel) {
		_libraryModel = [[CWLibraryBrowserModel alloc] init];
		[_libraryModel rescanMedia];
	}
	return _libraryModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navBar setTitle:@"Library"];
	[self installLibraryTools];
	
	[[SLSlideMenuView slideMenuView] attachToNavBar:self.navBar];
    
	self.gridView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Courseware.bundle/backgrounds/bookshelf-bg.jpg"]];
	self.gridView.style = GMGridViewStyleSwap;
    self.gridView.itemSpacing = 0;
    self.gridView.minEdgeInsets = UIEdgeInsetsMake(kGridSpacing, kGridSpacing, kGridSpacing, kGridSpacing);
    self.gridView.centerGrid = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.gridView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark -

- (void)installLibraryTools
{
	UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(sortAction:)];
	UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchFilterAction:)];
	
	[self.navBar setRightBarButtonItems:@[searchButton, sortButton]];
}

- (void)searchFilterAction:(id)target
{
	if (!self.searchFilterVC) {
		self.searchFilterVC = [[CWLibrarySearchFilterViewController alloc] initWithStyle:UITableViewStylePlain];
		self.searchFilterVC.delegate = self;
	}
	if (!self.toolsPopover) {
		self.toolsPopover = [[UIPopoverController alloc] initWithContentViewController:self.searchFilterVC];
	}
	else {
		[self.toolsPopover setContentViewController:self.searchFilterVC animated:YES];
	}
	[self.toolsPopover setPopoverContentSize:CGSizeMake(250, 44) animated:YES];
	[self.toolsPopover presentPopoverFromBarButtonItem:target permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)sortAction:(id)target
{
	if (!self.sortOptionsVC) {
		self.sortOptionsVC = [[CWLibrarySortOptionsViewController alloc] initWithStyle:UITableViewStylePlain];
		self.sortOptionsVC.delegate = self;
	}
	if (!self.toolsPopover) {
		self.toolsPopover = [[UIPopoverController alloc] initWithContentViewController:self.sortOptionsVC];
	}
	else {
		[self.toolsPopover setContentViewController:self.sortOptionsVC animated:YES];
	}
	[self.toolsPopover setPopoverContentSize:CGSizeMake(250, 132) animated:YES];
	[self.toolsPopover presentPopoverFromBarButtonItem:target permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - 

- (void)searchFilterChanged:(NSString *)filter
{
	self.libraryModel.searchFilter = filter;
	[self.gridView reloadData];
}

- (void)sortOptionSelected:(NSInteger)theOption
{
	self.libraryModel.sortOptions = theOption;
	[self.gridView reloadData];
}

#pragma mark - GMGridView

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
	return [[self.libraryModel displayedMediaList] count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	return kItemSize;
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
	GMGridViewCell *cell = [gridView dequeueReusableCell];
    if (!cell) {
		cell = [[GMGridViewCell alloc] init];
		cell.contentView = [[CWLibraryGridCellContentView alloc] initWithFrame:(CGRect) { CGPointZero, kItemSize }];
	}
	
	CWLibraryGridCellContentView *aContent = (CWLibraryGridCellContentView *)cell.contentView;
	
	CWLibraryMediaSupport *libraryMedia = [self.libraryModel.displayedMediaList objectAtIndex:index];
	[aContent setTitle:libraryMedia.name];
	[aContent setCellImage:libraryMedia.previewIcon];
	
	[aContent setNeedsDisplay];
	
	return cell;
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
	CWLibraryMediaSupport *libraryMedia = [self.libraryModel.displayedMediaList objectAtIndex:position];
	[libraryMedia openPreview];
	[self.libraryModel didOpenMedia:libraryMedia];
}

@end
