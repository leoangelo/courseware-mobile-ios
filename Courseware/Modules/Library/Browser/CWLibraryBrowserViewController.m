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

@property (nonatomic, weak) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, weak) IBOutlet GMGridView *gridView;

@end

@implementation CWLibraryBrowserViewController


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
		
		cell = [[GMGridViewCell alloc] init];
		
		UIView *aContentView = [[UIView alloc] initWithFrame:(CGRect) { CGPointZero, kItemSize }];
		aContentView.backgroundColor = [UIColor clearColor];
		
		UIImageView *anImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Courseware.bundle/book-covers/cover-%i.png", randomNumber]]];
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
