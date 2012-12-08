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
#import "CWUtilities.h"

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

+ (NSString *)messageFileNamePath:(NSString *)theFileName
{
	return [[CWUtilities courseWareBundle] pathForResource:theFileName ofType:@"txt" inDirectory:@"sample-data/messages"];
}

+ (NSString *)msgContent:(NSString *)theFileName
{
	return [NSString stringWithContentsOfFile:[self messageFileNamePath:theFileName] encoding:NSUTF8StringEncoding error:NULL];
}

- (void)constructSampleData
{
	NSString *receiverEmail = @"julian@alloylearning.net";
	NSString *sampleTitle = @"Sponsor's Message";
	
	// inbox
	// Alloy support
	[self createRandomMessageWithTitle:@"Welcome to Alloy!"
								  body:[self.class msgContent:@"Alloy Support"]
								 state:CWMessageStateUnread
									to:receiverEmail
								  from:@"Alloy Support"];
	
	// CTSI
	[self createRandomMessageWithTitle:sampleTitle
								  body:[self.class msgContent:@"CTSI"]
								 state:CWMessageStateUnread
									to:receiverEmail
								  from:@"CTSI"];
	
	[self createRandomMessageWithTitle:sampleTitle
								  body:[self.class msgContent:@"GLOBE"]
								 state:CWMessageStateUnread
									to:receiverEmail
								  from:@"GLOBE"];
	
	[self createRandomMessageWithTitle:sampleTitle
								  body:[self.class msgContent:@"MAGSAYSAY"]
								 state:CWMessageStateUnread
									to:receiverEmail
								  from:@"MAGSAYSAY"];
	
	[self createRandomMessageWithTitle:sampleTitle
								  body:[self.class msgContent:@"PHIL AIRLINES"]
								 state:CWMessageStateUnread
									to:receiverEmail
								  from:@"PHIL AIRLINES"];
	
	[self createRandomMessageWithTitle:sampleTitle
								  body:[self.class msgContent:@"PLDT"]
								 state:CWMessageStateUnread
									to:receiverEmail
								  from:@"PLDT"];
	
	[self createRandomMessageWithTitle:sampleTitle
								  body:[self.class msgContent:@"SAN MIGUEL"]
								 state:CWMessageStateUnread
									to:receiverEmail
								  from:@"SAN MIGUEL"];
	
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
