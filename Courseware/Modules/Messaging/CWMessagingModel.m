//
//  CWMessagingModel.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWMessagingModel.h"
#import "CWMessagesManager.h"
#import "CWMessage.h"
#import "NSString+SLUtilities.h"

static NSString * kMenuList[] = { @"Compose", @"Inbox", @"Drafts", @"Sent", @"Trash" };

@interface CWMessagingModel ()

@property (nonatomic, strong) NSString *selectedItem;
@property (nonatomic, strong) NSMutableDictionary *messageListings; // identified by title, e.g. Inbox or Drafts
@property (nonatomic, strong) NSMutableSet *checkedMessageIndices;

@end

@implementation CWMessagingModel


- (id)init
{
	self = [super init];
	if (self) {
		
	}
	return self;
}

- (NSMutableSet *)checkedMessageIndices
{
	if (!_checkedMessageIndices) {
		_checkedMessageIndices = [[NSMutableSet alloc] init];
	}
	return _checkedMessageIndices;
}

- (void)refreshData
{
	NSArray *allMessages = [[CWMessagesManager sharedManager] allMessagesForActiveUser];
	NSMutableDictionary *aListings = [NSMutableDictionary dictionary];
	
	NSMutableArray *inboxListing = [NSMutableArray array];
	NSMutableArray *draftsListing = [NSMutableArray array];
	NSMutableArray *sentListing = [NSMutableArray array];
	NSMutableArray *trashListing = [NSMutableArray array];
	
	for (CWMessage *aMessage in allMessages) {
		
		CWMessageState aState = [[aMessage status] intValue];
		
		if ((aState & CWMessageTrashed) == CWMessageTrashed) {
			[trashListing addObject:aMessage];
		}
		else if ((aState & CWMessageStateSent) == CWMessageStateSent) {
			[sentListing addObject:aMessage];
		}
		else if ((aState & CWMessageStateDrafted) == CWMessageStateDrafted) {
			[draftsListing addObject:aMessage];
		}
		else {
			[inboxListing addObject:aMessage];
		}
	}
	
	[aListings setObject:inboxListing forKey:kMenuList[1]];
	[aListings setObject:draftsListing forKey:kMenuList[2]];
	[aListings setObject:sentListing forKey:kMenuList[3]];
	[aListings setObject:trashListing forKey:kMenuList[4]];
	
	[self.checkedMessageIndices removeAllObjects];
	self.messageListings = aListings;
}

- (NSArray *)mainMenuList
{
	return [NSArray arrayWithObjects:kMenuList count:5];
}

- (void)mainMenuItemSelected:(NSUInteger)index
{
	[self.checkedMessageIndices removeAllObjects];
	self.selectedMessage = nil;
	self.selectedItem = kMenuList[index];
}

- (void)setSelectedItem:(NSString *)selectedItem
{
	if (![selectedItem isEqualToString:_selectedItem]) {
		 _selectedItem = nil;
		_selectedItem = selectedItem;
		
		[self.delegate modelMainMenuSelectedItemChanged];
	}
}

- (NSArray *)messageListForCurrentSelection
{
	if (self.selectedItem) {
		return [self.messageListings objectForKey:self.selectedItem];
	}
	return [NSArray array]; // empty
}

- (CWMessage *)newBlankMessage
{
	CWMessage *newMessage = [[CWMessagesManager sharedManager] newBlankMessage];
	
	return newMessage;
}

- (void)setSelectedMessage:(CWMessage *)selectedMessage
{
	_selectedMessage = selectedMessage;
}

+ (BOOL)messageIsDrafted:(CWMessage *)theMessage
{
	return ([theMessage.status intValue] & CWMessageStateDrafted) == CWMessageStateDrafted;
}

+ (BOOL)messageIsSent:(CWMessage *)theMessage
{
	return ([theMessage.status intValue] & CWMessageStateSent) == CWMessageStateSent;
}

+ (BOOL)messageIsTrashed:(CWMessage *)theMessage
{
	return ([theMessage.status intValue] & CWMessageTrashed) == CWMessageTrashed;
}

+ (NSString *)formattedSender:(CWMessage *)theMessage
{
	BOOL isDrafted = [self messageIsDrafted:theMessage];
	BOOL isSent = [self messageIsSent:theMessage];
	NSString *senderString = (isDrafted || isSent) ? theMessage.receiver_email : theMessage.sender_email;
	NSString *blankString = (isDrafted || isSent) ? @"<No recipient>" : @"<No sender>";
	
	return [senderString isNotBlank] ? senderString : blankString;
}

+ (NSString *)formattedTitle:(CWMessage *)theMessage
{
	return [theMessage.title isNotBlank] ? theMessage.title : @"<No title>";
}

+ (NSString *)formattedDate:(CWMessage *)theMessage
{
	return [NSDateFormatter localizedStringFromDate:theMessage.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (void)markAsReadAction
{
	
}

- (void)sendAction
{
	[self.delegate modelNeedMessagePreProcess];
	self.selectedMessage.status = [NSNumber numberWithInt:CWMessageStateSent];
	[[CWMessagesManager sharedManager] saveContext];
	
	[self refreshData];
	[self.delegate modelMessageListingNeedsRefresh];
	[self.delegate modelFinishedMessageViewing];
}

- (void)saveAction
{
	[self.delegate modelNeedMessagePreProcess];
	self.selectedMessage.status = [NSNumber numberWithInt:CWMessageStateDrafted];
	[[CWMessagesManager sharedManager] saveContext];
	
	[self refreshData];
	[self.delegate modelMessageListingNeedsRefresh];
	[self.delegate modelFinishedMessageViewing];
}

- (void)discardAction
{
	[[CWMessagesManager sharedManager] deleteObject:self.selectedMessage];
	[[CWMessagesManager sharedManager] saveContext];
	
	[self refreshData];
	[self.delegate modelMessageListingNeedsRefresh];
	[self.delegate modelFinishedMessageViewing];
}

- (void)replyAction
{
	
}

- (void)forwardAction
{
	
}

- (void)deleteAction
{
	
}

- (void)restoreAction
{
	
}

- (void)toggleChecked:(NSInteger)rowIndex
{
	NSNumber *indexNum = [NSNumber numberWithInt:rowIndex];
	if ([self.checkedMessageIndices member:indexNum]) {
		[self.checkedMessageIndices removeObject:indexNum];
	}
	else {
		[self.checkedMessageIndices addObject:indexNum];
	}
	[self.delegate modelMessageListingNeedsRefresh];
}

- (BOOL)messageAtIndexIsChecked:(NSInteger)rowIndex
{
	return [self.checkedMessageIndices member:[NSNumber numberWithInt:rowIndex]] != nil;
}

@end
