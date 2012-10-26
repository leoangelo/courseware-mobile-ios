//
//  CWMedia.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 10/26/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CWMedia : NSManagedObject

@property (nonatomic, retain) NSString * mediaPath;
@property (nonatomic, retain) NSDate * lastDateOpened;

@end
