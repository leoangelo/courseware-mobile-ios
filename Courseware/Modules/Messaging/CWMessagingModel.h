//
//  CWMessagingModel.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CWMessage;
@protocol CWMessagingModelDelegate <NSObject>

@optional
- (void)modelMainMenuSelectedItemChanged;
- (void)modelNeedMessagePreProcess;
- (void)modelMessageListingNeedsRefresh;
- (void)modelFinishedMessageViewing;

@end

@interface CWMessagingModel : NSObject

@property (nonatomic, assign) id<CWMessagingModelDelegate> delegate;
@property (nonatomic, assign) CWMessage *selectedMessage;

- (void)refreshData;
- (NSArray *)mainMenuList;
- (NSArray *)messageListForCurrentSelection;
- (void)mainMenuItemSelected:(NSUInteger)index;

- (CWMessage *)newBlankMessage;

+ (BOOL)messageIsDrafted:(CWMessage *)theMessage;
+ (BOOL)messageIsSent:(CWMessage *)theMessage;
+ (BOOL)messageIsTrashed:(CWMessage *)theMessage;

- (void)sendAction;
- (void)saveAction;
- (void)discardAction;

- (void)replyAction;
- (void)forwardAction;
- (void)deleteAction;

- (void)restoreAction;

@end
