//
//  CWMessagesManager.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWMessagesManager.h"
#import "CWMessage.h"
#import "NSString+SLUtilities.h"
#import "CWAccountManager.h"
#import "CWAccount.h"

static NSString * kSampleDataAddedFlag = @"hasMessagesSampleDataAdded";

@interface CWMessagesManager ()

- (void)constructSampleData;
- (void)createRandomMessageWithTitle:(NSString *)title body:(NSString *)body state:(CWMessageState)state to:(NSString *)to from:(NSString *)from;

@end

@implementation CWMessagesManager

+ (CWMessagesManager *)sharedManager
{
	static CWMessagesManager *thisManager = nil;
	@synchronized([self class]) {
		if (!thisManager) {
			thisManager = [[CWMessagesManager alloc] init];
		}
	}
	return thisManager;
}

- (id)init
{
	self = [super init];
	if (self) {
		if (![[NSUserDefaults standardUserDefaults] boolForKey:kSampleDataAddedFlag]) {
			[self constructSampleData];
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSampleDataAddedFlag];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
	return self;
}

- (NSArray *)allMessagesForActiveUser
{
	CWAccount *activeAccount = [[CWAccountManager sharedManager] getActiveUserAccount];
	return [activeAccount.messages allObjects];
}

- (void)constructSampleData
{
	// inbox
	[self createRandomMessageWithTitle:@"inbox 1" body:@"hello sun" state:CWMessageStateUnread to:@"leo.quigao@gmail.com" from:@"person1@gmail.com"];
	[self createRandomMessageWithTitle:@"inbox 2" body:@"hello merc" state:CWMessageStateUnread to:@"leo.quigao@gmail.com" from:@"person1@gmail.com"];
	[self createRandomMessageWithTitle:@"inbox 3" body:@"hello venus" state:CWMessageStateRead to:@"leo.quigao@gmail.com" from:@"person2@gmail.com"];
	
	// sent
	[self createRandomMessageWithTitle:@"sent 1" body:@"hello earth" state:CWMessageStateSent to:@"person1@gmail.com" from:@"leo.quigao@gmail.com"];
	[self createRandomMessageWithTitle:@"sent 2" body:@"hello mars" state:CWMessageStateSent to:@"person1@gmail.com" from:@"leo.quigao@gmail.com"];
	[self createRandomMessageWithTitle:@"sent 3" body:@"hello jupiter" state:CWMessageStateSent to:@"person2@gmail.com" from:@"leo.quigao@gmail.com"];
}

- (void)createRandomMessageWithTitle:(NSString *)title body:(NSString *)body state:(CWMessageState)state to:(NSString *)to from:(NSString *)from
{
	CWMessage *newMessage = [self createNewObjectWithClass:[CWMessage class]];
	newMessage.message_id = [NSString generateRandomString];
	newMessage.title = title;
	newMessage.body = body;
	newMessage.status = [NSNumber numberWithInt:state];
	newMessage.sender_email = from;
	newMessage.receiver_email = to;
	newMessage.date = [NSDate date];
	
	CWAccount *activeAccount = [[CWAccountManager sharedManager] getActiveUserAccount];
	
	newMessage.account = activeAccount;
	[activeAccount addMessagesObject:newMessage];
	
	[self saveContext];
}

@end
