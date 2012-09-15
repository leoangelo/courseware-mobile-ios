//
//  CWCourseListingScreenModel.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/15/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CWCourseItem;

@interface CWCourseListingScreenModel : NSObject

@property (nonatomic, assign) CWCourseItem *selectedCourseItem;

- (NSArray *)getItemList;

@end
