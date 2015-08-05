
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


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - User
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (CDUser *)addUserWithData:(NSDictionary *)userObject {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    
    NSNumber *userId = [NSNumber numberWithInt:[[userObject objectForKey:@"id"] intValue]];
    NSString *avatarUrl = [userObject objectForKey:@"avatar"];
    NSString *bio = [userObject objectForKey:@"additional_info"];
    NSString *username = [userObject objectForKey:@"username"];
    NSString *email = [userObject objectForKey:@"email"];
    NSString *facebookId = [userObject objectForKey:@"fb_id"];
    NSString *firstname = [userObject objectForKey:@"first_name"];
    NSString *lastname = [userObject objectForKey:@"last_name"];
    NSString *followersCount = [userObject objectForKey:@"followers_count"];
    NSString *followingCount = [userObject objectForKey:@"following_count"];
    NSString *prayersCount = [userObject objectForKey:@"prayers_count"];
    //NSDate *dateOfBirth = [NSDate dateFromUTCServer:[userObject objectForKey:@"dob"]];
    
    CDUser *user = [self getUserForID:userId];
    if (!user) {
        user = (CDUser *)[NSEntityDescription insertNewObjectForEntityForName:@"CDUser" inManagedObjectContext:moc];
    }
    
    user.uniqueId = validObject(userId)? userId : user.uniqueId;
    user.avatar = validObject(avatarUrl)? avatarUrl : user.avatar;
    user.bio = validObject(bio)? bio : user.bio;
    user.username = validObject(username)? username : user.username;
    user.email = validObject(email)? email : user.email;
    user.username = validObject(username)? username : user.username;
    user.firstname = validObject(firstname)? firstname : user.firstname;
    user.lastname = validObject(lastname)? lastname : user.lastname;
    user.username = validObject(username)? username : user.username;

    user.followersCount = validObject(followersCount)? followersCount : user.followersCount;
    user.followingCount = validObject(followingCount)? followingCount : user.followingCount;
    
    
    NSError *error;
    if (![moc save:&error]) {
        // Handle the error.
        if(DEBUGDataAccess) NSLog(@"Error saving user");
    } else {
        if(DEBUGDataAccess) NSLog(@"New user added");
    }
    
    return user;
}

- (CDUser *)getUserForID:(NSNumber *)uniqueId {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"CDUser" inManagedObjectContext:moc]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"uniqueId == %@", uniqueId]];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[moc executeFetchRequest:request error:&error] mutableCopy];
    return ([mutableFetchResults count]>0) ? [mutableFetchResults objectAtIndex:0] : nil;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Prayer
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Comment
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


@end
