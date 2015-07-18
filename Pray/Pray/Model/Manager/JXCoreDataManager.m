
//
//  CoreDataManager.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "JXCoreDataManager.h"
#import "JXCoreDataManagerConfiguration.h"
#import "NSNotificationCenter+Extensions.h"
#import "NSFileManager+Extensions.h"
#import "JXManagedObject.h"

/*-----------------------------------------------------------------------------------------------------*/

@interface JXCoreDataManager ()
@property (unsafe_unretained, nonatomic) dispatch_queue_t backgroundQueue;

@end

/*-----------------------------------------------------------------------------------------------------*/

@implementation JXCoreDataManager
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize uiManagedObjectContext = __uiManagedObjectContext;
@synthesize backgroundManagedObjectContext = __backgroundManagedObjectContext;
@synthesize sandboxManagedObjectContext = __sandboxManagedObjectContext;
@synthesize backgroundQueue;

/*-----------------------------------------------------------------------------------------------------*/

#pragma mark - Instance
+ (JXCoreDataManager *)sharedInstance {
    static JXCoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JXCoreDataManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Lifecycle
- (void)dealloc {
    if (self.backgroundQueue)  {
        
        //ENABLE THIS WHEN SWITCHING TO IOS6 MIN
        
//#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
//#define NEEDS_DISPATCH_RETAIN_RELEASE 0
//#else                                         // iOS 5.X or earlier
//#define NEEDS_DISPATCH_RETAIN_RELEASE 1
//#endif
//#if NEEDS_DISPATCH_RETAIN_RELEASE
//        dispatch_release(self.backgroundQueue);
//#endif
        
        //dispatch_release(self.backgroundQueue);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    self = [super init];
    
    if (self) {
        NSString *queueIdentifier = [NSString stringWithFormat:@"%@.CoreDataBackgroundQueue", kJXCoreDataManager_ModelName];
        self.backgroundQueue =  dispatch_queue_create([queueIdentifier UTF8String], NULL);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextDidSaveNotification:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
    }
    
    return self;
}


#pragma mark - Accessors

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "FileMaster2000" in the user's Library directory.
- (NSURL *)coreDataFilesDirectory {
    NSURL *rootDirectory = [NSFileManager applicationSupportUrl];
    NSString *dataDir = [[rootDirectory path] stringByAppendingPathComponent: @"data"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataDir])
    {
        NSError *error = nil;
        if ([[NSFileManager defaultManager] createDirectoryAtPath:dataDir withIntermediateDirectories:YES
                                                       attributes:nil error:&error])
        {
            if (![NSFileManager addSkipBackupAttributeToItemAtPath:dataDir])
            {
                printFailPointAndAbort;
            }
        }
        else
        {
            printErrorAndAbort(error);
        }
    }
    NSURL *coreDataDirectory = [rootDirectory URLByAppendingPathComponent:[NSString stringWithFormat: @"data/%@.sqlite", kJXCoreDataManager_ModelName]];
    return coreDataDirectory;
}

/*-----------------------------------------------------------------------------------------------------*/

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel)
    {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kJXCoreDataManager_ModelName
                                              withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [self coreDataFilesDirectory];
    
    NSError *error = nil;
    
    NSDictionary *options = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], nil]
                                                        forKeys:[NSArray arrayWithObjects:NSMigratePersistentStoresAutomaticallyOption, NSInferMappingModelAutomaticallyOption, nil]];
    
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                    configuration:nil
                                                              URL:storeURL
                                                          options:options
                                                            error:&error])
    {
        printFail(@"could not create a persistent store coordinator.");
        printErrorAndAbort(error);
    }
    
    return __persistentStoreCoordinator;
}


//Returns the main UI managed object context for the application (which is already bound to the persistent store coordinator for the application.)
- (NSManagedObjectContext *)uiManagedObjectContext
{
    if (__uiManagedObjectContext)
    {
        return __uiManagedObjectContext;
    }
    
    __uiManagedObjectContext = [[NSManagedObjectContext alloc] init];
    __uiManagedObjectContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
    __uiManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    
    return __uiManagedObjectContext;
}

//Returns the the sandbox managed object context for detached objects
- (NSManagedObjectContext *)sandboxManagedObjectContext
{
    if (__sandboxManagedObjectContext)
    {
        return __sandboxManagedObjectContext;
    }
    
    __sandboxManagedObjectContext = [[NSManagedObjectContext alloc] init];
    __sandboxManagedObjectContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
    
    return __sandboxManagedObjectContext;
}

