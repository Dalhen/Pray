
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
- (CDPrayer *)addPrayerWithData:(NSDictionary *)prayerData {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    
    NSNumber *uniqueId = [NSNumber numberWithInt:[[prayerData objectForKey:@"id"] intValue]];
    NSNumber *creatorId = [NSNumber numberWithInt:[[prayerData objectForKey:@"creator_id"] intValue]];
    NSNumber *categoryId = [NSNumber numberWithInt:[[prayerData objectForKey:@"category_id"] intValue]];
    NSString *prayerText = [prayerData objectForKey:@"message"];
    NSString *imageURL = [prayerData objectForKey:@"image_url"];
    NSString *latitude = [prayerData objectForKey:@"lat"];
    NSString *longitude = [prayerData objectForKey:@"lon"];
    NSString *locationName = [prayerData objectForKey:@"location_name"];
    NSString *commentsCount = [prayerData objectForKey:@"comments_count"];
    NSString *likesCount = [prayerData objectForKey:@"likes_count"];
    NSString *timeAgo = [prayerData objectForKey:@"time_ago"];
    NSNumber *isLiked = [NSNumber numberWithInt:[[prayerData objectForKey:@"is_liked"] intValue]];
    NSDate *creationDate = [NSDate dateFromUTCServer:[prayerData objectForKey:@"created"]];
    
    CDPrayer *prayer = [self getPrayerForID:uniqueId];
    if (!prayer) {
        prayer = (CDPrayer *)[NSEntityDescription insertNewObjectForEntityForName:@"CDPrayer" inManagedObjectContext:moc];
    }
    
    prayer.uniqueId = validObject(uniqueId)? uniqueId : prayer.uniqueId;
    prayer.creatorId = validObject(creatorId)? creatorId : prayer.creatorId;
    prayer.categoryId = validObject(categoryId)? categoryId : prayer.categoryId;
    prayer.prayerText = validObject(prayerText)? prayerText : prayer.prayerText;
    prayer.imageURL = validObject(imageURL)? imageURL : prayer.imageURL;
    prayer.latitude = validObject(latitude)? latitude : prayer.latitude;
    prayer.longitude = validObject(longitude)? longitude : prayer.longitude;
    prayer.locationName = validObject(locationName)? locationName : prayer.locationName;
    prayer.commentsCount = validObject(commentsCount)? commentsCount : prayer.commentsCount;
    prayer.likesCount = validObject(likesCount)? likesCount : prayer.likesCount;
    prayer.timeAgo = validObject(timeAgo)? timeAgo : prayer.timeAgo;
    prayer.isLiked = validObject(isLiked)? isLiked : prayer.isLiked;
    prayer.creationDate = validObject(creationDate)? creationDate : prayer.creationDate;
    
    CDUser *user = [self getUserForID:[NSNumber numberWithInt:[creatorId intValue]]];
    if (user) {
        [prayer setCreator:user];
    }
    
    NSError *error;
    if (![moc save:&error]) {
        // Handle the error.
        if(DEBUGDataAccess) NSLog(@"Error saving prayer");
    } else {
        if(DEBUGDataAccess) NSLog(@"New prayer added");
    }
    
    return prayer;
}

