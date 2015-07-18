//
//  JXBaseManagedObject.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "JXManagedObject.h"
#import "JXIndexedManagedObject.h"
#import <objc/runtime.h>

/*-----------------------------------------------------------------------------------------------------*/

@implementation JXManagedObject
@synthesize originalManagedObjectId;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - class utitlity
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (JXManagedObject *)detachedObject
{
    NSManagedObjectContext *context = [CoreDataManager sandboxManagedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[self className]
                                                         inManagedObjectContext:context];
	return [[self alloc] initWithEntity:entityDescription
         insertIntoManagedObjectContext:context];
}

+ (NSString *)className
{
    return NSStringFromClass([self class]);
}

- (void)awakeFromFetch {
    [super awakeFromFetch];
    [self setup];
    [self setupValidation];
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    [self setup];
    [self setupValidation];
}

- (void)setup {
    validationBlocks = [[NSMutableDictionary alloc] init];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ordering
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)orderedItems:(NSSet *)items {
	[items makeObjectsPerformSelector:@selector(checkIndex)];
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:TRUE];
	NSArray *orderedItems = [items sortedArrayUsingDescriptors:@[descriptor]];
	
	return orderedItems;
}

- (NSNumber *)nextIndex:(NSSet *)items {
    if (items.count == 0)
    {
        return [NSNumber numberWithLongLong:0];
    }
    [items makeObjectsPerformSelector:@selector(checkIndex)];
    NSNumber *highestIndex = [items valueForKeyPath:@"@max.index"];
    return [NSNumber numberWithLongLong:highestIndex.longLongValue+1];
}

- (void)reorderIndexes:(NSSet *)items {
    if ([self.managedObjectContext isEqual:CoreDataManager.uiManagedObjectContext])
    {
        printFailAndAbort(@"you cannot edit object values from a main thread. please make sure that you are calling this method using the background core data queue");
    }
    
    JXManagedObject *backgroundObject;
    if (self.isBackgroundObject)
    {
        backgroundObject = self;
    }
    else
    {
        backgroundObject = self.backgroundObject;
    }
    
    [items makeObjectsPerformSelector:@selector(checkIndex)];
    NSArray *orderedItems = [backgroundObject orderedItems:items];
    int index = 0;
    for (CMIndexedManagedObject *object in orderedItems)
    {
        if (object.index.longLongValue != index)
        {
            object.index = [NSNumber numberWithLongLong:index];
        }
        index++;
    }
}

