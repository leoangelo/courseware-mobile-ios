//
//  CWExamItemType.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWExamItemType.h"
#import <QuartzCore/QuartzCore.h>

@interface CWExamItemType () {
	NSTimeInterval remainingTime;
	NSTimeInterval lastTimeStamp;
}

@property (nonatomic, strong) CADisplayLink *testTimer;

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
	// [self updateTestTimer:self.testTimer];
	
	lastTimeStamp = 0.f;
	self.testTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTestTimer:)];
	[self.testTimer setFrameInterval:1];
	[self.testTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopExamTimer
{
	[self.testTimer invalidate];
}

- (void)updateTestTimer:(CADisplayLink *)theTimer
{
	if (lastTimeStamp != 0.f) {
		NSTimeInterval timeElapsed = theTimer.timestamp - lastTimeStamp;
		if (remainingTime <= 0.f) {
			[self.delegate examItemDidFinishAnswering:self];
		}
		else {
			[self.delegate examItem:self timeExpired:remainingTime duration:self.testDuration];
			remainingTime = remainingTime - timeElapsed;
		}
	}
	lastTimeStamp = theTimer.timestamp;
}

- (NSTimeInterval)testDuration
{
	return 10.f;
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
