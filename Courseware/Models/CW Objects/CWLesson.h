//
//  CWLesson.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWCourseItem.h"

@class CWChapter;

@interface CWLesson : CWCourseItem

@property (nonatomic, retain) NSDate *lastDateRead;
@property (nonatomic, assign) NSUInteger lessonPage;

@end
