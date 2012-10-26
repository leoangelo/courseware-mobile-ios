//
//  CWLibraryMediaManager.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLCoreDataManager.h"

@class CWMedia;
@interface CWLibraryMediaManager : SLCoreDataManager

+ (CWLibraryMediaManager *)sharedManager;
+ (NSSet *)supportedFileTypes;

- (void)rescanMedia;
- (CWMedia *)mediaWithFileName:(NSString *)theFileName;

@end
