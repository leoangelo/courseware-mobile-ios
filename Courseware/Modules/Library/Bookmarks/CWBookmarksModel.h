//
//  CWBookmarksModel.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/11/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWBookmark.h"

@interface CWBookmarksModel : NSObject

- (void)refreshBookmarkList;
- (NSArray *)getAllBookmarks;
- (void)deleteBookmarkAtIndex:(NSUInteger)index;

- (void)bookmarkCurrentPage;
- (void)openBookmarkAtIndex:(NSInteger)index;

@end
