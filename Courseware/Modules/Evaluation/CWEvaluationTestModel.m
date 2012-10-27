//
//  CWEvaluationTestModel.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWEvaluationTestModel.h"

#import "CWExamTypeMatchingType.h"
#import "CWExamTypeTrueOrFalse.h"

@interface CWEvaluationTestModel () <CWExamItemTypeDelegate>

@property (nonatomic, strong) NSArray *questionList;
@property (nonatomic) NSInteger questionIndex;

- (void)buildList;
- (CGFloat)computeStudentScore;
- (BOOL)hasStudentPassedTest:(CGFloat)theScore;
- (NSArray *)collectStudentMistakes;

@end

@implementation CWEvaluationTestModel

- (void)dealloc
{
	_delegate = nil;
}

- (id)initWithDelegate:(id<CWEvaluationTestModelDelegate>)theDelegate
{
	self = [super init];
	if (self) {
		[self buildList];
		_delegate = theDelegate;
	}
	return self;
}

- (void)buildList
{
	CWExamItemType *q1 = [CWExamTypeTrueOrFalse mockQuestion];
	CWExamItemType *q2 = [CWExamTypeTrueOrFalse mockQuestion2];
	
	q1.delegate = self;
	q2.delegate = self;
	
	self.questionList = @[q1, q2];
	self.questionIndex = 0;
}

- (CWExamItemType *)currentQuestion
{
	return [self.questionList objectAtIndex:self.questionIndex];
}

- (CGFloat)computeStudentScore
{
	CGFloat totalScore = 0.f;
	for (CWExamItemType *anItem in self.questionList) {
		totalScore += anItem.score;
	}
	return totalScore / [self.questionList count];
}

- (BOOL)hasStudentPassedTest:(CGFloat)theScore
{
	return theScore >= 0.5f;
}

- (NSArray *)collectStudentMistakes
{
	NSMutableArray *mistakesQ = [NSMutableArray array];
	for (CWExamItemType *anItem in self.questionList) {
		if (anItem.score < 1.f) {
			[mistakesQ addObject:anItem.statement];
		}
	}
	return mistakesQ;
}

#pragma mark - Exam type delegate

- (void)examItemDidFinishAnswering:(CWExamItemType *)theItemType
{
	if (self.questionIndex == self.questionList.count - 1) {
		CGFloat score = [self computeStudentScore];
		BOOL passed = [self hasStudentPassedTest:score];
		NSArray *mistakes = [self collectStudentMistakes];
		[self.delegate evaluationFinishedPassed:passed score:score mistakes:mistakes];
	}
	else {
		self.questionIndex++;
		[self.delegate displayedQuestionNeedsUpdate];
	}
}

@end