- (void)checkIndex {
	if(![self respondsToSelector:@selector(index)]) {
		printFailAndAbort(@"Object is not indexed: %@", [[self class] className]);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - context management
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isBackgroundObject
{
    if(self.managedObjectContext == CoreDataManager.backgroundManagedObjectContext) {
        return YES;
    }
    return NO;
}

- (BOOL)isUiObject
{
    if(self.managedObjectContext == CoreDataManager.uiManagedObjectContext) {
        return YES;
    }
    return NO;
}

- (BOOL)isDetachedObject
{
    if(self.managedObjectContext == CoreDataManager.sandboxManagedObjectContext) {
        return YES;
    }
    return NO;
}

- (id)backgroundObject {
    if(self.isBackgroundObject) {
        return self;
    }
    
    NSManagedObjectID *identifierToFetch = nil;
    if (self.isDetachedObject)
    {
        if (self.originalManagedObjectId)
        {
            identifierToFetch = self.originalManagedObjectId;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        identifierToFetch = self.objectID;
    }
    
    JXManagedObject *backgroundObject = (JXManagedObject *)[CoreDataManager.backgroundManagedObjectContext objectWithID:identifierToFetch];
    return backgroundObject;
}

- (id)uiObject
{
    if(self.isUiObject) {
        return self;
    }
    
    NSManagedObjectID *identifierToFetch = nil;
    if (self.isDetachedObject)
    {
        if (self.originalManagedObjectId)
        {
            identifierToFetch = self.originalManagedObjectId;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        identifierToFetch = self.objectID;
    }
    
    JXManagedObject *uiObject = (JXManagedObject *)[CoreDataManager.uiManagedObjectContext objectWithID:self.originalManagedObjectId ? self.originalManagedObjectId : identifierToFetch];
    return uiObject;
}

- (void)addToContext:(NSManagedObjectContext *)context
andPerformOnMainThread:(void (^)(id insertedObject))foregroundBlock
          shouldSave:(BOOL)shouldSave
    withNotification:(NSString *)notification
{
    if (![self.managedObjectContext isEqual:CoreDataManager.sandboxManagedObjectContext])
    {
        printFailAndAbort(@"NSManagedObject (%@) already has been assigned a context!", [[self class] className]);
        return;
    }
    
    if ([[NSThread currentThread] isMainThread])
    {
        [CoreDataManager performChangesInBackgroundContext:^(NSManagedObjectContext *context) {
            [context insertObject:self];
            if (shouldSave)
            {
                [CoreDataManager saveCoreDataModelAndPostNotification: notification ? [NSNotification notificationWithName:notification
                                                                                                                    object:self.objectID] : nil];
            }
            if (foregroundBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    JXManagedObject *foregroundObject = self.uiObject;
                    foregroundBlock(foregroundObject);
                });
            }
        }];
    }
    else
    {
        [context insertObject:self];
        if (shouldSave)
        {
            [CoreDataManager saveCoreDataModelAndPostNotification: notification ? [NSNotification notificationWithName:notification
                                                                                                                object:self.objectID] : nil];
        }
        if (foregroundBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                JXManagedObject *foregroundObject = self.uiObject;
                foregroundBlock(foregroundObject);
            });
        }
    }
}


- (void)editInBackgroundContext:(void (^)(id backgroundObject))backgroundBlock
         andPerformOnMainThread:(void (^)(id insertedObject))foregroundBlock
                     shouldSave:(BOOL)shouldSave
               withNotification:(NSString *)notification

{
    if ([[NSThread currentThread] isMainThread])
    {
        [CoreDataManager performChangesInBackgroundContext:^(NSManagedObjectContext *context) {
            [self editBackgroundObject:self.backgroundObject
                             withBlock:backgroundBlock
                andPerformOnMainThread:foregroundBlock
                            shouldSave:shouldSave
                      withNotification:notification];
        }];
    }
    else
    {
        [self editBackgroundObject:self.backgroundObject
                         withBlock:backgroundBlock
            andPerformOnMainThread:foregroundBlock
                        shouldSave:shouldSave
                  withNotification:notification];
    }
}

- (void)persistAndPostNotification:(NSNotification *)notification
            andPerformOnMainThread:(void (^)(id insertedObject))foregroundBlock

