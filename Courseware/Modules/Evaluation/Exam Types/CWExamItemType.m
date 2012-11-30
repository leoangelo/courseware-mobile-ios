//
//  CWExamItemType.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWExamItemType.h"

@interface CWExamItemType () {
	NSTimeInterval remainingTime;
}

@property (nonatomic, strong) NSTimer *testTimer;

- (void)updateTestTimer:(id)theTimer;

@end

@implementation CWExamItemType

- (void)dealloc
{
	[_testTimer invalidate];
	_delegate = nil;
}

- (void)beginExamTimer
{
	[self.testTimer invalidate];
	remainingTime = [self testDuration];
	[self updateTestTimer:self.testTimer];
	self.testTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateTestTimer:) userInfo:nil repeats:YES];
}

- (void)stopExamTimer
{
	[self.testTimer invalidate];
}

- (void)updateTestTimer:(id)theTimer
{
	if (remainingTime <= 0.f) {
		[self.delegate examItemDidFinishAnswering:self];
	}
	else {
		[self.delegate examItem:self timeExpired:remainingTime];
		remainingTime = remainingTime - 1.f;
	}
}

- (NSTimeInterval)testDuration
{
	return 20.f;
}

+ (id)mockQuestion
{
	return nil;
}

+ (id)mockQuestion2
{
	return nil;
}

+ (id)mockQuestion3
{
	return nil;
}

+ (id)mockQuestion4
{
	return nil;
}

+ (id)mockQuestion5
{
	return nil;
}

- (UIView *)getView
{
	return nil;
}

@end
