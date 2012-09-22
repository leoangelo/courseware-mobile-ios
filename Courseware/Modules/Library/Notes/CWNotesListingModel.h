//
//  CWNotesListingModel.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/22/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWNotesListingModel : NSObject

- (NSArray *)getAllNotes;
- (void)rebuildList;
- (void)deleteNoteAtIndex:(NSInteger)theIndex;

@end
