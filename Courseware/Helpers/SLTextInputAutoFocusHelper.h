//
//  SLTextInputAutoFocusHelper.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/7/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLTextInputAutoFocusHelper : NSObject

+ (void)beginAutoFocus;
+ (void)stopAutoFocus;

+ (void)centerActiveFirstResponder;

@end
