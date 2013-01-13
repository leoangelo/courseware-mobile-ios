//
//  CWBookmark.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 1/13/13.
//  Copyright (c) 2013 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CWBookmark : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * fullFilePath;
@property (nonatomic, retain) NSNumber * pageNumber;
@property (nonatomic, retain) NSString * title;

@end
