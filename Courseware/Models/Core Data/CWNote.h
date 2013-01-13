//
//  CWNote.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 1/13/13.
//  Copyright (c) 2013 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CWNote : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * noteId;
@property (nonatomic, retain) NSString * subject;

@end
