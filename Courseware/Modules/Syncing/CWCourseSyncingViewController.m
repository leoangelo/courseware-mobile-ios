//
//  CWCourseSyncingViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/13/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseSyncingViewController.h"
#import "CWHTTPServer.h"

@interface CWCourseSyncingViewController ()

@property (nonatomic, weak) IBOutlet UINavigationItem *navItem;
@property (nonatomic, weak) IBOutlet UILabel *lblServerStatus;
@property (nonatomic, strong) CWHTTPServer *httpServer;

- (IBAction)closeButtonPressed:(id)sender;
- (void)httpServerFinishedSetup:(NSNotification *)notification;

@end

@implementation CWCourseSyncingViewController

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
	UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(closeButtonPressed:)];
	self.navItem.rightBarButtonItem = closeButton;
}

- (void)viewWillAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpServerFinishedSetup:) name:kPostNotificationNameServerFinishedSetup object:self.httpServer];
	self.lblServerStatus.text = @"Please wait...";
	[self.httpServer startUsingServer];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kPostNotificationNameServerFinishedSetup object:self.httpServer];
	self.lblServerStatus.text = @"Closing server...";
	[self.httpServer stopUsingServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeButtonPressed:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (CWHTTPServer *)httpServer
{
	if (!_httpServer) {
		_httpServer = [[CWHTTPServer alloc] init];
	}
	return _httpServer;
}

- (void)httpServerFinishedSetup:(NSNotification *)notification
{
	BOOL isSuccess = [[[notification userInfo] objectForKey:kPostNotificationUserInfoKeyIsSuccess] boolValue];
	if (isSuccess) {
		self.lblServerStatus.text = [NSString stringWithFormat:@"Server is now ready: %@", [[notification userInfo] objectForKey:kPostNotificationUserInfoKeyIPAddress]];
	}
	else {
		if ([[notification userInfo] objectForKey:kPostNotificationUserInfoFailureReason]) {
			self.lblServerStatus.text = [NSString stringWithFormat:@"Failed setting up server: %@", [[notification userInfo] objectForKey:kPostNotificationUserInfoFailureReason]];
		}
		else {
			self.lblServerStatus.text = @"Failed setting up server.";
		}
	}
}

@end
