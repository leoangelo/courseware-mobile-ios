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
#import "SLTextInputAutoFocusHelper.h"

@interface CWSettingsViewController ()

@property (nonatomic, strong) IBOutlet CWNavigationBar *navBar;

@end

@implementation CWSettingsViewController


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

- (void)viewWillAppear:(BOOL)animated
{
	[[SLTextInputAutoFocusHelper sharedHelper] beginAutoFocus];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[SLTextInputAutoFocusHelper sharedHelper] stopAutoFocus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
