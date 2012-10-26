//
//  CWLibraryBrowserModel.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	CWLibrarySortOptionsByName,
	CWLibrarySortOptionsByType,
	CWLibrarySortOptionsByDateRead
} CWLibrarySortOptions;

@class CWLibraryMediaSupport;
@interface CWLibraryBrowserModel : NSObject

@property (nonatomic, strong) NSString *searchFilter;
@property (nonatomic) CWLibrarySortOptions sortOptions;

- (void)rescanMedia;
- (NSArray *)displayedMediaList;
- (void)didOpenMedia:(CWLibraryMediaSupport *)theMedium;

@end
