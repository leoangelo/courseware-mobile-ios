//
//  CWCourseListingViewController.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/11/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWCourseItem;

@interface CWCourseListingViewController : UIViewController

+ (CWCourseItem *)defaultSelectedItem;
- (id)initWithItem:(CWCourseItem *)selectedItem;

@end