{
    if ([[NSThread currentThread] isMainThread])
    {
        [CoreDataManager performChangesInBackgroundContext:^(NSManagedObjectContext *context) {
            [CoreDataManager saveCoreDataModelAndPostNotification:notification];
            if (foregroundBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    JXManagedObject *foregroundObject = self.uiObject;
                    foregroundBlock(foregroundObject);
                });
            }
        }];
    }
    else
    {
        [CoreDataManager saveCoreDataModelAndPostNotification:notification];
        if (foregroundBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                JXManagedObject *foregroundObject = self.uiObject;
                foregroundBlock(foregroundObject);
            });
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private methods
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)editBackgroundObject:(JXManagedObject *)backgroundObject
                  withBlock:(void (^)(JXManagedObject *backgroundObject))backgroundBlock
     andPerformOnMainThread:(void (^)(id insertedObject))foregroundBlock
                 shouldSave:(BOOL)shouldSave
           withNotification:(NSString *)notification
{
    backgroundBlock(backgroundObject);
    if (shouldSave)
    {
        [CoreDataManager saveCoreDataModelAndPostNotification: notification ? [NSNotification notificationWithName:notification
                                                                                                            object:self.objectID] : nil];
    }
    
    if (foregroundBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            JXManagedObject *foregroundObject = self.uiObject;
            foregroundBlock(foregroundObject);
        });
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - cloning
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(id)detachedCloneWithRelationshipKeys:(NSSet *)relationshipKeys
{
    if ([self.managedObjectContext isEqual:CoreDataManager.sandboxManagedObjectContext])
    {
        return self;
    }
    
    if (!relationshipKeys)
    {
        relationshipKeys = [NSSet set];
    }
    
    NSString *entityName = [self.class className];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:entityName
                                              inManagedObjectContext:CoreDataManager.uiManagedObjectContext];
    
    JXManagedObject *cloned = [self.class detachedObject];
    
    //attributes
    NSDictionary *attributes = [entityDescription attributesByName];
    for (NSString *attr in attributes) {
        [cloned setValue:[self valueForKey:attr] forKey:attr];
    }
    
    //relationship.
    NSDictionary *relationships = [entityDescription relationshipsByName];
    for (NSRelationshipDescription *rel in relationships){
        NSString *keyName = [NSString stringWithFormat:@"%@",rel];
        if ([relationshipKeys containsObject:keyName])
        {
            NSMutableSet *sourceSet = [self mutableSetValueForKey:keyName];
            NSMutableSet *clonedSet = [cloned mutableSetValueForKey:keyName];
            
            NSEnumerator *e = [sourceSet objectEnumerator];
            NSManagedObject *relatedObject;
            while ( relatedObject = [e nextObject])
            {
                NSManagedObject *clonedRelatedObject = [(JXManagedObject *)relatedObject detachedCloneWithRelationshipKeys:nil];
                [clonedSet addObject:clonedRelatedObject];
            }
        }
    }
    cloned.originalManagedObjectId = self.objectID;
    return cloned;
}

-(void)reattachCloneToBackgroundContextWithRelationshipKeys:(NSSet *)relationshipKeys
                                              deletableKeys:(NSSet *)deletableKeys
                                     andPerformOnMainThread:(void (^)(id insertedObject))foregroundBlock
                                                 shouldSave:(BOOL)shouldSave
                                           withNotification:(NSString *)notification
{
    if (![self.managedObjectContext isEqual:CoreDataManager.sandboxManagedObjectContext])
    {
        printFail(@"the object calling this method is not a valid detached object");
    }
    
    if (!relationshipKeys)
    {
        relationshipKeys = [NSSet set];
    }
    if (!deletableKeys)
    {
        deletableKeys = [NSSet set];
    }
    
    [self editInBackgroundContext:^(id backgroundObject) {
        
        [self reattachCloneDataWithRelationshipKeys:relationshipKeys
                                      deletableKeys:deletableKeys
                                 toBackgroundObject:backgroundObject];
    }
           andPerformOnMainThread:foregroundBlock
                       shouldSave:shouldSave
                 withNotification:notification];
}

