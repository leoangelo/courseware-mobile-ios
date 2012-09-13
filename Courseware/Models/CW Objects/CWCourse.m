//
//  CWCourse.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourse.h"

@implementation CWCourse

- (NSString *)description
{
	return [NSString stringWithFormat:@"Course title: %@; modules: %@", self.title, self.children];
}

@end
