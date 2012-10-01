//
//  CWMessagesManager.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "SLCoreDataManager.h"

typedef enum {
	CWMessageStateUnread						= 1,
	CWMessageStateRead							= 2,
	CWMessageStateDrafted						= 4,
	CWMessageStateSent							= 8,
	CWMessageTrashed							= 16
} CWMessageState;

@class CWMessage;

@interface CWMessagesManager : SLCoreDataManager

+ (CWMessagesManager *)sharedManager;

- (NSArray *)allMessagesForActiveUser;
- (void)updateMessage:(CWMessage *)theMessage state:(CWMessageState)theState;

@end