//Returns the background managed object context for the application (used for persisting data)
- (NSManagedObjectContext *)backgroundManagedObjectContext
{
    if ([[NSThread currentThread] isMainThread])
    {
        printFailAndAbort(@"you should only call this method from a background thread.");
    }
    if (__backgroundManagedObjectContext)
    {
        return __backgroundManagedObjectContext;
    }
    
    __backgroundManagedObjectContext = [[NSManagedObjectContext alloc] init];
    __backgroundManagedObjectContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
    
    return __backgroundManagedObjectContext;
}

#pragma mark - Create

-(id) insertIntoContext:(NSManagedObjectContext *)context newManagedObjectNamed:(NSString *)name {
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];
}

- (void) insertIntoBackgroundContextNewManagedObjectNamed:(NSString *)name
                                   andPerformOnMainThread:(void (^)(id insertedObject))block
                                               shouldSave:(BOOL)shouldSave
                                         withNotification:(NSString *)notification
{
    if (![[NSThread currentThread] isMainThread])
    {
        printFailAndAbort(@"you should only call this method from a main thread!");
    }
    
    [self performChangesInBackgroundContext:^(NSManagedObjectContext *context) {
        JXManagedObject *backgroundObject = [self insertIntoContext:context newManagedObjectNamed:name];
        
        if (shouldSave)
        {
            [self saveCoreDataModelAndPostNotification:notification ? [NSNotification notificationWithName:notification
                                                                                                    object:backgroundObject.objectID] : nil];
        }
        
        if (block)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                JXManagedObject *foregroundObject = backgroundObject.uiObject;
                block(foregroundObject);
            });
        }
    }];
}

- (void) insertIntoBackgroundContextNewManagedObjectNamed:(NSString *)name
                         performChangesOnBackgroundThread:(void (^)(id backgroundObject))backgroundBlock
                                   andPerformOnMainThread:(void (^)(id insertedObject))foregroundBlock
                                               shouldSave:(BOOL)shouldSave
                                         withNotification:(NSString *)notification
{
    if (![[NSThread currentThread] isMainThread])
    {
        printFailAndAbort(@"you should only call this method from a main thread!");
    }
    
    [self performChangesInBackgroundContext:^(NSManagedObjectContext *context) {
        JXManagedObject *backgroundObject = [self insertIntoContext:context newManagedObjectNamed:name];
        if (backgroundBlock)
        {
            backgroundBlock(backgroundObject);
        }
        
        if (shouldSave)
        {
            [self saveCoreDataModelAndPostNotification:notification ? [NSNotification notificationWithName:notification
                                                                                                    object:backgroundObject.objectID] : nil];
        }
        
        if (foregroundBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                JXManagedObject *foregroundObject = backgroundObject.uiObject;
                foregroundBlock(foregroundObject);
            });
        }
    }];
}


#pragma mark - Read

- (JXManagedObject *) fetchUniqueManagedObjectOfClassName: (NSString *)name inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:name inManagedObjectContext:context];
    request.includesPendingChanges = YES;
    request.fetchBatchSize = 1;
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (error) {
        printFail(@"cannot fetch unique managed object named: %@", name);
        printError(error);
        return nil;
    } else if ([objects count] == 0) {
        return nil;
    } else if ([objects count] > 1) {
        printImportant(@"unique managed object fetch returned more than 1 result");
        printObject(objects);
    }
    
    return [objects objectAtIndex:0];
}

- (JXManagedObject *) fetchUniqueManagedObjectOfClassName: (NSString *)name withPredicate:(NSPredicate *)predicate inContext: (NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:name inManagedObjectContext:context];
    request.includesPendingChanges = YES;
    request.fetchBatchSize = 1;
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if (error) {
        printFail(@"cannot fetch unique managed object named: %@", name);
        printError(error);
        return nil;
    } else if ([objects count] == 0) {
        return nil;
    } else if ([objects count] > 1) {
        printImportant(@"unique managed object fetch returned more than 1 result");
        printObject(objects);
    }
    
    return [objects objectAtIndex:0];
}


- (NSArray *) fetchManagedObjectsOfClassName: (NSString *)name inContext: (NSManagedObjectContext *)context {
    NSFetchRequest *request = [self fetchRequestForClassName:name inContext:context];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (error) {
        printFail(@"cannot fetch unique managed object named: %@", name);
        printError(error);
        return nil;
    } else if ([objects count] == 0) {
        return nil;
    }
    
    return objects;
}

