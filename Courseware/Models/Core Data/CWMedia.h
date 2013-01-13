//
//  CWMedia.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 1/13/13.
//  Copyright (c) 2013 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CWMedia : NSManagedObject

@property (nonatomic, retain) NSDate * lastDateOpened;
@property (nonatomic, retain) NSString * mediaPath;

@end
