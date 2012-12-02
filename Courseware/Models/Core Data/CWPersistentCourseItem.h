//
//  CWPersistentCourseItem.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 12/2/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CWPersistentCourseItem : NSManagedObject

@property (nonatomic, retain) NSString * courseId;
@property (nonatomic, retain) NSDate * lastDateRead;

@end
