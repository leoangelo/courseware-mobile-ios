//
//  CWBookmark.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 11/11/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CWBookmark : NSManagedObject

@property (nonatomic, retain) NSString * fullFilePath;
@property (nonatomic, retain) NSNumber * pageNumber;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * date;

@end
