//
//  CWBottomToolbarController.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/22/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWBottomToolbarController : NSObject

- (void)bookmarksAction:(id)target;
- (void)notesAction:(id)target;
- (void)testsAction:(id)target;

- (void)dismissAllActivePopups;

@end