-(void)reattachCloneDataWithRelationshipKeys:(NSSet *)relationshipKeys
                               deletableKeys:(NSSet *)deletableKeys
                          toBackgroundObject:(id)backgroundObject
{
    if (!relationshipKeys)
    {
        relationshipKeys = [NSSet set];
    }
    if (!deletableKeys)
    {
        deletableKeys = [NSSet set];
    }
    
    if(!backgroundObject) {
        backgroundObject = [CoreDataManager insertIntoContext:CoreDataManager.backgroundManagedObjectContext newManagedObjectNamed:[[self class] className]];
    }
    
    NSString *entityName = [self.class className];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:entityName
                                              inManagedObjectContext:CoreDataManager.backgroundManagedObjectContext];
    
    //attributes
    NSDictionary *attributes = [entityDescription attributesByName];
    for (NSString *attr in attributes) {
        [backgroundObject setValue:[self valueForKey:attr] forKey:attr];
    }
    
    //relationship.
    NSDictionary *relationships = [entityDescription relationshipsByName];
    for (NSRelationshipDescription *rel in relationships){
        NSString *keyName = [NSString stringWithFormat:@"%@",rel];
        if ([relationshipKeys containsObject:keyName])
        {
            NSMutableSet *foregroundSet =  [self mutableSetValueForKey:keyName];
            NSMutableSet *backgroundSet = [backgroundObject mutableSetValueForKey:keyName];
            NSMutableSet *objectsToDelete = [NSMutableSet setWithSet:[backgroundSet copy]];
            for (JXManagedObject *subobject in foregroundSet)
            {
                JXManagedObject *backgroundSubobject = subobject.backgroundObject;
                if (!backgroundSubobject)
                {
                    backgroundSubobject = (id)[CoreDataManager insertIntoContext:CoreDataManager.backgroundManagedObjectContext
                                                           newManagedObjectNamed:[subobject.class className]];
                    [backgroundSet addObject:backgroundSubobject];
                }
                else if (![backgroundSet containsObject:backgroundSubobject])
                {
                    [backgroundSet addObject:backgroundSubobject];
                }
                else
                {
                    [objectsToDelete removeObject:backgroundSubobject];
                }
                [subobject reattachCloneDataWithRelationshipKeys:[self deepCopyKeys]
                                                   deletableKeys:nil
                                              toBackgroundObject:backgroundSubobject];
            }
            
            for (JXManagedObject *subobject in [objectsToDelete copy])
            {
                [backgroundSet removeObject:subobject];
                if ([deletableKeys containsObject:keyName])
                {
                    [subobject.managedObjectContext deleteObject:subobject];
                }
            }
        }
    }
}


- (NSSet *)deepCopyKeys {
    return nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - validation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupValidation
{
    //subclasses to implement if neccessary
}

- (BOOL)isValid {
    return [[self validationMessages] allKeys].count == 0;
}

- (NSDictionary *)validationMessages {
    NSMutableDictionary *allMessages = [[NSMutableDictionary alloc] init];
    
    for(NSString *key in validationBlocks.allKeys) {
        NSArray *messages = [self validationMessagesForKey:key];
        if(messages.count > 0) {
            if([allMessages objectForKey:key] == nil) {
                [allMessages setObject:[[NSMutableArray alloc] init] forKey:key];
            }
            
            [[allMessages objectForKey:key] addObjectsFromArray:messages];
        }
    }
    
    return allMessages;
}

- (void)addValidationRuleForKey:(NSString *)key validationBlock:(NSString * (^)(NSString *key, JXManagedObject *managedObject))validationBlock {
    if([validationBlocks objectForKey:key] == nil) {
        [validationBlocks setObject:[[NSMutableArray alloc] init] forKey:key];
    }
    
    [[validationBlocks objectForKey:key] addObject:[validationBlock copy]];
}

- (NSArray *)validationMessagesForKey:(NSString *)key {
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    for(int i = 0;i < [[validationBlocks objectForKey:key] count]; i++) {
        NSString * (^block)(NSString *, JXManagedObject *) = [[validationBlocks objectForKey:key] objectAtIndex:i];
        if (block)
        {
            NSString *validationMessage = block(key, self);
            if(validationMessage.isValidString) {
                [messages addObject:validationMessage];
            }
        }
    }
    return messages;
}

- (NSString *)validationErrorDescription
{
    NSMutableString *description = [NSMutableString string];
    NSMutableArray *errors = [NSMutableArray array];
    NSDictionary *validationErrors = [self validationMessages];
    for (NSString *key in [validationErrors allKeys]) {
        for (NSString *errorString in [validationErrors objectForKey:key]) {
            if (![errors containsObject:errorString])
            {
                [description appendFormat:@"%@\n", errorString];
            }
            [errors addObject:errorString];
        }
    }
    return description;
}


@end
