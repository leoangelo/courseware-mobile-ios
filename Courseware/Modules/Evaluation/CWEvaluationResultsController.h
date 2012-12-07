//
//  CWEvaluationResultsController.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWEvaluationResultsView.h"

@protocol CWEvaluationResultsControllerDelegate <NSObject>

- (void)exitEvaluation;

@end

@interface CWEvaluationResultsController : NSObject

@property (nonatomic) BOOL hasPassed;
@property (nonatomic) CGFloat score;
@property (nonatomic, strong) NSArray *mistakes;
@property (nonatomic, weak) id<CWEvaluationResultsControllerDelegate> delegate;

- (CWEvaluationResultsView *)getView;
- (void)beginCountdown;

@end
