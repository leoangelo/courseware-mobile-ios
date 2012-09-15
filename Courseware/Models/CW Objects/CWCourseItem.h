//
//  CWCourseReference.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWCourseItem : NSObject

@property (nonatomic, retain) NSString *referenceId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *referenceDescription;
@property (nonatomic, retain) NSArray *objectives;
@property (nonatomic, assign) CWCourseItem *parent;
@property (nonatomic, retain) NSArray *children;

- (NSArray *)siblings;

@end
