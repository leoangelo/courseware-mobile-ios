//
//  CWBrowserPaneView.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWCourseItem;
@protocol CWBrowserPaneViewDelegate;

@interface CWBrowserPaneView : UIView

@property (nonatomic, weak) IBOutlet id<CWBrowserPaneViewDelegate> delegate;

- (void)setActiveItem:(CWCourseItem *)activeItem;

@end

@protocol CWBrowserPaneViewDelegate <NSObject>

- (void)browser:(CWBrowserPaneView *)browser selectedItem:(CWCourseItem *)item;

@end