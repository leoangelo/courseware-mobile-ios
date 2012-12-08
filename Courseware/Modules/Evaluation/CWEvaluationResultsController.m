//
//  CWEvaluationResultsController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWEvaluationResultsController.h"

static NSTimeInterval const kReviewTimerDuration = 60.f;

@interface CWEvaluationResultsController () {
	NSTimeInterval remainingTime;
}

@property (nonatomic, strong) CWEvaluationResultsView *resultsView;
@property (nonatomic, strong) NSTimer *reviewTimer;

@end

@implementation CWEvaluationResultsController

- (void)dealloc
{
	[_reviewTimer invalidate];
}

- (CWEvaluationResultsView *)resultsView
{
	if (!_resultsView) {
		_resultsView = [[CWEvaluationResultsView alloc] initWithController:self];
	}
	return _resultsView;
}

- (CWEvaluationResultsView *)getView
{
	return self.resultsView;
}

- (void)beginCountdown
{
	remainingTime = kReviewTimerDuration;
	[self.getView updateRemainingTime:remainingTime];
	self.reviewTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}

- (void)updateTimer:(id)theTimer
{
	if (remainingTime <= 0.f) {
		[self.delegate exitEvaluation];
	}
	else {
		[self.getView updateRemainingTime:remainingTime];
		remainingTime = remainingTime - 1.f;
	}
}

@end
