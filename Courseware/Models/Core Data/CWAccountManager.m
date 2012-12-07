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
static NSString * kUserPrefsPersistentUserName = @"UserPrefsPersistentUserName";

@interface CWAccountManager ()

@property (nonatomic, strong) CWAccount *activeUserAccount;

- (void)insertTestUser;

@end

@implementation CWAccountManager
@synthesize activeUserAccount = _activeUserAccount;


+ (CWAccountManager *)sharedManager
{
	__strong static CWAccountManager *manager = nil;
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^{
		if (!manager) {
			manager = [[CWAccountManager alloc] init];
		}
	});
	return manager;
}

- (id)init
{
	self = [super init];
	if (self) {
		if (CLEARS_ON_STARTUP) {
			[self clearAllObjectsOnClass:[CWAccount class]];
		}
		NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
		if (INSERT_TEST_USER) {
			if (![userPrefs boolForKey:kSampleDataAddedFlag]) {
				[self insertTestUser];
				[userPrefs setBool:YES forKey:kSampleDataAddedFlag];
				[userPrefs synchronize];
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
	[self createNewAccountUserName:@"JGoitia"
						  password:@"123"
						  fullName:@"Julian Goitia"
					  emailAddress:@"julian@alloylearning.net"
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

- (BOOL)autoLoginSavedUser
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [defaults objectForKey:kUserPrefsPersistentUserName];
	if (username) {
		NSArray *accountsWithName = [self fetchObjectsWithClass:[CWAccount class] withPredicate:[NSPredicate predicateWithFormat:@"username == %@", username]];
		if (!accountsWithName || [accountsWithName count] == 0) {
			// User does not exist
			return NO;
		}
		self.activeUserAccount = [accountsWithName objectAtIndex:0];
		return YES;
	}
	return NO;
}

- (BOOL)loginUser:(NSString *)username
		 password:(NSString *)password
			error:(NSError **)error
  rememberAccount:(BOOL)shouldRemember
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
	
	// remember the user
	if (shouldRemember) {
		[[NSUserDefaults standardUserDefaults] setObject:username forKey:kUserPrefsPersistentUserName];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
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
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserPrefsPersistentUserName];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self setActiveUserAccount:nil];
}

@end
