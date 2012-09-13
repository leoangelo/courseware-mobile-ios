//
//  CWChapter.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWChapter.h"

@implementation CWChapter

- (void)dealloc
{
	[_chapterPath release];
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Chapter title: %@; lessons: %@", self.title, self.children];
}

@end
