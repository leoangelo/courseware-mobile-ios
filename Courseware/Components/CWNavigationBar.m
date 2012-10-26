//
//  CWNavigationBar.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWNavigationBar.h"
#import "CWNavigationBarController.h"
#import "CWThemeHelper.h"

@interface CWNavigationBar () <CWThemeDelegate>

@property (nonatomic, strong) CWNavigationBarController *controller;
@property (nonatomic, strong) UINavigationItem *navigationItem;

- (void)initializeItems;

@end

@implementation CWNavigationBar

- (void)dealloc
{
	[[CWThemeHelper sharedHelper] unregisterForThemeChanges:self];
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
	self.controller = [[CWNavigationBarController alloc] init];
	self.navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
	
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
	
	[self pushNavigationItem:self.navigationItem animated:NO];
		
	[[CWThemeHelper sharedHelper] registerForThemeChanges:self];
	[self updateFontAndColor];
}

- (void)setTitle:(NSString *)theTitle
{
	[self.navigationItem setTitle:theTitle];
}

- (void)setRightBarButtonItems:(NSArray *)theItems
{
	[self.navigationItem setRightBarButtonItems:theItems animated:NO];
}

- (void)updateFontAndColor
{
	self.barStyle = ([CWThemeHelper sharedHelper].colorTheme == CWUserPrefsColorThemeDark) ? UIBarStyleBlackOpaque : UIBarStyleDefault;
}

@end
