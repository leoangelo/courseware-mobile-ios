//
//  CWNavigationBarController.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/19/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWNavigationBarController : NSObject

- (BOOL)shouldDisplayBackButton;
- (BOOL)shouldDisplayHomeButton;

- (BOOL)shouldDisplaySearchButton;
- (BOOL)shouldDisplaySortButton;

- (void)backButtonAction;
- (void)homeButtonAction;

@end
