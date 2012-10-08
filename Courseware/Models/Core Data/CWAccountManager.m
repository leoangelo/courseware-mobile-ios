//
//  CWAccountManager.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWAccountManager.h"
#import "CWAccount.h"
#import "NSString+SLUtilities.h"

#define CLEARS_ON_STARTUP 0
#define INSERT_TEST_USER 1

static NSString * kSampleDataAddedFlag = @"hasAccountSampleDataAdded";

@interface CWAccountManager ()

@property (nonatomic, retain) CWAccount *activeUserAccount;

- (void)insertTestUser;

@end

@implementation CWAccountManager
@synthesize activeUserAccount = _activeUserAccount;

- (void)dealloc
{
	[_activeUserAccount release];
	[super dealloc];
}

+ (CWAccountManager *)sharedManager
{
	static CWAccountManager *manager = nil;
	@synchronized([CWAccountManager class]) {
		if (!manager) {
			manager = [[CWAccountManager alloc] init];
		}
	}
	return manager;
}

- (id)init
{
	self = [super init];
	if (self) {
		if (CLEARS_ON_STARTUP) {
			[self clearAllObjectsOnClass:[CWAccount class]];
		}
		if (INSERT_TEST_USER) {
			if (![[NSUserDefaults standardUserDefaults] boolForKey:kSampleDataAddedFlag]) {
				[self insertTestUser];
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSampleDataAddedFlag];
				[[NSUserDefaults standardUserDefaults] synchronize];
			}
		}
	}
	return self;
}

- (CWAccount *)getActiveUserAccount
{
	return self.activeUserAccount;
}

#pragma mark - Testing

- (void)insertTestUser
{
	[self createNewAccountUserName:@"superlazyperson"
						  password:@"123"
						  fullName:@"Leo Angelo Quigao"
					  emailAddress:@"leo.quigao@gmail.com"
					  passwordHint:@"123"];
}

#pragma mark - Adding/Updating Accounts

- (void)createNewAccountUserName:(NSString *)userName
						password:(NSString *)password
						fullName:(NSString *)fullName
					emailAddress:(NSString *)emailAddress
					passwordHint:(NSString *)passwordHint
{
	CWAccount *newAccount = [self createNewObjectWithClass:[CWAccount class]];
	newAccount.accountId = [NSString generateRandomString];
	newAccount.username = userName;
	newAccount.password = password;
	newAccount.fullName = fullName;
	newAccount.emailAddress = emailAddress;
	newAccount.passwordHint = passwordHint;
	
	[self saveContext];
}

#pragma mark - User Login

- (BOOL)loginUser:(NSString *)username
		 password:(NSString *)password
			error:(NSError **)error
{	
	NSArray *accountsWithName = [self fetchObjectsWithClass:[CWAccount class] withPredicate:[NSPredicate predicateWithFormat:@"username == %@", username]];
	if (!accountsWithName || [accountsWithName count] == 0) {
		// User does not exist
		*error = [NSError errorWithDomain:ACCOUNT_ERR_DOMAIN code:ACCOUNT_ERR_CODE_USER_NOT_FOUND userInfo:nil];
		return NO;
	}
	CWAccount *accountWithName = [accountsWithName objectAtIndex:0];
	if (![accountWithName.password isEqualToString:password]) {
		// Password does not match
		*error = [NSError errorWithDomain:ACCOUNT_ERR_DOMAIN code:ACCOUNT_ERR_CODE_WRONG_PASSWORD userInfo:nil];
		return NO;
	}
	
	self.activeUserAccount = accountWithName;
	return YES;
}

#pragma mark - User Account Management from Settings

- (NSString *)passwordHintForUsername:(NSString *)username
{
	NSArray *accountsWithName = [self fetchObjectsWithClass:[CWAccount class] withPredicate:[NSPredicate predicateWithFormat:@"username == %@", username]];
	if (!accountsWithName || [accountsWithName count] == 0) {
		// User does not exist
		return nil;
	}
	return [(CWAccount *)[accountsWithName objectAtIndex:0] passwordHint];
}

- (BOOL)updateActiveUserPassword:(NSString *)oldPassword
					 newPassword:(NSString *)newPassword
					passwordHint:(NSString *)passwordHint
						   error:(NSError **)error
{
	if (!self.activeUserAccount) {
		// No active user account
		*error = [NSError errorWithDomain:ACCOUNT_ERR_DOMAIN code:ACCOUNT_ERR_CODE_NO_ACTIVE_USER userInfo:nil];
		return NO;
	}
	if (![oldPassword isEqualToString:self.activeUserAccount.password]) {
		// Old password does not match input
		*error = [NSError errorWithDomain:ACCOUNT_ERR_DOMAIN code:ACCOUNT_ERR_CODE_WRONG_PASSWORD userInfo:nil];
		return NO;
	}
	self.activeUserAccount.password = newPassword;
	self.activeUserAccount.passwordHint = passwordHint;
	[self saveContext];
	return YES;
}

- (void)logoutUser
{
	[self setActiveUserAccount:nil];
}

@end
