//
//  CWMessageToolbar.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/28/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWMessagingModel;

@interface CWMessageToolbar : UIToolbar

@property (nonatomic, weak) CWMessagingModel *model;

- (void)updateActionToolbar;

@end
