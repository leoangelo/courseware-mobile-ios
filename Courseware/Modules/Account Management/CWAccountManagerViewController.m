//
//  CWAccountManagerViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/7/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWAccountManagerViewController.h"
#import "CWNavigationBar.h"
#import "SLSlideMenuView.h"
#import "SLTextInputAutoFocusHelper.h"
#import "CWAccountManager.h"
#import "CWThemeHelper.h"
#import "CWConstants.h"

@interface CWAccountManagerViewController () <UITextFieldDelegate, CWThemeDelegate>

@property (nonatomic, weak) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *lblErrorMessage;
@property (nonatomic, weak) IBOutlet UITextField *txtOldPassword;
@property (nonatomic, weak) IBOutlet UITextField *txtNewPassword;
@property (nonatomic, weak) IBOutlet UITextField *txtNewPasswordConfirm;
@property (nonatomic, weak) IBOutlet UITextField *txtPasswordHint;
@property (nonatomic, weak) IBOutlet UIButton *btnSaveChanges;
@property (nonatomic, weak) IBOutlet UIButton *btnLogout;
@property (nonatomic, weak) IBOutlet UILabel *lblOldPassword;
@property (nonatomic, weak) IBOutlet UILabel *lblNewPassword;
@property (nonatomic, weak) IBOutlet UILabel *lblNewPasswordConfirm;
@property (nonatomic, weak) IBOutlet UILabel *lblPasswordHint;

- (IBAction)saveChangesPressed:(id)sender;
- (IBAction)logOutPressed:(id)sender;

- (BOOL)checkInputValidity;

@end

@implementation CWAccountManagerViewController


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
	SLSlideMenuView *menuView =	[SLSlideMenuView slideMenuView];
	[menuView attachToNavBar:self.navBar];
	[menuView setSticky:YES];
	
	self.scrollView.contentSize = self.scrollView.frame.size;
}

- (void)viewWillAppear:(BOOL)animated
{
	[[SLTextInputAutoFocusHelper sharedHelper] beginAutoFocus];
	
	[[self lblErrorMessage] setText:@""];
	[self updateFontAndColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[SLTextInputAutoFocusHelper sharedHelper] stopAutoFocus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)saveChangesPressed:(id)sender
{
	if ([self checkInputValidity]) {
		NSError *error = nil;
		if ([[CWAccountManager sharedManager] updateActiveUserPassword:self.txtOldPassword.text newPassword:self.txtNewPassword.text passwordHint:self.txtPasswordHint.text error:&error]) {
			
			self.lblErrorMessage.text = @"updated account.";
			self.txtOldPassword.text = @"";
			self.txtNewPassword.text = @"";
			self.txtNewPasswordConfirm.text = @"";
			self.txtPasswordHint.text = @"";
		}
		else {
			switch ([error code]) {
				case ACCOUNT_ERR_CODE_WRONG_PASSWORD: {
					self.lblErrorMessage.text = @"old password is incorrect.";
					break;
				}
				default: {
					self.lblErrorMessage.text = @"unknown error occured.";
					break;
				}
			}
		}
	}
}

- (BOOL)checkInputValidity
{
	if ([self.txtOldPassword.text isEqualToString:@""]) {
		self.lblErrorMessage.text = @"old password is empty";
		return NO;
	}
	if ([self.txtNewPassword.text isEqualToString:@""]) {
		self.lblErrorMessage.text = @"new password is empty";
		return NO;
	}
	if ([self.txtPasswordHint.text isEqualToString:@""]) {
		self.lblErrorMessage.text = @"password hint is empty";
		return NO;
	}
	if (![self.txtNewPassword.text isEqualToString:self.txtNewPasswordConfirm.text]) {
		self.lblErrorMessage.text = @"confirmed password does not match";
	}
	self.lblErrorMessage.text = @"";
	return YES;
}

- (void)logOutPressed:(id)sender
{
	[[CWAccountManager sharedManager] logoutUser];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)updateFontAndColor
{
	self.view.backgroundColor = [[CWThemeHelper sharedHelper] themedBackgroundColor];
	
	UIFont *font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:17]];
	UIColor *textColor = [[CWThemeHelper sharedHelper] themedTextColorHighlighted:NO];
	
	self.txtOldPassword.font = font;
	self.txtNewPassword.font = font;
	self.txtNewPasswordConfirm.font = font;
	self.txtPasswordHint.font = font;
	
	self.btnSaveChanges.titleLabel.font = font;
	self.btnLogout.titleLabel.font = font;
	
	self.lblOldPassword.font = font;
	self.lblNewPassword.font = font;
	self.lblNewPasswordConfirm.font = font;
	self.lblPasswordHint.font = font;
	
	self.lblOldPassword.textColor = textColor;
	self.lblNewPassword.textColor = textColor;
	self.lblNewPasswordConfirm.textColor = textColor;
	self.lblPasswordHint.textColor = textColor;
	
	self.lblErrorMessage.font = [[CWThemeHelper sharedHelper] themedFont:[UIFont fontWithName:kGlobalAppFontNormal size:15]];
	self.lblErrorMessage.textColor = textColor;
}

@end
