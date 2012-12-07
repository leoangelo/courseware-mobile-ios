//
//  CWGlobals.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 12/7/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWGlobals.h"

@implementation CWGlobals

+ (CWGlobals *)sharedInstance
{
	static CWGlobals *anInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		anInstance = [[CWGlobals alloc] init];
	});
	return anInstance;
}

- (id)init
{
	self = [super init];
	if (self) {
		_justLoggedIn = NO;
		_justLoggedOut = NO;
	}
	return self;
}

@end
