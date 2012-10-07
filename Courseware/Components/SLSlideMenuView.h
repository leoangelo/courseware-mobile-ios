//
//  SLSlideMenuView.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/10/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLSlideMenuView : UIView

@property (nonatomic, assign) BOOL sticky;

+ (id)slideMenuView;
- (void)attachToNavBar:(UINavigationBar *)navBar;

@end
