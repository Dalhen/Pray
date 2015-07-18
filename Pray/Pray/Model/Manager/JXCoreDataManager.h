//
//  CoreDataManager.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#define kJXCoreDataManager_sandboxManagedObjectContextDidClearNotification @"kJXCoreDataManager_sandboxManagedObjectContextDidClearNotification"
#define kJXCoreDataManager_mergeJSONClassKey @"kJXCoreDataManager_mergeJSONClassKey"

/*-----------------------------------------------------------------------------------------------------*/

@class JXManagedObject;

@interface JXCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong, nonatomic) NSManagedObjectContext *uiManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *sandboxManagedObjectContext;

@property (readonly, unsafe_unretained, nonatomic) dispatch_queue_t backgroundQueue;


#pragma mark - Instance
+ (JXCoreDataManager *)sharedInstance;

#pragma mark - Accessors
- (NSURL *)coreDataFilesDirectory;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectContext *)uiManagedObjectContext;
- (NSManagedObjectContext *)backgroundManagedObjectContext;
- (NSManagedObjectContext *)sandboxManagedObjectContext;
- (dispatch_queue_t) backgroundQueue;

#pragma mark - Create
- (id) insertIntoContext: (NSManagedObjectContext *)context newManagedObjectNamed:(NSString *)name;
- (void) insertIntoBackgroundContextNewManagedObjectNamed:(NSString *)name
                                   andPerformOnMainThread:(void (^)(id insertedObject))block
                                               shouldSave:(BOOL)shouldSave
                                         withNotification:(NSString *)notification;
- (void) insertIntoBackgroundContextNewManagedObjectNamed:(NSString *)name
                         performChangesOnBackgroundThread:(void (^)(id backgroundObject))backgroundBlock
                                   andPerformOnMainThread:(void (^)(id insertedObject))foregroundBlock
                                               shouldSave:(BOOL)shouldSave
                                         withNotification:(NSString *)notification;

#pragma mark - Read
- (id) fetchUniqueManagedObjectOfClassName: (NSString *)name
                                 inContext: (NSManagedObjectContext *)context;
- (id) fetchUniqueManagedObjectOfClassName: (NSString *)name
                             withPredicate: (NSPredicate *)predicate
                                 inContext: (NSManagedObjectContext *)context;

- (NSArray *) fetchManagedObjectsOfClassName: (NSString *)name
                                   inContext: (NSManagedObjectContext *)context;
- (NSArray *) fetchManagedObjectsOfClassName: (NSString *)name
                               withPredicate: (NSPredicate *)predicate
                                   inContext: (NSManagedObjectContext *)context;
- (NSArray *) fetchManagedObjectsOfClassName: (NSString *)name
                               withPredicate: (NSPredicate *)predicate
                          andSortDescriptors: (NSArray *)sortDescriptors
                                   inContext: (NSManagedObjectContext *)context;

- (NSFetchRequest *)fetchRequestForClassName: (NSString *)name
                                   inContext: (NSManagedObjectContext *)context;
- (NSFetchRequest *) fetchRequestForClassName: (NSString *)name
                                withPredicate: (NSPredicate *)predicate
                                    inContext: (NSManagedObjectContext *)context;
- (NSFetchRequest *) fetchRequestForClassName: (NSString *)name
                                withPredicate: (NSPredicate *)predicate
                           andSortDescriptors: (NSArray *)sortDescriptors
                                    inContext: (NSManagedObjectContext *)context;


#pragma mark - Update
- (void) saveCoreDataModelAndPostNotification:(NSNotification *)notification;

#pragma mark - Delete
- (void) deleteObjectFromBackgroundContext: (JXManagedObject *)object
                    andPerformOnMainThread:(void (^)())block
                                shouldSave:(BOOL)shouldSave
                          withNotification:(NSString *)notification;

#pragma mark - Revert
- (void)revertMainContext;
- (void)revertBackgroundContext;
- (void)revertContext:(NSManagedObjectContext *)aContext;

- (void)reverObjectInMainContext:(JXManagedObject *)anObject;
- (void)revertObjectInBackgroundContext:(JXManagedObject *)anObject;;
- (void)revertObject:(JXManagedObject *)anObject
           inContext:(NSManagedObjectContext *)aContext;

- (void)undoLastAction;

#pragma mark - Async
- (void) performChangesInBackgroundContext:(void (^)(NSManagedObjectContext *context))block;

#pragma mark - JSON
- (void) mergeJSONDictionary:(NSDictionary *)dictionary toManagedObjectNamed:(NSString *)className usingIdentifierKey:(NSString *)identifierKey JSONIdentifierKey:(NSString *)jsonIdentifierKey andPostNotification:(NSString *)notificationString;
- (void) mergeJSONArray:(NSArray *)array toManagedObjectNamed:(NSString *)className usingIdentifierKey:(NSString *)identifierKey JSONIdentifierKey:(NSString *)jsonIdentifierKey andPostNotification:(NSString *)notificationString;
- (void) mergeJSONSubDictionary:(NSDictionary *)dictionary toManagedObjectNamed:(NSString *)className usingIdentifierKey:(NSString *)identifierKey JSONIdentifierKey:(NSString *)jsonIdentifierKey;
- (void) mergeJSONSubArray:(NSArray *)array toManagedObjectNamed:(NSString *)className usingIdentifierKey:(NSString *)identifierKey JSONIdentifierKey:(NSString *)jsonIdentifierKey;



@end
