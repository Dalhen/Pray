
//
//  JXDataAccess.m
//  Pray
//
//  Created by Jason LAPIERRE on 18/07/2015.
//  Copyright (c) 2015 Jason LAPIERRE. All rights reserved.
//


#import "JXDataAccess.h"

#define validObject(object) ([object isKindOfClass:[NSNull class]] ? NO : (object == nil)? NO : YES)

@implementation JXDataAccess


#pragma mark - Instance
+ (JXDataAccess *)sharedInstance {
    static JXDataAccess *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JXDataAccess alloc] init];
    });
    return sharedInstance;
}


#pragma mark - Lifecycle
- (id)init {
    self = [super init];
    if (self)
    {
    }
    return self;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helpers
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSManagedObjectContext*)getDBContext {
    JXAppDelegate *app = (JXAppDelegate *)[[UIApplication sharedApplication] delegate];
    return app.managedObjectContext;
}

+ (NSMutableArray*)getTableData:(NSString*)tableName {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:tableName inManagedObjectContext:[JXDataAccess getDBContext]]];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[[JXDataAccess getDBContext] executeFetchRequest:request error:&error] mutableCopy];
    
    return mutableFetchResults;
}

+ (void)truncateTable:(NSString *)tableName {
    if (DEBUGDataAccess) NSLog(@"truncateTable: %@", tableName);
    
    NSMutableArray *allData = [self getTableData:tableName];
    
    for (unsigned int i=0;i<[allData count];++i) {
        [[JXDataAccess getDBContext] deleteObject:[allData objectAtIndex:i]];
    }
    
    NSError *error;
    if (![[JXDataAccess getDBContext] save:&error]) {
        // Handle the error.
        if (DEBUGDataAccess) NSLog(@"Error saving data in truncate");
    }
}

+ (void)createTable:(NSString *)tableName arrayOfData:(NSArray *)arrayOfData {
    if (DEBUGDataAccess) NSLog(@"CREATE TABLE %@", tableName);
    [JXDataAccess truncateTable:tableName];
    int addcounter = 0;
    
    // Add items one by one from the array of dictionary objets
    for (unsigned int i=0;i<[arrayOfData count];++i) {
        
        // Dynamically assign JSON KEYS to TABLE FIELDS
        NSDictionary *dataDict = [arrayOfData objectAtIndex:i];
        NSManagedObject *newData = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:[JXDataAccess getDBContext]];
        
        addcounter += 1;
        for (id theKey in dataDict) {
            id anObject = [dataDict objectForKey:theKey];
            
            if ([[anObject description] isEqualToString:@"<null>"]) {anObject=@"";}
            
            @try {
                SEL checkSelector = NSSelectorFromString(theKey);
                if ([newData respondsToSelector:checkSelector]) {
                    [newData setValue:anObject forKey:theKey];
                    
                } else {
                }
            }
            @catch (NSException *exception) {
                if (DEBUGDataAccess) NSLog(@"!!!! CAUGHT ADD ERROR: %@", [exception description]);
            }
            
        }
    }
    
    NSError *error;
    if (![[JXDataAccess getDBContext] save:&error]) {
        // Handle the error.
        if (DEBUGDataAccess) NSLog(@"Error saving data");
    }
    
    if (DEBUGDataAccess) NSLog(@"TABLE %@ ADDED %d rows", tableName, addcounter);
}

+ (void)saveEdits {
    NSError *error;
    if (![[JXDataAccess getDBContext] save:&error]) {
        // Handle the error.
        if (DEBUGDataAccess) NSLog(@"Error saving saveEdits");
    }
}

- (void)clearDatabase {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"CDGroup" inManagedObjectContext:moc]];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[moc executeFetchRequest:request error:&error] mutableCopy];
    for (NSManagedObject *object in mutableFetchResults) {
        [moc deleteObject:object];
    }
    
    if (![moc save:&error]) {
        // Handle the error.
        if(DEBUGDataAccess) NSLog(@"Error deleting database");
    } else {
        if(DEBUGDataAccess) NSLog(@"Database deleted");
    }
}




@end
