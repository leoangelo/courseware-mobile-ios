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
#import "CWConstants.h"

@interface CWSettingsViewController () <CWThemeDelegate>

@property (nonatomic, weak) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, weak) IBOutlet UISegmentedControl *colorSelector;
@property (nonatomic, weak) IBOutlet UISegmentedControl *fontSizeSelector;
@property (nonatomic, weak) IBOutlet UILabel *lblTheme;
@property (nonatomic, weak) IBOutlet UILabel *lblFontSize;
@property (nonatomic, weak) IBOutlet UILabel *lblEmail;
@property (nonatomic, weak) IBOutlet UILabel *lblSoundNotifs;
@property (nonatomic, weak) IBOutlet UITextField *txtEmail;
@property (nonatomic, weak) IBOutlet UIButton *btnSound;

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
	[self.navBar setTitle:@"Settings"];
	// initialize the slide menu
	SLSlideMenuView *menuView = [SLSlideMenuView slideMenuView];
	[menuView attachToNavBar:self.navBar];
	[menuView setSticky:YES];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	[[CWThemeHelper sharedHelper] unregisterForThemeChanges:self];
}

- (void)viewWillAppear:(BOOL)animated
{
	[[SLTextInputAutoFocusHelper sharedHelper] beginAutoFocus];
	[self.colorSelector setSelectedSegmentIndex:[CWThemeHelper sharedHelper].colorTheme];
	[self.fontSizeSelector setSelectedSegmentIndex:[CWThemeHelper sharedHelper].fontTheme];
	
	[[CWThemeHelper sharedHelper] registerForThemeChanges:self];
	[self updateFontAndColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[SLTextInputAutoFocusHelper sharedHelper] stopAutoFocus];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
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
	self.view.backgroundColor = [[CWThemeHelper sharedHelper] themedBackgroundColor];
	
	UIFont *labelFont = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:17]];
	self.lblTheme.font = labelFont;
	self.lblFontSize.font = labelFont;
	self.lblEmail.font = labelFont;
	self.lblSoundNotifs.font = labelFont;
	self.txtEmail.font = labelFont;
	
	UIColor *textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
	self.lblTheme.textColor = textColor;
	self.lblFontSize.textColor = textColor;
	self.lblEmail.textColor = textColor;
	self.lblSoundNotifs.textColor = textColor;
	
	self.btnSound.titleLabel.font = labelFont;
}

@end