- (NSArray *)addPrayers:(NSArray *)prayersData {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    NSMutableArray *prayersObjects = [[NSMutableArray alloc] initWithCapacity:[prayersData count]];
    
    for (NSDictionary *prayerData in prayersData) {
        NSNumber *uniqueId = [NSNumber numberWithInt:[[prayerData objectForKey:@"id"] intValue]];
        NSNumber *creatorId = [NSNumber numberWithInt:[[prayerData objectForKey:@"creator_id"] intValue]];
        NSNumber *categoryId = [NSNumber numberWithInt:[[prayerData objectForKey:@"category_id"] intValue]];
        NSString *prayerText = [prayerData objectForKey:@"message"];
        NSString *imageURL = [prayerData objectForKey:@"image_url"];
        NSString *latitude = [prayerData objectForKey:@"lat"];
        NSString *longitude = [prayerData objectForKey:@"lon"];
        NSString *locationName = [prayerData objectForKey:@"location_name"];
        NSString *commentsCount = [prayerData objectForKey:@"comments_count"];
        NSString *likesCount = [prayerData objectForKey:@"likes_count"];
        NSString *timeAgo = [prayerData objectForKey:@"time_ago"];
        NSNumber *isLiked = [NSNumber numberWithInt:[[prayerData objectForKey:@"is_liked"] intValue]];
        NSDate *creationDate = [NSDate dateFromUTCServer:[prayerData objectForKey:@"created"]];
        
        CDPrayer *prayer = [self getPrayerForID:uniqueId];
        if (!prayer) {
            prayer = (CDPrayer *)[NSEntityDescription insertNewObjectForEntityForName:@"CDPrayer" inManagedObjectContext:moc];
        }
        
        prayer.uniqueId = validObject(uniqueId)? uniqueId : prayer.uniqueId;
        prayer.creatorId = validObject(creatorId)? creatorId : prayer.creatorId;
        prayer.categoryId = validObject(categoryId)? categoryId : prayer.categoryId;
        prayer.prayerText = validObject(prayerText)? prayerText : prayer.prayerText;
        prayer.imageURL = validObject(imageURL)? imageURL : prayer.imageURL;
        prayer.latitude = validObject(latitude)? latitude : prayer.latitude;
        prayer.longitude = validObject(longitude)? longitude : prayer.longitude;
        prayer.locationName = validObject(locationName)? locationName : prayer.locationName;
        prayer.commentsCount = validObject(commentsCount)? commentsCount : prayer.commentsCount;
        prayer.likesCount = validObject(likesCount)? likesCount : prayer.likesCount;
        prayer.timeAgo = validObject(timeAgo)? timeAgo : prayer.timeAgo;
        prayer.isLiked = validObject(isLiked)? isLiked : prayer.isLiked;
        prayer.creationDate = validObject(creationDate)? creationDate : prayer.creationDate;
        
        CDUser *user = [self getUserForID:[NSNumber numberWithInt:[creatorId intValue]]];
        if (user) {
            [prayer setCreator:user];
        }
        
        [prayersObjects addObject:prayer];
    }
    
    NSError *error;
    if (![moc save:&error]) {
        // Handle the error.
        if(DEBUGDataAccess) NSLog(@"Error saving prayer");
    } else {
        if(DEBUGDataAccess) NSLog(@"New prayer added");
    }
    
    return prayersObjects;
}

- (CDPrayer *)getPrayerForID:(NSNumber *)uniqueId {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"CDPrayer" inManagedObjectContext:moc]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"uniqueId == %@", uniqueId]];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[moc executeFetchRequest:request error:&error] mutableCopy];
    return ([mutableFetchResults count]>0) ? [mutableFetchResults objectAtIndex:0] : nil;
}

- (void)removePrayerForID:(NSNumber *)prayerId {
    CDPrayer *prayer = [self getPrayerForID:prayerId];
    
    if (prayer) {
        NSManagedObjectContext *moc = [JXDataAccess getDBContext];
        [moc deleteObject:prayer];
        
        NSError *error;
        if (![moc save:&error]) {
            // Handle the error.
            if(DEBUGDataAccess) NSLog(@"Error deleting prayer");
        } else {
            if(DEBUGDataAccess) NSLog(@"Prayer deleted");
        }
    }
}

