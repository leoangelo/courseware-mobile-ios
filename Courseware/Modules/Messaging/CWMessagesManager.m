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
	static dispatch_once_t pred = 0;
	__strong static CWMessagesManager *thisManager = nil;
	dispatch_once(&pred, ^{
		thisManager = [[CWMessagesManager alloc] init]; // or some other init method
	});
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
	NSString *sampleMessage = @"Congratulations on being qualified for the Management Level Course, RCBC wishes you a successful and enjoyable learning experience!";
	NSString *sampleTitle = @"Message from our Sponsors";
	
	// inbox
	[self createRandomMessageWithTitle:sampleTitle body:sampleMessage state:CWMessageStateUnread to:@"julian@alloylearning.net" from:@"sponsor1@gmail.com"];
	[self createRandomMessageWithTitle:sampleTitle body:sampleMessage state:CWMessageStateUnread to:@"julian@alloylearning.net" from:@"sponsor2@gmail.com"];
	[self createRandomMessageWithTitle:sampleTitle body:sampleMessage state:CWMessageStateRead to:@"julian@alloylearning.net" from:@"sponsor3@gmail.com"];
	
	// sent
	[self createRandomMessageWithTitle:@"sent 1" body:@"hello earth" state:CWMessageStateSent to:@"person1@gmail.com" from:@"leo.quigao@gmail.com"];
	[self createRandomMessageWithTitle:@"sent 2" body:@"hello mars" state:CWMessageStateSent to:@"person1@gmail.com" from:@"leo.quigao@gmail.com"];
	[self createRandomMessageWithTitle:@"sent 3" body:@"hello jupiter" state:CWMessageStateSent to:@"person2@gmail.com" from:@"leo.quigao@gmail.com"];
}

- (CWMessage *)newBlankMessage
{
	CWMessage *newMessage = [self createNewObjectWithClass:[CWMessage class]];
	newMessage.message_id = [NSString generateRandomString];
	newMessage.status = [NSNumber numberWithInt:CWMessageStateDrafted];
	newMessage.date = [NSDate date];
	
	CWAccount *activeAccount = [[CWAccountManager sharedManager] getActiveUserAccount];
	
	newMessage.account = activeAccount;
	[activeAccount addMessagesObject:newMessage];
	
	[self saveContext];
	
	return newMessage;
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

- (void)updateMessage:(CWMessage *)theMessage state:(CWMessageState)theState
{
	
}

@end
