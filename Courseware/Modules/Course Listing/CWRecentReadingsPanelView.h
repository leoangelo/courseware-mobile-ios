//
//  CWRecentReadingsPanelView.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWThemeHelper.h"

@class CWCourseItem;
@protocol CWRecentReadingsPanelViewDelegate <NSObject>

- (void)recentReadingSelectedCourseItem:(CWCourseItem *)theCourseItem;

@end

@interface CWRecentReadingsPanelView : UIView <CWThemeDelegate>

@property (nonatomic, weak) IBOutlet id<CWRecentReadingsPanelViewDelegate> delegate;

- (void)updateContent;

@end
