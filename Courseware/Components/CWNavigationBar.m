//
//  CWNavigationBar.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWNavigationBar.h"
#import "CWNavigationBarController.h"

@interface CWNavigationBar ()

@property (nonatomic, retain) CWNavigationBarController *controller;
@property (nonatomic, retain) UINavigationItem *navigationItem;

- (void)initializeItems;

@end

@implementation CWNavigationBar

- (void)dealloc
{
	[_controller release];
	[_navigationItem release];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self initializeItems];
    }
    return self;
}

- (void)awakeFromNib
{
	[self initializeItems];
}

- (void)initializeItems
{
	self.controller = [[[CWNavigationBarController alloc] init] autorelease];
	self.navigationItem = [[[UINavigationItem alloc] initWithTitle:@""] autorelease];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self.controller action:@selector(backButtonAction)];
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self.controller action:@selector(homeButtonAction)];
	
	NSMutableArray *leftItems = [[NSMutableArray alloc] init];
	
	if (self.controller.shouldDisplayBackButton) {
		[leftItems addObject:backButton];
	}
	if (self.controller.shouldDisplayHomeButton) {
		[leftItems addObject:homeButton];
	}
	
	self.navigationItem.leftBarButtonItems = leftItems;
	
	if (leftItems.count > 0) {
		[self pushNavigationItem:self.navigationItem animated:NO];
	}
	
	[backButton release];
	[homeButton release];
	[leftItems release];
}

@end
