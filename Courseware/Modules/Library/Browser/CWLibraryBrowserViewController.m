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

static CGFloat kGridSpacing = 30;
static CGSize kItemSize = (CGSize) { 240, 142 };

@interface CWLibraryBrowserViewController () <GMGridViewDataSource, GMGridViewActionDelegate>

@property (nonatomic, weak) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, weak) IBOutlet GMGridView *gridView;
@property (nonatomic, strong) CWLibraryBrowserModel *libraryModel;

@end

@implementation CWLibraryBrowserViewController

- (CWLibraryBrowserModel *)libraryModel
{
	if (!_libraryModel) {
		_libraryModel = [[CWLibraryBrowserModel alloc] init];
	}
	return _libraryModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navBar setTitle:@"Library"];
	
	[[SLSlideMenuView slideMenuView] attachToNavBar:self.navBar];
    
	self.gridView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Courseware.bundle/backgrounds/bookshelf-bg.jpg"]];
	self.gridView.style = GMGridViewStyleSwap;
    self.gridView.itemSpacing = 0;
    self.gridView.minEdgeInsets = UIEdgeInsetsMake(kGridSpacing, kGridSpacing, kGridSpacing, kGridSpacing);
    self.gridView.centerGrid = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.libraryModel rescanMedia];
	[self.gridView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

#pragma mark - GMGridView

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
	return [[self.libraryModel mediaList] count];
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
	NSString *mediaTitle = [[[self.libraryModel.mediaList objectAtIndex:index] mediaPath] lastPathComponent];
	[aContent setTitle:mediaTitle];
	
	[aContent setNeedsDisplay];
	
	return cell;
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
	
}

@end
