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

#define AUTO_FILL_CREDENTIALS 1

@interface CWUserLoginViewController ()

@property (nonatomic, weak) IBOutlet UILabel *lblUsername;
@property (nonatomic, weak) IBOutlet UILabel *lblPassword;
@property (nonatomic, weak) IBOutlet UITextField *txtUsername;
@property (nonatomic, weak) IBOutlet UITextField *txtPassword;
@property (nonatomic, weak) IBOutlet UILabel *lblErrorFeedback;
@property (nonatomic, weak) IBOutlet UIButton *btnLogin;

- (IBAction)loginUser;
- (IBAction)openSyncing:(id)sender;
- (void)pushToCourseListingScreen;

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
		self.txtUsername.text = @"superlazyperson";
		self.txtPassword.text = @"123";
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	self.lblErrorFeedback.text = @"";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Button Actions

- (void)loginUser
{
	NSError *loginError = nil;
	if ([[CWAccountManager sharedManager] loginUser:self.txtUsername.text password:self.txtPassword.text error:&loginError]) {
		self.lblErrorFeedback.text = @"Successfully logged in.";
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

@end
