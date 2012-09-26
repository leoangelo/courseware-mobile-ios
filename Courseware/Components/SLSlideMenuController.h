//
//  SLSlideMenuController.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/10/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLSlideMenuController : NSObject

@property (nonatomic, retain) NSArray *menuItems;

- (void)didPressMenuItemAtIndex:(NSUInteger)theIndex;

@end

typedef enum {
	SLSlideMenuItemTypeTextAndIcon,
	SLSlideMenuItemTypeSeparator
} SLSlideMenuItemType;

@interface SLSlideMenuItem : NSObject

@property (nonatomic, retain) NSString *itemText;
@property (nonatomic, retain) UIImage *itemIcon;
@property (nonatomic, assign) SLSlideMenuItemType itemType;

+ (id)menuItemWithText:(NSString *)text icon:(UIImage *)icon;
+ (id)menuItemSeparator;

@end
