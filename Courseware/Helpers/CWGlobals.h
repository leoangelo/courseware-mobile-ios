//
//  CWGlobals.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 12/7/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWGlobals : NSObject

@property (nonatomic, assign) BOOL justLoggedIn;
@property (nonatomic, assign) BOOL justLoggedOut;

+ (CWGlobals *)sharedInstance;

@end