- (NSArray *) fetchManagedObjectsOfClassName: (NSString *)name withPredicate: (NSPredicate *)predicate inContext: (NSManagedObjectContext *)context {
    NSFetchRequest *request = [self fetchRequestForClassName:name withPredicate:predicate inContext:context];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if (error)
    {
        printFail(@"cannot fetch unique managed object named: %@", name);
        printError(error);
        return nil;
    }
    else if ([objects count] == 0)
    {
        return nil;
    }
    
    return objects;
}

- (NSArray *) fetchManagedObjectsOfClassName: (NSString *)name
                               withPredicate: (NSPredicate *)predicate
                          andSortDescriptors: (NSArray *)sortDescriptors
                                   inContext: (NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self fetchRequestForClassName:name
                                               withPredicate:predicate
                                          andSortDescriptors:sortDescriptors
                                                   inContext:context];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if (error)
    {
        printFail(@"cannot fetch unique managed object named: %@", name);
        printError(error);
        return nil;
    }
    else if ([objects count] == 0)
    {
        return nil;
    }
    
    return objects;
}


//requests
- (NSFetchRequest *)fetchRequestForClassName: (NSString *)name inContext: (NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:name inManagedObjectContext:context];
    request.includesPendingChanges = YES;
    return request;
}

- (NSFetchRequest *) fetchRequestForClassName: (NSString *)name withPredicate: (NSPredicate *)predicate
                                    inContext: (NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:name inManagedObjectContext:context];
    request.includesPendingChanges = YES;
    request.predicate = predicate;
    
    return request;
}

- (NSFetchRequest *) fetchRequestForClassName: (NSString *)name
                                withPredicate: (NSPredicate *)predicate
                           andSortDescriptors: (NSArray *)sortDescriptors
                                    inContext: (NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:name
                                 inManagedObjectContext:context];
    request.includesPendingChanges = YES;
    request.predicate = predicate;
    request.sortDescriptors = sortDescriptors;
    
    return request;
}

#pragma mark - Update

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (void) saveCoreDataModelAndPostNotification:(NSNotification *)notification
{
    if ([[NSThread currentThread] isMainThread])
    {
        printFailAndAbort(@"you cannot save a background a context on a main thread!");
    }
    
    NSError *backgroundError = nil;
    if ([__backgroundManagedObjectContext hasChanges])
    {
        //save background context
        if ([__backgroundManagedObjectContext save:&backgroundError])
        {
            if (notification)
            {
                [NSNotificationCenter postNotificationOnMainThread:notification];
            }
        }
        else
        {
            printFail(@"Failed to save the background managed object context.");
            printThreadInfo;
            printErrorAndAbort(backgroundError);
        }
        
    }
    else
    {
        if (notification)
        {
            [NSNotificationCenter postNotificationOnMainThread:notification];
        }
    }
}

- (void)contextDidSaveNotification:(NSNotification *)notification
{
    NSManagedObjectContext *savedContext = [notification object];
    
    // ignore change notifications for the main MOC
    if (__backgroundManagedObjectContext == savedContext)
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [__uiManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        });
    }
}

#pragma mark - Delete
- (void) deleteObjectFromBackgroundContext: (JXManagedObject *)object
                    andPerformOnMainThread:(void (^)())block
                                shouldSave:(BOOL)shouldSave
                          withNotification:(NSString *)notification
{
    [self performChangesInBackgroundContext:^(NSManagedObjectContext *context) {
        JXManagedObject *backgroundObject = object.backgroundObject;
        if (!backgroundObject)
        {
            if (block)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            }
            return;
        }
        [self.backgroundManagedObjectContext deleteObject:backgroundObject];
        
        if (shouldSave)
        {
            [self saveCoreDataModelAndPostNotification:notification ? [NSNotification notificationWithName:notification
                                                                                                    object:object.objectID] : nil];
        }
        
        if (block)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        }
    }];
}

#pragma mark - Revert
- (void)revertMainContext {
    [self revertContext:self.uiManagedObjectContext];
}

- (void)revertBackgroundContext {
    [self revertContext:self.backgroundManagedObjectContext];
}
- (void)revertContext:(NSManagedObjectContext *)aContext {
    [aContext rollback];
}

- (void)reverObjectInMainContext:(JXManagedObject *)anObject {
    [self revertObject:anObject inContext:self.uiManagedObjectContext];
}

- (void)revertObjectInBackgroundContext:(JXManagedObject *)anObject {
    [self revertObject:anObject inContext:self.backgroundManagedObjectContext];
}

