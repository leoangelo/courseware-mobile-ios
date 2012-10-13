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

#import "CWCourseManager.h"

@interface CWHomeViewController () <CWBrowserPaneViewDelegate>

@property (nonatomic, strong) IBOutlet CWNavigationBar *topNavBar;
@property (nonatomic, strong) IBOutlet CWBrowserPaneView *leftPanel;
@property (nonatomic, strong) IBOutlet CWUserStatusPanelView *userPanel;
@property (nonatomic, strong) IBOutlet CWRecentReadingsPanelView *recentReadingsPanel;

- (void)pushToCourseListingWithSelectedItem:(CWCourseItem *)item;

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

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.topNavBar = nil;
	self.leftPanel = nil;
	self.userPanel = nil;
	self.recentReadingsPanel = nil;
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

@end
