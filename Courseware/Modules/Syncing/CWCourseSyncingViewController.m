//
//  CWCourseSyncingViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/13/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseSyncingViewController.h"

@interface CWCourseSyncingViewController ()

@property (nonatomic, weak) IBOutlet UINavigationItem *navItem;

- (IBAction)closeButtonPressed:(id)sender;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeButtonPressed:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

@end
