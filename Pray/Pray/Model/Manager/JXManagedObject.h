//
//  JXBaseManagedObject.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "JXRESTManagedObject.h"
#import "NSSet+Context.h"

/*-----------------------------------------------------------------------------------------------------*/

@interface JXManagedObject : JXRESTManagedObject  {
    NSMutableDictionary *validationBlocks;
}
@property (nonatomic, strong) NSManagedObjectID *originalManagedObjectId;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - class utitlity
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)detachedObject;
+ (NSString *)className;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ordering
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)orderedItems:(NSSet *)items;
- (NSNumber *)nextIndex:(NSSet *)items;
- (void)reorderIndexes:(NSSet *)items;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - context management
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isBackgroundObject;
- (BOOL)isUiObject;
- (id)backgroundObject;
- (id)uiObject;
- (void)addToContext:(NSManagedObjectContext *)context
andPerformOnMainThread:(void (^)(id insertedObject))foregroundBlock
          shouldSave:(BOOL)shouldSave
    withNotification:(NSString *)notification;
- (void)editInBackgroundContext:(void (^)(id backgroundObject))block
         andPerformOnMainThread:(void (^)(id insertedObject))foregroundBlock
                     shouldSave:(BOOL)shouldSave
               withNotification:(NSString *)notification;
- (void)persistAndPostNotification:(NSNotification *)notification
            andPerformOnMainThread:(void (^)(id insertedObject))foregroundBlock;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - cloning
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(id)detachedCloneWithRelationshipKeys:(NSSet *)relationshipKeys;
-(void)reattachCloneToBackgroundContextWithRelationshipKeys:(NSSet *)relationshipKeys
                                              deletableKeys:(NSSet *)deletableKeys
                                     andPerformOnMainThread:(void (^)(id insertedObject))foregroundBlock
                                                 shouldSave:(BOOL)shouldSave
                                           withNotification:(NSString *)notification;
- (NSSet *)deepCopyKeys;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - validation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isValid;
- (NSDictionary *)validationMessages;
- (void)addValidationRuleForKey:(NSString *)key validationBlock:(NSString * (^)(NSString *key, JXManagedObject *managedObject))validationBlock;
- (NSArray *)validationMessagesForKey:(NSString *)key;
- (NSString *)validationErrorDescription;

@end
