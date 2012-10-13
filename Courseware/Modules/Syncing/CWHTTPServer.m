//
//  CWHTTPServer.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/13/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWHTTPServer.h"
#import "CWUtilities.h"
#import "CWIPAddressHelper.h"

NSString * const kPostNotificationNameServerFinishedSetup = @"PostNotificationNameServerFinishedSetup";
NSString * const kPostNotificationUserInfoKeyIsSuccess = @"PostNotificationUserInfoKeyIsSuccess";
NSString * const kPostNotificationUserInfoKeyIPAddress = @"PostNotificationUserInfoKeyIPAddress";
NSString * const kPostNotificationUserInfoFailureReason = @"PostNotificationUserInfoFailureReason";

@interface CWHTTPServer ()

- (void)installServerFiles;
+ (NSString *)serverDocumentRoot;

@end

@implementation CWHTTPServer

- (void)startUsingServer
{
	// Tell the server to broadcast its presence via Bonjour.
	// This allows browsers such as Safari to automatically discover our service.
	[self setType:@"_http._tcp."];
	
	// Normally there's no need to run our server on any specific port.
	// Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
	// However, for easy testing you may want force a certain port so you can just hit the refresh button.
	NSInteger aPort = 2249;
    [self setPort:aPort];
	
	[self installServerFiles];
	
	[self setDocumentRoot:[[self class] serverDocumentRoot]];
	
	NSError *error = nil;
	[self start:&error];
	
	NSString *ipAddress = [CWIPAddressHelper getIPAddress];
	ipAddress = [NSString stringWithFormat:@"http://%@:%i", ipAddress, aPort];
	
	NSMutableDictionary *notificationDict = [NSMutableDictionary dictionary];
	
	[notificationDict setObject:[NSNumber numberWithBool:error == nil] forKey:kPostNotificationUserInfoKeyIsSuccess];
	[notificationDict setObject:ipAddress forKey:kPostNotificationUserInfoKeyIPAddress];
	if (error && error.localizedDescription) {
		[notificationDict setObject:error.localizedDescription forKey:kPostNotificationUserInfoFailureReason];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kPostNotificationNameServerFinishedSetup object:self userInfo:notificationDict];
}

+ (NSString *)serverDocumentRoot
{
	NSString *aDocumentRoot = [CWUtilities documentRootPath];
	return aDocumentRoot;
}

- (void)installServerFiles
{
	// install index.html
	NSString *sourcePath = [[CWUtilities courseWareBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"web"];
	NSData *sourceData = [NSData dataWithContentsOfFile:sourcePath];
	
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *targetPath = [[[self class] serverDocumentRoot] stringByAppendingPathComponent:@"index.html"];
	
	if (![fileMgr fileExistsAtPath:targetPath]) {
		[fileMgr createFileAtPath:targetPath contents:sourceData attributes:nil];
	}
}

- (void)stopUsingServer
{
	[self stop:YES];
}

@end
