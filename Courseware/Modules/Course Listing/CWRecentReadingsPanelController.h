//
//  CWRecentReadingsPanelController.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWRecentReadingsPanelController : NSObject

- (void)rebuildLessonsIndex;
- (NSArray *)getRecentReads;

@end
