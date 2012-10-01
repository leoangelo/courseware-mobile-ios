//
//  CWMessage.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/30/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CWAccount;

@interface CWMessage : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * message_id;
@property (nonatomic, retain) NSString * receiver_email;
@property (nonatomic, retain) NSString * sender_email;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) CWAccount *account;

@end
