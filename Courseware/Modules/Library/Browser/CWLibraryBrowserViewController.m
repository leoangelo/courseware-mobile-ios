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

static CGFloat kGridSpacing = 30;
static CGSize kItemSize = (CGSize) { 240, 142 };

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
	self.title = @"Library";
	
	[[SLSlideMenuView slideMenuView] attachToNavBar:self.navBar];
    
	self.gridView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Courseware.bundle/bookshelf-bg.jpg"]];
	self.gridView.style = GMGridViewStyleSwap;
    self.gridView.itemSpacing = 0;
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
	return 16;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	return kItemSize;
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
	GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) {
		
		NSInteger randomNumber = arc4random() % 8;
		
		cell = [[[GMGridViewCell alloc] init] autorelease];
		
		UIView *aContentView = [[[UIView alloc] initWithFrame:(CGRect) { CGPointZero, kItemSize }] autorelease];
		aContentView.backgroundColor = [UIColor clearColor];
		
		UIImageView *anImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Courseware.bundle/book-covers/cover-%i.png", randomNumber]]] autorelease];
		[aContentView addSubview:anImage];

		anImage.frame = (CGRect) {
			roundf((aContentView.frame.size.width - anImage.frame.size.width) / 2.f),
			aContentView.frame.size.height - anImage.frame.size.height,
			anImage.frame.size
		};
		
		cell.contentView = aContentView;
		
	}
	
	return cell;
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
	
}

@end
