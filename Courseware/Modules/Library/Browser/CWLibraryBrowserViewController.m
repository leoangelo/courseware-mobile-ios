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

static CGFloat kGridSpacing = 64.f;

@interface CWLibraryBrowserViewController () <GMGridViewDataSource, GMGridViewActionDelegate>

@property (nonatomic, retain) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, retain) IBOutlet GMGridView *gridView;

@end

@implementation CWLibraryBrowserViewController

- (void)dealloc
{
	[_navBar release];
	[_gridView release];
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[SLSlideMenuView slideMenuView] attachToNavBar:self.navBar];
    
	self.title = @"Library";
	self.gridView.style = GMGridViewStyleSwap;
    self.gridView.itemSpacing = kGridSpacing;
    self.gridView.minEdgeInsets = UIEdgeInsetsMake(kGridSpacing, kGridSpacing, kGridSpacing, kGridSpacing);
    self.gridView.centerGrid = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.navBar = nil;
	self.gridView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.gridView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

#pragma mark - GMGridView

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
	return 9;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	return CGSizeMake(144, 200);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
	GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) {
		
		cell = [[[GMGridViewCell alloc] init] autorelease];
		
		UIView *aContentView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)] autorelease];
		aContentView.backgroundColor = [UIColor clearColor];
		
		UIImageView *anImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Courseware.bundle/book-icon.png"]] autorelease];
		[aContentView addSubview:anImage];
		
		anImage.center = aContentView.center;
		
		cell.contentView = aContentView;
		
	}
	
	return cell;
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
	
}

@end
