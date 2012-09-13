//
//  CWAccountManager.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLCoreDataManager.h"
	
#define ACCOUNT_ERR_DOMAIN @"accounts"
#define ACCOUNT_ERR_CODE_USER_NOT_FOUND 100
#define ACCOUNT_ERR_CODE_WRONG_PASSWORD 101
#define ACCOUNT_ERR_CODE_NO_ACTIVE_USER 102

@class Account;

@interface CWAccountManager : SLCoreDataManager

+ (CWAccountManager *)sharedManager;

- (Account *)getActiveUserAccount;

// Adding/Updating Accounts
- (void)createNewAccountUserName:(NSString *)userName
						password:(NSString *)password
						fullName:(NSString *)fullName
					emailAddress:(NSString *)emailAddress
					passwordHint:(NSString *)passwordHint;

// User Login
- (BOOL)loginUser:(NSString *)username
		 password:(NSString *)password
			error:(NSError **)error;

// User Account Management from Settings
- (NSString *)passwordHintForUsername:(NSString *)username;
- (BOOL)updateActiveUserPassword:(NSString *)oldPassword
					 newPassword:(NSString *)newPassword
					passwordHint:(NSString *)passwordHint
						   error:(NSError **)error;

@end
