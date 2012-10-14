//
//  CWThemeManager.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/14/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	CWUserPrefsColorThemeDark,
	CWUserPrefsColorThemeLight
} CWUserPrefsColorTheme;

typedef enum {
	CWUserPrefsFontThemeSmall,
	CWUserPrefsFontThemeMedium,
	CWUserPrefsFontThemeLarge
} CWUserPrefsFontTheme;

extern NSString * const kPostNotificationCurrentThemeChanged;

@protocol CWThemeDelegate <NSObject>

- (void)updateFontAndColor;

@end

@interface CWThemeHelper : NSObject

@property (nonatomic) CWUserPrefsColorTheme colorTheme;
@property (nonatomic) CWUserPrefsFontTheme fontTheme;

+ (CWThemeHelper *)sharedHelper;

- (void)initializeThemePresets;

- (UIColor *)themedBackgroundColor;
- (UIImage *)themedAppLogo;
- (UIFont *)themedFont:(UIFont *)fromFont;
- (UIColor *)themedTextColorHighlighted:(BOOL)highlighted;

// convenience methods for registering observers
- (void)registerForThemeChanges:(id<CWThemeDelegate>)obj;
- (void)unregisterForThemeChanges:(id<CWThemeDelegate>)obj;

@end
