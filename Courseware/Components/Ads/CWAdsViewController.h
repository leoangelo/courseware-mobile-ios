//
//  CWAdsViewController.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWAdsViewController : NSObject

- (void)showInterstitalAdsAnimated:(BOOL)isAnimated;
- (void)hideInterstitalAdsAnimated:(BOOL)isAnimated; // the ads also hide itself automatically after 5 seconds.

@end
