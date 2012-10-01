//
//  CWCoreDataManager.m
//  Courseware
//
//  Created by Leo Angelo Quigao on 9/8/12.
//  Copyright (c) 2012 Leo Angelo Quigao. All rights reserved.
//

#import "SLCoreDataManager.h"

@interface SLCoreDataManager ()

+ (NSURL *)applicationDocumentsDirectory;

@end

@implementation SLCoreDataManager

- (void)dealloc
{
	[super dealloc];
}

- (id)init
{
	self = [super init];
	if (self) {
		
	}
	return self;
}

#pragma mark - Save & Fetch

- (NSArray *)fetchObjectsWithClass:(Class)theClass withPredicate:(NSPredicate *)thePredicate
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(theClass) inManagedObjectContext:[[self class] sharedContext]];
	
	[request setEntity:entity];
	
	if (thePredicate) {
		[request setPredicate:thePredicate];
	}
	
	NSError *error;
	NSArray *ret = [[[self class] sharedContext] executeFetchRequest:request error:&error];
	if (!ret) {
		NSLog(@"error: %@", error);
	}
	
	[request release];
	
	return ret;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [[self class] sharedContext];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (id)createNewObjectWithClass:(Class)theClass
{
	return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(theClass) inManagedObjectContext:[[self class] sharedContext]];
}

- (void)deleteObject:(NSManagedObject *)object
{
	[[[self class] sharedContext] deleteObject:object];
	[self saveContext];
}

- (void)clearAllObjectsOnClass:(Class)theClass
{
	NSArray *allObjects = [self fetchObjectsWithClass:theClass withPredicate:nil];
	for (NSManagedObject *anObject in allObjects) {
		[[[self class] sharedContext] deleteObject:anObject];
	}
	[self saveContext];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
+ (NSManagedObjectContext *)sharedContext
{
	static NSManagedObjectContext *aContext = nil;
	@synchronized([NSManagedObjectContext class]) {
		if (!aContext) {
			aContext = [[NSManagedObjectContext alloc] init];
			[aContext setPersistentStoreCoordinator:[self sharedStoreCoordinator]];
		}
	}
	return aContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
+ (NSManagedObjectModel *)sharedObjectModel
{
	static NSManagedObjectModel *aModel = nil;
	@synchronized([NSManagedObjectModel class]) {
		if (!aModel) {
			NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Courseware" withExtension:@"momd"];
			aModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
		}
	}
	return aModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
+ (NSPersistentStoreCoordinator *)sharedStoreCoordinator
{
	static NSPersistentStoreCoordinator *aCoordinator = nil;
	@synchronized([NSPersistentStoreCoordinator class]) {
		if (!aCoordinator) {
			NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Courseware.sqlite"];
			NSError *error = nil;
			aCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self sharedObjectModel]];
			if (![aCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
				/*
				 Replace this implementation with code to handle the error appropriately.
				 
				 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				 
//				 Typical reasons for an error here include:
				 * The persistent store is not accessible;
				 * The schema for the persistent store is incompatible with current managed object model.
				 Check the error message to determine what the actual problem was.
				 
				 
				 If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
				 
				 If you encounter schema incompatibility errors during development, you can reduce their frequency by:
				 * Simply deleting the existing store:
				 [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
				 
				 * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
				 @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
				 
				 Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
				 
				 */
				NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
				abort();
			}

		}
	}
	return aCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
