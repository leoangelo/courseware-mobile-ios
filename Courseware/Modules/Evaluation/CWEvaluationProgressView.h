//
//  CWEvaluationProgressView.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/21/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CWEvaluationProgressViewDataSource <NSObject>

- (NSInteger)currentItemIndex;
- (NSInteger)totalNumberOfItems;

@end

@interface CWEvaluationProgressView : UIView

@property (nonatomic, weak) IBOutlet id<CWEvaluationProgressViewDataSource> dataSource;

@end
