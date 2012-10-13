//
//  CWCourseManager.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CWCourseItem;
@interface CWCourseManager : NSObject

@property (nonatomic, strong) NSMutableArray *courseListing;

- (NSArray *)allLessons;
+ (CWCourseManager *)sharedManager;

@end
