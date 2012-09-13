//
//  CWCourseModule.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWCourseModule.h"

@implementation CWCourseModule

- (NSString *)description
{
	return [NSString stringWithFormat:@"Module title: %@; chapters: %@", self.title, self.children];
}

@end
