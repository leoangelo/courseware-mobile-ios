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

- (UIFont *)themedFont:(UIFont *)fromFont
{
	CGFloat multiplier = 1.f;
	switch (self.fontTheme) {
		case CWUserPrefsFontThemeSmall: multiplier = 0.75f; break;
		case CWUserPrefsFontThemeMedium: multiplier = 1.f; break;
		case CWUserPrefsFontThemeLarge: multiplier = 1.5f; break;
	}
	return [UIFont fontWithName:fromFont.fontName size:fromFont.pointSize * multiplier];
}

- (UIColor *)themedBackgroundColor
{
	NSString *patternImageFile = nil;
	switch (self.colorTheme) {
		case CWUserPrefsColorThemeDark: patternImageFile = @"Courseware.bundle/bg-tile-dark.jpg"; break;
		case CWUserPrefsColorThemeLight: patternImageFile = @"Courseware.bundle/bg-tile-light.jpg"; break;
	}
	return [UIColor colorWithPatternImage:[UIImage imageNamed:patternImageFile]];
}

- (UIColor *)themedTextColorHighlighted:(BOOL)highlighted
{
	switch (self.colorTheme) {
		case CWUserPrefsColorThemeDark: return [UIColor colorWithWhite:highlighted ? 1.0 : 0.90 alpha:1];
		case CWUserPrefsColorThemeLight: return [UIColor colorWithWhite:highlighted ? 0.4 : 0.20 alpha:1];
	}
	return nil;
}

- (UIImage *)themedAppLogo
{
	NSString *logoFile = nil;
	switch (self.colorTheme) {
		case CWUserPrefsColorThemeDark: logoFile = @"Courseware.bundle/app-logo-dark.png"; break;
		case CWUserPrefsColorThemeLight: logoFile = @"Courseware.bundle/app-logo-light.png"; break;
	}
	return [UIImage imageNamed:logoFile];
}

@end
