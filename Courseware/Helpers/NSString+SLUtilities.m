//
//  NSString+SLUtilities.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "NSString+SLUtilities.h"

@implementation NSString (SLUtilities)

+ (NSString *)generateRandomString
{
	NSTimeInterval timeStamp = CFAbsoluteTimeGetCurrent();
	NSInteger randomNumber = arc4random() % 999;
	return [NSString stringWithFormat:@"%f~%i", timeStamp, randomNumber];
}

- (NSString *)trim
{
	// This does not trim multiple whitespaces in between words.
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isNotBlank
{
	return [[self trim] length] > 0;
}

@end
