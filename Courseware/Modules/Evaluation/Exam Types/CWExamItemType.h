//
//  CWExamItemType.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/27/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CWExamItemTypeDelegate;

@interface CWExamItemType : NSObject

@property (nonatomic, strong) NSString *statement;
@property (nonatomic) CGFloat score; // 0 - 1
@property (nonatomic, weak) id<CWExamItemTypeDelegate> delegate;

// A set of predefined questions for testing.
+ (id)mockQuestion;
+ (id)mockQuestion2;
+ (id)mockQuestion3;
+ (id)mockQuestion4;
+ (id)mockQuestion5;

- (void)beginExamTimer;
- (void)stopExamTimer;

- (UIView *)getView;
- (NSTimeInterval)testDuration;

@end

@protocol CWExamItemTypeDelegate <NSObject>

- (void)examItemDidFinishAnswering:(CWExamItemType *)theItemType;
- (void)examItem:(CWExamItemType *)theItemType timeExpired:(NSTimeInterval)remainingTime duration:(NSTimeInterval)duration;

@end