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

@property (nonatomic, retain) NSString * accountId;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * passwordHint;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *messages;
@end

@interface CWAccount (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(CWMessage *)value;
- (void)removeMessagesObject:(CWMessage *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
