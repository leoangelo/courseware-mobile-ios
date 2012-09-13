//
//  CWCourseList.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWCourseList : NSObject

@property (nonatomic, assign) NSUInteger courseId;
@property (nonatomic, retain) NSString *courseTitle;
@property (nonatomic, retain) NSString *courseDescription;
@property (nonatomic, retain) NSArray *chapterList;

@end