- (void)revertObject:(JXManagedObject *)anObject
           inContext:(NSManagedObjectContext *)aContext {
    [aContext refreshObject:anObject mergeChanges:FALSE];
}

- (void)undoLastAction {
    [self.backgroundManagedObjectContext undo];
}

#pragma mark - Async
- (void) performChangesInBackgroundContext:(void (^)(NSManagedObjectContext *context))block {
    if (block)
    {
        dispatch_async(self.backgroundQueue, ^{
            block(self.backgroundManagedObjectContext);
        });
    }
    else
    {
        printFailAndAbort(@"You are passing a null block as a parameter!!!");
    }
}

#pragma mark - JSON

- (void) mergeJSONDictionary:(NSDictionary *)dictionary
        toManagedObjectNamed:(NSString *)className
          usingIdentifierKey:(NSString *)identifierKey
           JSONIdentifierKey:(NSString *)jsonIdentifierKey
         andPostNotification:(NSString *)notificationString
{
    if (!className.isValidString)
    {
        printFail(@"there is no class given to merge dictionary data to! recieved dictionary ->");
        printObject(dictionary);
        return;
    }
    
    dispatch_async(self.backgroundQueue, ^{
        NSManagedObjectContext *context = self.backgroundManagedObjectContext;
        id uniqueIdentifier = dictionary[jsonIdentifierKey];
        JXManagedObject *object = nil;
        if (uniqueIdentifier)
        {
            object = (JXManagedObject *)[self fetchUniqueManagedObjectOfClassName:className
                                                                    withPredicate:[NSPredicate predicateWithFormat:@"%K == %@", identifierKey, uniqueIdentifier]
                                                                        inContext:context];
        }
        else
        {
            printImportant(@"the returned JSON object has no unique identifier. new object will be inserted into context");
        }
        
        if (!object)
        {
            object = (JXManagedObject *)[self insertIntoContext:context
                                          newManagedObjectNamed:className];
        }
        
        NSDictionary *objectData = [self cleanJSONData:dictionary];
        for(NSString *key in objectData.allKeys)
        {
            id value = [objectData objectForKey:key];
            
            if([value isValidObject]) {
                if([value isKindOfClass:[NSString class]])
                {
                    if(![(NSString *)value isValidString])
                    {
                        continue;
                    }
                }
                
                [object setValue:value forKey:key];
            }
        }
        
        NSNotification *notification = nil;
        if (notificationString.isValidString)
        {
            notification = [NSNotification notificationWithName:notificationString
                                                         object:uniqueIdentifier
                                                       userInfo:@{kJXCoreDataManager_mergeJSONClassKey : className}];
        }
        
        [self saveCoreDataModelAndPostNotification:notification];
    });
}

