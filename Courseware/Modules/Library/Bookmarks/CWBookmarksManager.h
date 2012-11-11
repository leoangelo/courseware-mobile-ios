//
//  CWBookmarksManager.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/11/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "SLCoreDataManager.h"
#import "CWBookmark.h"

@interface CWBookmarksManager : SLCoreDataManager

+ (CWBookmarksManager *)sharedManager;
- (NSArray *)allBookmarks;

@end
