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

@property (nonatomic, retain) IBOutlet CWNavigationBar *topNavBar;
@property (nonatomic, retain) IBOutlet CWBrowserPaneView *leftPanel;
@property (nonatomic, retain) IBOutlet CWUserStatusPanelView *userPanel;
@property (nonatomic, retain) IBOutlet CWRecentReadingsPanelView *recentReadingsPanel;

- (void)pushToCourseListing;

@end

@implementation CWHomeViewController

- (void)dealloc {
	[_topNavBar release];
	[_leftPanel release];
	[_userPanel release];
	[_recentReadingsPanel release];
	[super dealloc];
}

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
	[self pushToCourseListing];
}

- (void)pushToCourseListing
{
	CWCourseListingViewController *aController = [[CWCourseListingViewController alloc] init];
	[self.navigationController pushViewController:aController animated:YES];
	[aController release];
}

@end
