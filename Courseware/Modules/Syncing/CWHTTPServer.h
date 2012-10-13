//
//  CWHTTPServer.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/13/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "HTTPServer.h"

extern NSString * const kPostNotificationNameServerFinishedSetup;
extern NSString * const kPostNotificationUserInfoKeyIsSuccess;
extern NSString * const kPostNotificationUserInfoKeyIPAddress;
extern NSString * const kPostNotificationUserInfoFailureReason;

@interface CWHTTPServer : HTTPServer

- (void)startUsingServer;
- (void)stopUsingServer;

@end
