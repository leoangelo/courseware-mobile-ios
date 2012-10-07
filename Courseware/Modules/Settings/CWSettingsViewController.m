//
//  CWSettingsViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/7/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWSettingsViewController.h"
#import "CWNavigationBar.h"
#import "SLSlideMenuView.h"

@interface CWSettingsViewController ()

@property (nonatomic, retain) IBOutlet CWNavigationBar *navBar;

@end

@implementation CWSettingsViewController

- (void)dealloc
{
	[_navBar release];
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	SLSlideMenuView *menuView = [SLSlideMenuView slideMenuView];
	[menuView attachToNavBar:self.navBar];
	[menuView setSticky:YES];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	[self setNavBar:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
