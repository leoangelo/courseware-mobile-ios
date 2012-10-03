//
//  CWMessageDetailView.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWMessagingModel;

@interface CWMessageDetailView : UIView

@property (nonatomic, assign) CWMessagingModel *model;

- (void)refreshView;
- (void)preProcessMessage;

@end
