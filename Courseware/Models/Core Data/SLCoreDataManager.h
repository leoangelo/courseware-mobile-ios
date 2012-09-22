//
//  CWCoreDataManager.h
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLCoreDataManager : NSObject

- (id)createNewObjectWithClass:(Class)theClass;
- (NSArray *)fetchObjectsWithClass:(Class)theClass withPredicate:(NSPredicate *)thePredicate;
- (void)saveContext;

- (void)deleteObject:(NSManagedObject *)object;
- (void)clearAllObjectsOnClass:(Class)theClass;

@end
