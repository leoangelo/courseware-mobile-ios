//
//  CWThemeManager.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/14/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWThemeHelper.h"
#import "CWConstants.h"

static NSString * const kUserPrefsColorTheme = @"CWUserPrefsColorTheme";
static NSString * const kUserPrefsFontTheme = @"CWUserPrefsFontTheme";

NSString * const kPostNotificationCurrentThemeChanged = @"PostNotificationCurrentThemeChanged";

@interface CWThemeHelper ()

@end

@implementation CWThemeHelper

+ (CWThemeHelper *)sharedHelper
{
	__strong static CWThemeHelper *shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[CWThemeHelper alloc] init];
	});
	return shared;
}

- (void)initializeThemePresets
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (![defaults objectForKey:kUserPrefsColorTheme]) {
		self.colorTheme = CWUserPrefsColorThemeDark;
	}
	else {
		self.colorTheme = [defaults integerForKey:kUserPrefsColorTheme];
	}
	if (![defaults objectForKey:kUserPrefsFontTheme]) {
		self.fontTheme = CWUserPrefsFontThemeMedium;
	}
	else {
		self.fontTheme = [defaults integerForKey:kUserPrefsFontTheme];
	}
}

- (void)setColorTheme:(CWUserPrefsColorTheme)colorTheme
{
	if (_colorTheme == colorTheme) return;
	_colorTheme = colorTheme;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:colorTheme forKey:kUserPrefsColorTheme];
	[defaults synchronize];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kPostNotificationCurrentThemeChanged object:self];
}

- (void)setFontTheme:(CWUserPrefsFontTheme)fontTheme
{
	if (_fontTheme == fontTheme) return;
	_fontTheme = fontTheme;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:fontTheme forKey:kUserPrefsFontTheme];
	[defaults synchronize];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kPostNotificationCurrentThemeChanged object:self];
}

- (void)registerForThemeChanges:(id<CWThemeDelegate>)obj
{
	[[NSNotificationCenter defaultCenter] addObserver:obj selector:@selector(updateFontAndColor) name:kPostNotificationCurrentThemeChanged object:self];
}

- (void)unregisterForThemeChanges:(id<CWThemeDelegate>)obj
{
	[[NSNotificationCenter defaultCenter] removeObserver:obj name:kPostNotificationCurrentThemeChanged object:self];
}

- (void)updateBackgroundColor:(UIView *)view
{
	NSString *patternImageFile = nil;
	switch (self.colorTheme) {
		case CWUserPrefsColorThemeDark: patternImageFile = @"Courseware.bundle/bg-tile-dark.jpg"; break;
		case CWUserPrefsColorThemeLight: patternImageFile = @"Courseware.bundle/bg-tile-light.jpg"; break;
	}
	UIImage *patternImage = [UIImage imageNamed:patternImageFile];
	view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
}

@end
