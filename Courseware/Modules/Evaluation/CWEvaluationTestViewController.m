//
//  CWEvaluationTestViewController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/10/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWEvaluationTestViewController.h"
#import "CWNavigationBar.h"
#import "SLSlideMenuView.h"

@interface CWEvaluationTestViewController ()

@property (nonatomic, weak) IBOutlet CWNavigationBar *navBar;

@end

@implementation CWEvaluationTestViewController


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
	[[SLSlideMenuView slideMenuView] attachToNavBar:self.navBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
