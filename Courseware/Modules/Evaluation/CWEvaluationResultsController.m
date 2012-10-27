//
//  CWEvaluationResultsController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWEvaluationResultsController.h"

@interface CWEvaluationResultsController ()

@property (nonatomic, strong) CWEvaluationResultsView *resultsView;

@end

@implementation CWEvaluationResultsController

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

@end