- (void) mergeJSONArray:(NSArray *)array
   toManagedObjectNamed:(NSString *)className
     usingIdentifierKey:(NSString *)identifierKey
      JSONIdentifierKey:(NSString *)jsonIdentifierKey
    andPostNotification:(NSString *)notificationString
{
    if (!className.isValidString)
    {
        printFail(@"there is no class given to merge array data to! recieved array ->");
        printObject(array);
        return;
    }
    
    dispatch_async(self.backgroundQueue, ^{
        NSManagedObjectContext *context = self.backgroundManagedObjectContext;
        id nextObject = nil;
        NSMutableArray *uniqueIdentifierArray = [NSMutableArray array];
        NSEnumerator *resultsEnum = [array objectEnumerator];
        while (nextObject = [resultsEnum nextObject]) {
            if ([nextObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary = (NSDictionary *)nextObject;
                id uniqueIdentifier = dictionary[jsonIdentifierKey];
                JXManagedObject *object = nil;
                if (uniqueIdentifier)
                {
                    [uniqueIdentifierArray addObject:uniqueIdentifier];
                    object = (JXManagedObject *)[self fetchUniqueManagedObjectOfClassName:className
                                                                            withPredicate:[NSPredicate predicateWithFormat:@"%K == %@", identifierKey, uniqueIdentifier]
                                                                                inContext:context];
                }
                else
                {
                    printImportant(@"the returned JSON object has no unique identifier. new object will be inserted into context");
                }
                
                if (!object)
                {
                    object = (JXManagedObject *)[self insertIntoContext:context
                                                  newManagedObjectNamed:className];
                }

                NSDictionary *objectData = [self cleanJSONData:dictionary];
                for(NSString *key in objectData.allKeys)
                {
                    id value = [objectData objectForKey:key];
                    
                    if([value isValidObject])
                    {
                        if([value isKindOfClass:[NSString class]])
                        {
                            if(![(NSString *)value isValidString])
                            {
                                continue;
                            }
                        }
                        
                        [object setValue:value forKey:key];
                    }
                }
            }
            else
            {
                printFail(@"unknown object passed to merge method! will ignore");
                printObject(nextObject);
            }
        }
        
        NSNotification *notification = nil;
        if (notificationString.isValidString)
        {
            notification = [NSNotification notificationWithName:notificationString
                                                         object:uniqueIdentifierArray
                                                       userInfo:@{kJXCoreDataManager_mergeJSONClassKey : className}];
        }
        
        [self saveCoreDataModelAndPostNotification:notification];
    });
}

- (void) mergeJSONSubDictionary:(NSDictionary *)dictionary
           toManagedObjectNamed:(NSString *)className
             usingIdentifierKey:(NSString *)identifierKey
              JSONIdentifierKey:(NSString *)jsonIdentifierKey
{
    NSManagedObjectContext *context = self.backgroundManagedObjectContext;
    id uniqueIdentifier = dictionary[jsonIdentifierKey];
    JXManagedObject *object = nil;
    if (uniqueIdentifier)
    {
        object = (JXManagedObject *)[self fetchUniqueManagedObjectOfClassName:className
                                                                withPredicate:[NSPredicate predicateWithFormat:@"%K == %@", identifierKey, uniqueIdentifier]
                                                                    inContext:context];
    }
    else
    {
        printImportant(@"the returned JSON object has no unique identifier. new object will be inserted into context");
    }
    
    if (!object)
    {
        object = (JXManagedObject *)[self insertIntoContext:context
                                      newManagedObjectNamed:className];
    }
    
    NSDictionary *objectData = [self cleanJSONData:dictionary];
    for(NSString *key in objectData.allKeys)
    {
        id value = [objectData objectForKey:key];
        
        if([value isValidObject])
        {
            if([value isKindOfClass:[NSString class]])
            {
                if(![(NSString *)value isValidString])
                {
                    continue;
                }
            }
            
            [object setValue:value forKey:key];
        }
    }
}

- (void) mergeJSONSubArray:(NSArray *)array
      toManagedObjectNamed:(NSString *)className
        usingIdentifierKey:(NSString *)identifierKey
         JSONIdentifierKey:(NSString *)jsonIdentifierKey
{
    NSManagedObjectContext *context = self.backgroundManagedObjectContext;
    id nextObject = nil;
    NSEnumerator *resultsEnum = [array objectEnumerator];
    while (nextObject = [resultsEnum nextObject]) {
        if ([nextObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionary = (NSDictionary *)nextObject;
            id uniqueIdentifier = dictionary[jsonIdentifierKey];
            JXManagedObject *object = nil;
            if (uniqueIdentifier)
            {
                object = (JXManagedObject *)[self fetchUniqueManagedObjectOfClassName:className
                                                                        withPredicate:[NSPredicate predicateWithFormat:@"%K == %@", identifierKey, uniqueIdentifier]
                                                                            inContext:context];
            }
            else
            {
                printImportant(@"the returned JSON object has no unique identifier. new object will be inserted into context");
            }
            
            if (!object)
            {
                object = (JXManagedObject *)[self insertIntoContext:context
                                              newManagedObjectNamed:className];
            }

            NSDictionary *objectData = [self cleanJSONData:dictionary];
            for(NSString *key in objectData.allKeys)
            {
                id value = [objectData objectForKey:key];
                
                if([value isValidObject])
                {
                    if([value isKindOfClass:[NSString class]])
                    {
                        if(![(NSString *)value isValidString])
                        {
                            continue;
                        }
                    }
                    
                    [object setValue:value forKey:key];
                }
            }
        }
        else
        {
            printFail(@"unknown object passed to merge method! will ignore");
            printObject(nextObject);
        }
    }
}

- (NSDictionary *)cleanJSONData:(NSDictionary *)dictionary {
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    NSMutableArray *removeKeys = [[NSMutableArray alloc] init];
    
    for(NSString *key in data.allKeys) {
        if([[data objectForKey:key] isEqual:[NSNull null]]) {
            [removeKeys addObject:key];
        }
    }
    
    for(NSString *key in removeKeys) {
        [data removeObjectForKey:key];
    }
    
    
    return data;
}

@end
