//
//  CWAccount.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/29/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CWMessage;

@interface CWAccount : NSManagedObject

@property (nonatomic, strong) NSString * accountId;
@property (nonatomic, strong) NSString * emailAddress;
@property (nonatomic, strong) NSString * fullName;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * passwordHint;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSSet *messages;
@end

@interface CWAccount (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(CWMessage *)value;
- (void)removeMessagesObject:(CWMessage *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
