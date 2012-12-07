//
//  CWUserLoginViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/2/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWUserLoginViewController.h"
#import "CWHomeViewController.h"
#import "CWAccountManager.h"
#import "CWCourseSyncingViewController.h"
#import "CWThemeHelper.h"
#import "CWConstants.h"
#import "CWAdsViewController.h"
#import "CWGlobals.h"

#define AUTO_FILL_CREDENTIALS 1

@interface CWUserLoginViewController () <CWThemeDelegate, UITextFieldDelegate> {
}

@property (nonatomic, weak) IBOutlet UIImageView *imgAppLogo;
@property (nonatomic, weak) IBOutlet UILabel *lblUsername;
@property (nonatomic, weak) IBOutlet UILabel *lblPassword;
@property (nonatomic, weak) IBOutlet UITextField *txtUsername;
@property (nonatomic, weak) IBOutlet UITextField *txtPassword;
@property (nonatomic, weak) IBOutlet UILabel *lblErrorFeedback;
@property (nonatomic, weak) IBOutlet UIButton *btnLogin;
@property (nonatomic, weak) IBOutlet UIButton *btnRemember;
@property (nonatomic, weak) IBOutlet UIButton *btnSync;

@property (nonatomic, strong) CWAdsViewController *ads;

@property (nonatomic) BOOL rememberLogin;

- (IBAction)loginUser;
- (IBAction)openSyncing:(id)sender;
- (void)pushToCourseListingScreen;
- (IBAction)rememberLoginPressed:(id)sender;

@end

@implementation CWUserLoginViewController


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
	
    // Do any additional setup after loading the view from its nib.
	if (AUTO_FILL_CREDENTIALS) {
		self.txtUsername.text = @"JGoitia";
		self.txtPassword.text = @"123";
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	// if there's already a saved user, use that
	if ([[CWAccountManager sharedManager] autoLoginSavedUser]) {
		[self pushToCourseListingScreen];
		return;
	}
	
	[self updateFontAndColor];
	self.lblErrorFeedback.text = @"";
	self.rememberLogin = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	if ([CWGlobals sharedInstance].justLoggedOut) {
		if (!self.ads) {
			self.ads = [[CWAdsViewController alloc] init];
		}
		[self.ads showInterstitalAdsAnimated:YES];
		[CWGlobals sharedInstance].justLoggedOut = NO;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Button Actions

- (void)rememberLoginPressed:(id)sender
{
	self.rememberLogin = !self.rememberLogin;
}

- (void)setRememberLogin:(BOOL)rememberLogin
{
	_rememberLogin = rememberLogin;
	NSString *checkBox = @"Courseware.bundle/controls/checkbox-nofill.png";
	if (rememberLogin) {
		checkBox = @"Courseware.bundle/controls/checkbox-filled.png";
	}
	[self.btnRemember setImage:[UIImage imageNamed:checkBox] forState:UIControlStateNormal];
}

- (void)loginUser
{
	NSError *loginError = nil;
	if ([[CWAccountManager sharedManager] loginUser:self.txtUsername.text password:self.txtPassword.text error:&loginError rememberAccount:self.rememberLogin]) {
		self.lblErrorFeedback.text = @"Successfully logged in.";
		[CWGlobals sharedInstance].justLoggedIn = YES;
		[self performSelector:@selector(pushToCourseListingScreen) withObject:nil afterDelay:0.3f];
	}
	else {
		switch ([loginError code]) {
			case ACCOUNT_ERR_CODE_USER_NOT_FOUND: {
				self.lblErrorFeedback.text = @"Username not found!";
				break;
			}
			case ACCOUNT_ERR_CODE_WRONG_PASSWORD: {
				self.lblErrorFeedback.text = [NSString stringWithFormat:@"Wrong password. Hint: %@", [[CWAccountManager sharedManager] passwordHintForUsername:self.txtUsername.text]];
				break;
			}
			default: {
				self.lblErrorFeedback.text = @"";
				break;
			}
		}
	}
}

#pragma mark - User Inteface

- (void)updateFontAndColor
{
	self.view.backgroundColor = [[CWThemeHelper sharedHelper] themedBackgroundColor];
	// self.imgAppLogo.image = [[CWThemeHelper sharedHelper] themedAppLogo];
	self.imgAppLogo.image = [UIImage imageNamed:@"Courseware.bundle/logos/large-logo.png"];
	
	UIFont *newFont = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:17]];
	self.txtUsername.font = newFont;
	self.txtPassword.font = newFont;
	
	self.btnRemember.titleLabel.font = newFont;
	[self.btnRemember setTitleColor:[[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO] forState:UIControlStateNormal];
	[self.btnRemember setTitleColor:[[CWThemeHelper sharedHelper] themedTextColorHighlighted:YES] forState:UIControlStateHighlighted];
	
	self.btnLogin.titleLabel.font = newFont;
	self.btnSync.titleLabel.font = newFont;
	
	self.lblErrorFeedback.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:15]];
	self.lblErrorFeedback.textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
}

#pragma mark - Screen Transitions

- (void)pushToCourseListingScreen
{
	CWHomeViewController *aVC = [[CWHomeViewController alloc] init];
	[self.navigationController pushViewController:aVC animated:YES];
}

- (void)openSyncing:(id)sender
{
	CWCourseSyncingViewController *vc = [[CWCourseSyncingViewController alloc] init];
	vc.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.txtUsername) {
		[self.txtPassword becomeFirstResponder];
	}
	else if (textField == self.txtPassword) {
		[textField resignFirstResponder];
		[self loginUser];
	}
	return YES;
}

@end
