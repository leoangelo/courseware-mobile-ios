//
//  CWLibraryBrowserModel.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWLibraryBrowserModel : NSObject

@property (nonatomic, strong) NSString *searchFilter;

- (void)rescanMedia;
- (NSArray *)displayedMediaList;

@end
