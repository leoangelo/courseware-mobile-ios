//
//  CWExamItemType.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWExamItemType.h"

@implementation CWExamItemType

- (void)dealloc
{
	_delegate = nil;
}

+ (id)mockQuestion
{
	return nil;
}

+ (id)mockQuestion2
{
	return nil;
}

- (UIView *)getView
{
	return nil;
}

@end
