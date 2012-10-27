//
//  CWEvaluationTestModel.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CWExamItemType;
@protocol CWEvaluationTestModelDelegate <NSObject>

- (void)displayedQuestionNeedsUpdate;
- (void)evaluationFinishedPassed:(BOOL)hasPassed score:(CGFloat)theScore mistakes:(NSArray *)mistakes;

@end

@interface CWEvaluationTestModel : NSObject

@property (nonatomic, weak) id<CWEvaluationTestModelDelegate> delegate;

- (id)initWithDelegate:(id<CWEvaluationTestModelDelegate>)theDelegate;

- (CWExamItemType *)currentQuestion;

@end

