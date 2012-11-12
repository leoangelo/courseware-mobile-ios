//
//  CWMediaAttachment.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/13/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CWCourseItem;
@interface CWMediaAttachment : NSObject

@property (nonatomic, weak) CWCourseItem *parentItem;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) CGRect coordinates;

- (NSString *)fullFilePath;

@end
