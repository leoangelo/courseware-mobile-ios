//
//  CWUtilities.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/16/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "CWUtilities.h"

@implementation CWUtilities

+ (NSBundle *)courseWareBundle
{
	NSArray *bundles = [[NSBundle mainBundle] pathsForResourcesOfType:@"bundle" inDirectory:@""];
	NSBundle *cwBundle = nil;
	
	// locate the bundle.
	for (NSString *bundlePath in bundles) {
		if ([bundlePath rangeOfString:@"Courseware"].location != NSNotFound) {
			cwBundle = [NSBundle bundleWithPath:bundlePath];
			break;
		}
	}
	return cwBundle;
}

+ (NSString *)documentRootPath
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0];
}

@end
