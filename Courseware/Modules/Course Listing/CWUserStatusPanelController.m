//
//  CWUserStatusPanelController.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/9/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWUserStatusPanelController.h"
#import "CWAccountManager.h"
#import "CWAccount.h"

@implementation CWUserStatusPanelController

- (NSString *)getUserName
{
	return [[[CWAccountManager sharedManager] getActiveUserAccount] username];
}
- (NSString *)getFullName
{
	return [[[CWAccountManager sharedManager] getActiveUserAccount] fullName];
}

- (NSString *)getSchoolName
{
	return @"Alloy Learning";
}

- (NSString *)getProgramName
{
	return @"Management Level Course";
}

@end
