//
//  SLSlideMenuController.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/10/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLSlideMenuController : NSObject

@property (nonatomic, strong) NSArray *menuItems;

- (void)didPressMenuItemAtIndex:(NSUInteger)theIndex;

@end

typedef enum {
	SLSlideMenuItemTypeTextAndIcon,
	SLSlideMenuItemTypeSeparator
} SLSlideMenuItemType;

@interface SLSlideMenuItem : NSObject

@property (nonatomic, strong) NSString *itemText;
@property (nonatomic, strong) UIImage *lightItemIcon;
@property (nonatomic, strong) UIImage *darkItemIcon;
@property (nonatomic, assign) SLSlideMenuItemType itemType;

+ (id)menuItemWithText:(NSString *)text lightIcon:(UIImage *)lightIcon darkIcon:(UIImage *)darkIcon;
+ (id)menuItemSeparator;

@end
