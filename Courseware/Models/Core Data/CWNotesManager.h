//
//  CWNotesManager.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/22/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "SLCoreDataManager.h"

@class CWNote;

@interface CWNotesManager : SLCoreDataManager

+ (CWNotesManager *)sharedManager;

- (NSArray *)allNotes;

- (CWNote *)createBlankNote;

- (void)updateNotesAsynchrous:(BOOL)asynchronous;

@end
