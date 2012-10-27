//
//  CWExamTypeTrueOrFalse.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWExamTypeTrueOrFalse.h"
#import "CWExamTypeTrueOrFalseView.h"

@interface CWExamTypeTrueOrFalse ()

@property (nonatomic, strong) CWExamTypeTrueOrFalseView *myView;

@end

@implementation CWExamTypeTrueOrFalse

+ (id)mockQuestion
{
	CWExamTypeTrueOrFalse *mockQ = [[CWExamTypeTrueOrFalse alloc] init];
	mockQ.statement = @"The Earth is the largest planet in the Solar System.";
	mockQ.isStatementTrue = NO;
	return mockQ;
}

+ (id)mockQuestion2
{
	CWExamTypeTrueOrFalse *mockQ = [[CWExamTypeTrueOrFalse alloc] init];
	mockQ.statement = @"The Earth is the third closest planet to the Sun.";
	mockQ.isStatementTrue = YES;
	return mockQ;
}

- (UIView *)getView
{
	return self.myView;
}

- (CWExamTypeTrueOrFalseView *)myView
{
	if (!_myView) {
		_myView = [[CWExamTypeTrueOrFalseView alloc] initWithModel:self];
	}
	return _myView;
}

- (void)studentAnsweredTrue:(BOOL)isAnswerTrue
{
	self.score = (isAnswerTrue == self.isStatementTrue) ? 1.f : 0.f;
	[self.delegate examItemDidFinishAnswering:self];
}

@end
