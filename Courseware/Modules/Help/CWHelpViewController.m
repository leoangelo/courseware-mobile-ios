//
//  CWHelpViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/7/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWHelpViewController.h"
#import "CWNavigationBar.h"
#import "SLSlideMenuView.h"
#import "CWUtilities.h"

static NSString * const kHelpHtml = @"Courseware.bundle/cw-help.html";

@interface CWHelpViewController ()

@property (nonatomic, strong) IBOutlet CWNavigationBar *navBar;
@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end

@implementation CWHelpViewController


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
	[[SLSlideMenuView slideMenuView] attachToNavBar:self.navBar];
	
	NSURL *url = [[CWUtilities courseWareBundle] URLForResource:@"cw-help" withExtension:@"html"];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30];
	[self.webView loadRequest:urlRequest];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	[self setNavBar:nil];
	[self setWebView:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
