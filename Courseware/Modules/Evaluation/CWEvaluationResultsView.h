//
//  CWEvaluationResultsView.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWEvaluationResultsController;
@interface CWEvaluationResultsView : UIView

@property (nonatomic, weak) CWEvaluationResultsController *myController;

- (id)initWithController:(CWEvaluationResultsController *)theController;
- (void)showInView:(UIView *)theView;

- (void)switchToMistakesView:(BOOL)toMistakes;

- (void)updateRemainingTime:(int)remainingTime;

@end
