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

static NSString * kMenuList[] = { @"Compose", @"Inbox", @"Drafts", @"Sent", @"Trash" };

@interface CWMessagingModel ()

@property (nonatomic, retain) NSString *selectedItem;
@property (nonatomic, retain) NSMutableDictionary *messageListings; // identified by title, e.g. Inbox or Drafts

@end

@implementation CWMessagingModel

- (void)dealloc
{
	[_messageListings release];
	[_selectedItem release];
	[super dealloc];
}

- (id)init
{
	self = [super init];
	if (self) {
		
	}
	return self;
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
	
	self.messageListings = aListings;
}

- (NSArray *)mainMenuList
{
	return [NSArray arrayWithObjects:kMenuList count:5];
}

- (void)mainMenuItemSelected:(NSUInteger)index
{
	if (index > 0) {
		self.selectedItem = kMenuList[index];
	}
}

- (void)setSelectedItem:(NSString *)selectedItem
{
	if (![selectedItem isEqualToString:_selectedItem]) {
		[_selectedItem release]; _selectedItem = nil;
		[selectedItem retain];
		_selectedItem = selectedItem;
		
		[self.delegate mainMenuSelectedItemChanged];
	}
}

- (NSArray *)messageListForCurrentSelection
{
	if (self.selectedItem) {
		return [self.messageListings objectForKey:self.selectedItem];
	}
	return [NSArray array]; // empty
}

@end
