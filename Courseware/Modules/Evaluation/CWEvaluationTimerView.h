//
//  CWEvaluationTimerView.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 12/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWEvaluationTimerView : UIView
{
	NSTimeInterval remainingTime;
	NSTimeInterval totalTime;
}

- (void)updateRemainingTimeCounter:(NSTimeInterval)time total:(NSTimeInterval)total;

@end
