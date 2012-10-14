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
#import "CWThemeHelper.h"

@interface CWSettingsViewController () <CWThemeDelegate>

@property (nonatomic, weak) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, weak) IBOutlet UISegmentedControl *colorSelector;
@property (nonatomic, weak) IBOutlet UISegmentedControl *fontSizeSelector;

- (IBAction)colorThemeSelectionChanged:(id)sender;
- (IBAction)fontSizeSelectionChanged:(id)sender;

@end

@implementation CWSettingsViewController

- (void)dealloc
{
	[[CWThemeHelper sharedHelper] unregisterForThemeChanges:self];
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
	
	// initialize the slide menu
	SLSlideMenuView *menuView = [SLSlideMenuView slideMenuView];
	[menuView attachToNavBar:self.navBar];
	[menuView setSticky:YES];
	
	// register on theme central
	[[CWThemeHelper sharedHelper] registerForThemeChanges:self];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	[[CWThemeHelper sharedHelper] unregisterForThemeChanges:self];
}

- (void)viewWillAppear:(BOOL)animated
{
	[[SLTextInputAutoFocusHelper sharedHelper] beginAutoFocus];
	[self updateFontAndColor];
	[self.colorSelector setSelectedSegmentIndex:[CWThemeHelper sharedHelper].colorTheme];
	[self.fontSizeSelector setSelectedSegmentIndex:[CWThemeHelper sharedHelper].fontTheme];
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

- (void)colorThemeSelectionChanged:(id)sender
{
	[[CWThemeHelper sharedHelper] setColorTheme:[(UISegmentedControl *)sender selectedSegmentIndex]];
}

- (void)fontSizeSelectionChanged:(id)sender
{
	[[CWThemeHelper sharedHelper] setFontTheme:[(UISegmentedControl *) sender selectedSegmentIndex]];
}

- (void)updateFontAndColor
{
	[[CWThemeHelper sharedHelper] updateBackgroundColor:self.view];
}

@end
