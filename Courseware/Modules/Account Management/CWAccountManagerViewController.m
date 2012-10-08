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

@interface CWAccountManagerViewController () <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *lblErrorMessage;
@property (nonatomic, retain) IBOutlet UITextField *txtOldPassword;
@property (nonatomic, retain) IBOutlet UITextField *txtNewPassword;
@property (nonatomic, retain) IBOutlet UITextField *txtNewPasswordConfirm;
@property (nonatomic, retain) IBOutlet UITextField *txtPasswordHint;

- (IBAction)saveChangesPressed:(id)sender;
- (IBAction)logOutPressed:(id)sender;

- (BOOL)checkInputValidity;

@end

@implementation CWAccountManagerViewController

- (void)dealloc
{
	[_txtOldPassword release];
	[_txtNewPassword release];
	[_txtNewPasswordConfirm release];
	[_txtPasswordHint release];
	[_lblErrorMessage release];
	[_navBar release];
	[_scrollView release];
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
	SLSlideMenuView *menuView =	[SLSlideMenuView slideMenuView];
	[menuView attachToNavBar:self.navBar];
	[menuView setSticky:YES];
	
	self.scrollView.contentSize = self.scrollView.frame.size;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	[self setNavBar:nil];
	[self setScrollView:nil];
	[self setTxtOldPassword:nil];
	[self setTxtNewPassword:nil];
	[self setTxtNewPasswordConfirm:nil];
	[self setTxtPasswordHint:nil];
	[self setLblErrorMessage:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[[SLTextInputAutoFocusHelper sharedHelper] beginAutoFocus];
	
	[[self lblErrorMessage] setText:@""];
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

@end
