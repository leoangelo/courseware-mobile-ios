//
//  CWNote.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/22/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CWNote : NSManagedObject

@property (nonatomic, strong) NSString * noteId;
@property (nonatomic, strong) NSString * subject;
@property (nonatomic, strong) NSString * body;

@end
