//
//  CWNotesDetailModel.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/22/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_TITLE @"No title"
#define DEFAULT_CONTENT @"No content"

@class CWNote;

@interface CWNotesDetailModel : NSObject

- (id)initWithNote:(CWNote *)theNote;

- (NSString *)getNoteTitle;
- (NSString *)getNoteContent;

- (void)updateNoteWithTitle:(NSString *)theTitle content:(NSString *)theContent;

@end
