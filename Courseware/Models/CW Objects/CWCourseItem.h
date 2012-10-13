//
//  CWCourseReference.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kCourseItemId;
extern NSString * const kCourseItemTitle;
extern NSString * const kCourseItemDescription;

extern NSString * const kCourseItemLastDateRead;
extern NSString * const kCourseItemFilePath;
extern NSString * const kCourseItemPageNumber;

@interface CWCourseItem : NSObject

@property (nonatomic, weak) CWCourseItem *parent;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSMutableDictionary *data;

- (NSArray *)siblings;
- (NSInteger)depth;
- (CWCourseItem *)rootItem;

@end
