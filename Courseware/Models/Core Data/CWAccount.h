//
//  CWAccount.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/16/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CWAccount : NSManagedObject

@property (nonatomic, retain) NSString * accountId;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * passwordHint;
@property (nonatomic, retain) NSString * username;

@end
