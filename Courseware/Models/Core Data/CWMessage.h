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

@property (nonatomic, strong) NSString * body;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSString * message_id;
@property (nonatomic, strong) NSString * receiver_email;
@property (nonatomic, strong) NSString * sender_email;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) CWAccount *account;

@end
