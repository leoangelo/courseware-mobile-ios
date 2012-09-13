//
//  CWChapter.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWCourseItem.h"

@class CWCourseModule;

@interface CWChapter : CWCourseItem

@property (nonatomic, retain) NSString *chapterPath;
@property (nonatomic, getter = isAvailable) BOOL available;

@end
