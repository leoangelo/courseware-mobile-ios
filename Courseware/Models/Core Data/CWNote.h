//
//  CWNote.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/17/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CWNote : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * noteId;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSDate * date;

@end