- (void)deleteAllPrayers {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"CDPrayer" inManagedObjectContext:moc]];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[moc executeFetchRequest:request error:&error] mutableCopy];
    
    for (CDPrayer *prayer in mutableFetchResults) {
        [moc deleteObject:prayer];
    }
    
    if (![moc save:&error]) {
        // Handle the error.
        if(DEBUGDataAccess) NSLog(@"Error deleting prayers");
    } else {
        if(DEBUGDataAccess) NSLog(@"Prayers deleted");
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Comment
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (CDComment *)addCommentWithData:(NSDictionary *)commentData {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    
    NSNumber *uniqueId = [NSNumber numberWithInt:[[commentData objectForKey:@"id"] intValue]];
    NSString *commentText = [commentData objectForKey:@"comment"];
    NSDate *creationDate = [NSDate dateFromUTCServer:[commentData objectForKey:@"created"]];
    NSNumber *creatorId = [NSNumber numberWithInt:[[commentData objectForKey:@"creator_id"] intValue]];
    NSString *timeAgo = [commentData objectForKey:@"time_ago"];
    
    CDComment *comment = [self getCommentForID:uniqueId];
    if (!comment) {
        comment = (CDComment *)[NSEntityDescription insertNewObjectForEntityForName:@"CDComment" inManagedObjectContext:moc];
    }
    
    comment.uniqueId = validObject(uniqueId)? uniqueId : comment.uniqueId;
    comment.creatorId = validObject(creatorId)? creatorId : comment.creatorId;
    comment.commentText = validObject(commentText)? commentText : comment.commentText;
    comment.timeAgo = validObject(timeAgo)? timeAgo : comment.timeAgo;
    comment.creationDate = validObject(creationDate)? creationDate : comment.creationDate;
    
    CDUser *user = [self getUserForID:[NSNumber numberWithInt:[creatorId intValue]]];
    if (user) {
        [comment setCreator:user];
    }
    
    NSError *error;
    if (![moc save:&error]) {
        // Handle the error.
        if(DEBUGDataAccess) NSLog(@"Error saving prayer");
    } else {
        if(DEBUGDataAccess) NSLog(@"New prayer added");
    }
    
    return comment;
}

- (NSArray *)addComments:(NSArray *)commentsData {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    NSMutableArray *commentsObjects = [[NSMutableArray alloc] initWithCapacity:[commentsData count]];
    
    for (NSDictionary *commentData in commentsData) {
        NSNumber *uniqueId = [NSNumber numberWithInt:[[commentData objectForKey:@"id"] intValue]];
        NSString *commentText = [commentData objectForKey:@"comment"];
        NSDate *creationDate = [NSDate dateFromUTCServer:[commentData objectForKey:@"created"]];
        NSNumber *creatorId = [NSNumber numberWithInt:[[commentData objectForKey:@"creator_id"] intValue]];
        NSString *timeAgo = [commentData objectForKey:@"time_ago"];
        
        CDComment *comment = [self getCommentForID:uniqueId];
        if (!comment) {
            comment = (CDComment *)[NSEntityDescription insertNewObjectForEntityForName:@"CDComment" inManagedObjectContext:moc];
        }
        
        comment.uniqueId = validObject(uniqueId)? uniqueId : comment.uniqueId;
        comment.creatorId = validObject(creatorId)? creatorId : comment.creatorId;
        comment.commentText = validObject(commentText)? commentText : comment.commentText;
        comment.timeAgo = validObject(timeAgo)? timeAgo : comment.timeAgo;
        comment.creationDate = validObject(creationDate)? creationDate : comment.creationDate;
        
        CDUser *user = [self getUserForID:[NSNumber numberWithInt:[creatorId intValue]]];
        if (user) {
            [comment setCreator:user];
        }
        
        [commentsObjects addObject:comment];
    }
    
    NSError *error;
    if (![moc save:&error]) {
        // Handle the error.
        if(DEBUGDataAccess) NSLog(@"Error saving prayer");
    } else {
        if(DEBUGDataAccess) NSLog(@"New prayer added");
    }
    
    return commentsObjects;
}

- (CDComment *)getCommentForID:(NSNumber *)uniqueId {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"CDComment" inManagedObjectContext:moc]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"uniqueId == %@", uniqueId]];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[moc executeFetchRequest:request error:&error] mutableCopy];
    return ([mutableFetchResults count]>0) ? [mutableFetchResults objectAtIndex:0] : nil;
}

- (void)removeCommentForID:(NSNumber *)commentId {
    CDComment *prayer = [self getCommentForID:commentId];
    
    if (prayer) {
        NSManagedObjectContext *moc = [JXDataAccess getDBContext];
        [moc deleteObject:prayer];
        
        NSError *error;
        if (![moc save:&error]) {
            // Handle the error.
            if(DEBUGDataAccess) NSLog(@"Error deleting comment");
        } else {
            if(DEBUGDataAccess) NSLog(@"Comment deleted");
        }
    }
}


@end
