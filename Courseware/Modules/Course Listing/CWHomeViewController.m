//
//  CWCourseListingViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWHomeViewController.h"
#import "CWBrowserPaneView.h"
#import "CWNavigationBar.h"
#import "CWRecentReadingsPanelView.h"
#import "CWUserStatusPanelView.h"
#import "SLSlideMenuView.h"
#import "CWCourseListingViewController.h"
#import "CWCourseReaderViewController.h"
#import "CWThemeHelper.h"
#import "CWCourseItem.h"

#import "CWCourseManager.h"

@interface CWHomeViewController () <CWBrowserPaneViewDelegate, CWThemeDelegate, CWRecentReadingsPanelViewDelegate>

@property (nonatomic, weak) IBOutlet CWNavigationBar *topNavBar;
@property (nonatomic, weak) IBOutlet CWBrowserPaneView *leftPanel;
@property (nonatomic, weak) IBOutlet CWUserStatusPanelView *userPanel;
@property (nonatomic, weak) IBOutlet CWRecentReadingsPanelView *recentReadingsPanel;

- (void)pushToCourseListingWithSelectedItem:(CWCourseItem *)item;
- (void)pushToCourseReaderWithSelectedItem:(CWCourseItem *)item;

@end

@implementation CWHomeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[CWCourseManager sharedManager];
	
	[[SLSlideMenuView slideMenuView] attachToNavBar:self.topNavBar];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self updateFontAndColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)browser:(CWBrowserPaneView *)browser selectedItem:(CWCourseItem *)item
{
	[self pushToCourseListingWithSelectedItem:item];
}

- (void)pushToCourseListingWithSelectedItem:(CWCourseItem *)item
{
	CWCourseListingViewController *aController = [[CWCourseListingViewController alloc] initWithItem:item];
	[self.navigationController pushViewController:aController animated:YES];
}

- (void)pushToCourseReaderWithSelectedItem:(CWCourseItem *)item
{
	CWCourseReaderViewController *vc = [[CWCourseReaderViewController alloc] init];
	vc.selectedCourse = item;
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)updateFontAndColor
{
	self.view.backgroundColor = [[CWThemeHelper sharedHelper] themedBackgroundColor];
	[self.leftPanel updateFontAndColor];
	[self.userPanel updateFontAndColor];
	[self.recentReadingsPanel updateFontAndColor];
}

#pragma mark - Recent Readings delegate

- (void)recentReadingSelectedCourseItem:(CWCourseItem *)theCourseItem
{
	if ([theCourseItem hasFileContent]) {
		[self pushToCourseReaderWithSelectedItem:theCourseItem];
	}
}

@end
