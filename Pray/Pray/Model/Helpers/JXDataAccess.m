
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
    NSString *bio = [userObject objectForKey:@"bio"];
    NSString *username = [userObject objectForKey:@"username"];
    NSString *email = [userObject objectForKey:@"email"];
    NSString *firstname = [userObject objectForKey:@"first_name"];
    NSString *lastname = [userObject objectForKey:@"last_name"];
    NSString *followersCount = [[userObject objectForKey:@"followers"] stringValue];
    NSString *followingCount = [[userObject objectForKey:@"following"] stringValue];
    NSString *prayersCount = [[userObject objectForKey:@"posts"] stringValue];
    NSNumber *isFollowed = [NSNumber numberWithInt:[[userObject objectForKey:@"isFollowed"] intValue]];
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
    user.prayersCount = validObject(prayersCount)? prayersCount : user.prayersCount;
    user.isFollowed = validObject(isFollowed)? isFollowed : user.isFollowed;
    
    NSError *error;
    if (![moc save:&error]) {
        // Handle the error.
        if(DEBUGDataAccess) NSLog(@"Error saving user");
    } else {
        if(DEBUGDataAccess) NSLog(@"New user added");
    }
    
    return user;
}

- (NSArray *)addUsers:(NSArray *)usersData {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    NSMutableArray *usersObjects = [[NSMutableArray alloc] initWithCapacity:[usersData count]];
    
    for (NSDictionary *userObject in usersData) {
        
        NSNumber *userId = [NSNumber numberWithInt:[[userObject objectForKey:@"id"] intValue]];
        NSString *avatarUrl = [userObject objectForKey:@"avatar"];
        NSString *bio = [userObject objectForKey:@"bio"];
        NSString *username = [userObject objectForKey:@"username"];
        NSString *email = [userObject objectForKey:@"email"];
        NSString *firstname = [userObject objectForKey:@"first_name"];
        NSString *lastname = [userObject objectForKey:@"last_name"];
        NSString *followersCount = [[userObject objectForKey:@"followers"] stringValue];
        NSString *followingCount = [[userObject objectForKey:@"following"] stringValue];
        NSString *prayersCount = [[userObject objectForKey:@"posts"] stringValue];
        NSNumber *isFollowed = [NSNumber numberWithInt:[[userObject objectForKey:@"isFollowed"] intValue]];
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
        user.prayersCount = validObject(prayersCount)? prayersCount : user.prayersCount;
        user.isFollowed = validObject(isFollowed)? isFollowed : user.isFollowed;
        
        [usersObjects addObject:user];
    }
    
    NSError *error;
    if (![moc save:&error]) {
        // Handle the error.
        if(DEBUGDataAccess) NSLog(@"Error saving users");
    } else {
        if(DEBUGDataAccess) NSLog(@"New users added");
    }
    
    return usersObjects;
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

- (CDUser *)getUserForUsername:(NSString *)username {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"CDUser" inManagedObjectContext:moc]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"username == %@", username]];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[moc executeFetchRequest:request error:&error] mutableCopy];
    return ([mutableFetchResults count]>0) ? [mutableFetchResults objectAtIndex:0] : nil;
}

- (void)followUser:(NSNumber *)userId {
    CDUser *user = [self getUserForID:userId];
    
    if (user) {
        NSManagedObjectContext *moc = [JXDataAccess getDBContext];
        
        user.isFollowed = [NSNumber numberWithBool:YES];
        
        NSError *error;
        if (![moc save:&error]) {
            // Handle the error.
            if(DEBUGDataAccess) NSLog(@"Error following user");
        } else {
            if(DEBUGDataAccess) NSLog(@"User followed");
        }
    }
}

- (void)unfollowUser:(NSNumber *)userId {
    CDUser *user = [self getUserForID:userId];
    
    if (user) {
        NSManagedObjectContext *moc = [JXDataAccess getDBContext];
        
        user.isFollowed = [NSNumber numberWithBool:NO];
        
        NSError *error;
        if (![moc save:&error]) {
            // Handle the error.
            if(DEBUGDataAccess) NSLog(@"Error unfollowing user");
        } else {
            if(DEBUGDataAccess) NSLog(@"User unfollowed");
        }
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Prayer
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (CDPrayer *)addPrayerWithData:(NSDictionary *)prayerData {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    
    NSDictionary *userData = [[prayerData objectForKey:@"user"] objectForKey:@"data"];
    NSArray *taggedUsers = [[prayerData objectForKey:@"tagged"] objectForKey:@"data"];
                            
    NSNumber *uniqueId = [NSNumber numberWithInt:[[prayerData objectForKey:@"id"] intValue]];
    NSNumber *creatorId = [NSNumber numberWithInt:[[userData objectForKey:@"id"] intValue]];
    NSNumber *categoryId = [NSNumber numberWithInt:[[prayerData objectForKey:@"category_id"] intValue]];
    NSString *prayerText = [prayerData objectForKey:@"body"];
    NSString *religionType = validObject([prayerData objectForKey:@"religion"])? [[prayerData objectForKey:@"religion"] stringValue] : @"0";
    NSString *imageURL = [prayerData objectForKey:@"image"];
    NSString *latitude = [prayerData objectForKey:@"latitude"];
    NSString *longitude = [prayerData objectForKey:@"longitude"];
    NSString *locationName = [prayerData objectForKey:@"location"];
    NSString *commentsCount = [[prayerData objectForKey:@"comments"] stringValue];
    NSString *likesCount = [[prayerData objectForKey:@"likes"] stringValue];
    NSString *timeAgo = [prayerData objectForKey:@"time_ago"];
    NSNumber *isLiked = [NSNumber numberWithInt:[[prayerData objectForKey:@"liked"] intValue]];
    NSDate *creationDate = [NSDate dateFromUTCServer:[prayerData objectForKey:@"created_at"]];
    
    CDPrayer *prayer = [self getPrayerForID:uniqueId];
    if (!prayer) {
        prayer = (CDPrayer *)[NSEntityDescription insertNewObjectForEntityForName:@"CDPrayer" inManagedObjectContext:moc];
    }
    
    prayer.uniqueId = validObject(uniqueId)? uniqueId : prayer.uniqueId;
    prayer.creatorId = validObject(creatorId)? creatorId : prayer.creatorId;
    prayer.categoryId = validObject(categoryId)? categoryId : prayer.categoryId;
    prayer.prayerText = validObject(prayerText)? prayerText : prayer.prayerText;
    prayer.religionType = validObject(religionType)? religionType : prayer.religionType;
    prayer.imageURL = validObject(imageURL)? imageURL : prayer.imageURL;
    prayer.latitude = validObject(latitude)? latitude : prayer.latitude;
    prayer.longitude = validObject(longitude)? longitude : prayer.longitude;
    prayer.locationName = validObject(locationName)? locationName : prayer.locationName;
    prayer.commentsCount = validObject(commentsCount)? commentsCount : prayer.commentsCount;
    prayer.likesCount = validObject(likesCount)? likesCount : prayer.likesCount;
    prayer.timeAgo = validObject(timeAgo)? timeAgo : prayer.timeAgo;
    prayer.isLiked = validObject(isLiked)? isLiked : prayer.isLiked;
    prayer.creationDate = validObject(creationDate)? creationDate : prayer.creationDate;
    
    //Creator
    CDUser *user = [self addUserWithData:userData];
    if (user) {
        [prayer setCreator:user];
    }
    
    //Tagged
    if ([taggedUsers count]>0) {
        NSArray *tagsObjects = [DataAccess addUsers:taggedUsers];
        [prayer addTagged:[NSSet setWithArray:tagsObjects]];
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
        
        NSDictionary *userData = [[prayerData objectForKey:@"user"] objectForKey:@"data"];
        NSArray *taggedUsers = [[prayerData objectForKey:@"tagged"] objectForKey:@"data"];
        
        NSNumber *uniqueId = [NSNumber numberWithInt:[[prayerData objectForKey:@"id"] intValue]];
        NSNumber *creatorId = [NSNumber numberWithInt:[[userData objectForKey:@"id"] intValue]];
        NSNumber *categoryId = [NSNumber numberWithInt:[[prayerData objectForKey:@"category_id"] intValue]];
        NSString *prayerText = [prayerData objectForKey:@"body"];
        NSString *religionType = validObject([prayerData objectForKey:@"religion"])? [[prayerData objectForKey:@"religion"] stringValue] : @"0";
        NSString *imageURL = [prayerData objectForKey:@"image"];
        NSString *latitude = [prayerData objectForKey:@"latitude"];
        NSString *longitude = [prayerData objectForKey:@"longitude"];
        NSString *locationName = [prayerData objectForKey:@"location"];
        NSString *commentsCount = [[prayerData objectForKey:@"comments"] stringValue];
        NSString *likesCount = [[prayerData objectForKey:@"likes"] stringValue];
        NSString *timeAgo = [prayerData objectForKey:@"time_ago"];
        NSNumber *isLiked = [NSNumber numberWithInt:[[prayerData objectForKey:@"liked"] intValue]];
        NSDate *creationDate = [NSDate dateFromUTCServer:[prayerData objectForKey:@"created_at"]];
        
        CDPrayer *prayer = [self getPrayerForID:uniqueId];
        if (!prayer) {
            prayer = (CDPrayer *)[NSEntityDescription insertNewObjectForEntityForName:@"CDPrayer" inManagedObjectContext:moc];
        }
        
        prayer.uniqueId = validObject(uniqueId)? uniqueId : prayer.uniqueId;
        prayer.creatorId = validObject(creatorId)? creatorId : prayer.creatorId;
        prayer.categoryId = validObject(categoryId)? categoryId : prayer.categoryId;
        prayer.prayerText = validObject(prayerText)? prayerText : prayer.prayerText;
        prayer.religionType = validObject(religionType)? religionType : prayer.religionType;
        prayer.imageURL = validObject(imageURL)? imageURL : prayer.imageURL;
        prayer.latitude = validObject(latitude)? latitude : prayer.latitude;
        prayer.longitude = validObject(longitude)? longitude : prayer.longitude;
        prayer.locationName = validObject(locationName)? locationName : prayer.locationName;
        prayer.commentsCount = validObject(commentsCount)? commentsCount : prayer.commentsCount;
        prayer.likesCount = validObject(likesCount)? likesCount : prayer.likesCount;
        prayer.timeAgo = validObject(timeAgo)? timeAgo : prayer.timeAgo;
        prayer.isLiked = validObject(isLiked)? isLiked : prayer.isLiked;
        prayer.creationDate = validObject(creationDate)? creationDate : prayer.creationDate;
        
        //Creator
        CDUser *user = [self addUserWithData:userData];
        if (user) {
            [prayer setCreator:user];
        }
        
        //Tagged
        if ([taggedUsers count]>0) {
            NSArray *tagsObjects = [DataAccess addUsers:taggedUsers];
            [prayer addTagged:[NSSet setWithArray:tagsObjects]];
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

- (void)add1LikeToPrayerWithID:(NSNumber *)prayerId {
    
    CDPrayer *prayer = [self getPrayerForID:prayerId];
    if (prayer) {
        [prayer setIsLiked:[NSNumber numberWithInt:1]];
        [prayer setLikesCount:[NSString stringWithFormat:@"%d",[prayer.likesCount intValue]+1]];
        
        if (prayer) {
            NSManagedObjectContext *moc = [JXDataAccess getDBContext];
            NSError *error;
            if (![moc save:&error]) {
                // Handle the error.
                if(DEBUGDataAccess) NSLog(@"Error adding +1 like to prayer");
            } else {
                if(DEBUGDataAccess) NSLog(@"+1 like added to prayer");
            }
        }
    }
}

- (void)remove1LikeToPrayerWithID:(NSNumber *)prayerId {
    
    CDPrayer *prayer = [self getPrayerForID:prayerId];
    if (prayer) {
        [prayer setIsLiked:[NSNumber numberWithInt:0]];
        [prayer setLikesCount:[NSString stringWithFormat:@"%d",[prayer.likesCount intValue]-1]];
        
        if (prayer) {
            NSManagedObjectContext *moc = [JXDataAccess getDBContext];
            NSError *error;
            if (![moc save:&error]) {
                // Handle the error.
                if(DEBUGDataAccess) NSLog(@"Error setting -1 like to prayer");
            } else {
                if(DEBUGDataAccess) NSLog(@"-1 like to prayer");
            }
        }
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Comment
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (CDComment *)addCommentWithData:(NSDictionary *)commentData toPrayer:(NSNumber *)prayerId {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    
    NSDictionary *userData = [[commentData objectForKey:@"user"] objectForKey:@"data"];
    NSArray *taggedUsers = [[commentData objectForKey:@"tagged"] objectForKey:@"data"];
    
    NSNumber *uniqueId = [NSNumber numberWithInt:[[commentData objectForKey:@"id"] intValue]];
    NSString *commentText = [commentData objectForKey:@"body"];
    NSDate *creationDate = [NSDate dateFromUTCServer:[commentData objectForKey:@"created_at"]];
    NSNumber *creatorId = [NSNumber numberWithInt:[[userData objectForKey:@"id"] intValue]];
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
    
    //Creator
    CDUser *user = [self addUserWithData:userData];
    if (user) {
        [comment setCreator:user];
    }
    
    //Tagged
    if ([taggedUsers count]>0) {
        NSArray *tagsObjects = [DataAccess addUsers:taggedUsers];
        [comment addTagged:[NSSet setWithArray:tagsObjects]];
    }
    
    //Prayer
    CDPrayer *prayer = [self getPrayerForID:prayerId];
    if (prayer) {
        [prayer addCommentsObject:comment];
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

- (NSArray *)addCommentsWithData:(NSArray *)commentsData toPrayer:(NSNumber *)prayerId {
    NSManagedObjectContext *moc = [JXDataAccess getDBContext];
    NSMutableArray *commentsObjects = [[NSMutableArray alloc] initWithCapacity:[commentsData count]];
    
    for (NSDictionary *commentData in commentsData) {
        
        NSDictionary *userData = [[commentData objectForKey:@"user"] objectForKey:@"data"];
        NSArray *taggedUsers = [[commentData objectForKey:@"tagged"] objectForKey:@"data"];
        
        NSNumber *uniqueId = [NSNumber numberWithInt:[[commentData objectForKey:@"id"] intValue]];
        NSString *commentText = [commentData objectForKey:@"body"];
        NSDate *creationDate = [NSDate dateFromUTCServer:[commentData objectForKey:@"created_at"]];
        NSNumber *creatorId = [NSNumber numberWithInt:[[userData objectForKey:@"id"] intValue]];
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
        
        //Creator
        CDUser *user = [self addUserWithData:userData];
        if (user) {
            [comment setCreator:user];
        }
        
        //Tagged
        if ([taggedUsers count]>0) {
            NSArray *tagsObjects = [DataAccess addUsers:taggedUsers];
            [comment addTagged:[NSSet setWithArray:tagsObjects]];
        }
        
        [commentsObjects addObject:comment];
    }
    
    CDPrayer *prayer = [self getPrayerForID:prayerId];
    if (prayer) {
        [prayer addComments:[NSSet setWithArray:commentsObjects]];
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

- (NSArray *)getCommentsForPrayer:(NSNumber *)uniqueId {
    CDPrayer *prayer = [self getPrayerForID:uniqueId];
    if (prayer) {
        return [prayer.comments allObjects];
    }
    else return nil;
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

- (void)add1CommentToPrayer:(CDPrayer *)prayer {
    [prayer setCommentsCount:[NSString stringWithFormat:@"%d",[prayer.commentsCount intValue]+1]];
    
    if (prayer) {
        NSManagedObjectContext *moc = [JXDataAccess getDBContext];
        NSError *error;
        if (![moc save:&error]) {
            // Handle the error.
            if(DEBUGDataAccess) NSLog(@"Error setting +1 comment to prayer");
        } else {
            if(DEBUGDataAccess) NSLog(@"+1 comment to prayer");
        }
    }
}

- (void)remove1CommentFromPrayer:(CDPrayer *)prayer {
    [prayer setCommentsCount:[NSString stringWithFormat:@"%d",[prayer.commentsCount intValue]-1]];
    
    if (prayer) {
        NSManagedObjectContext *moc = [JXDataAccess getDBContext];
        NSError *error;
        if (![moc save:&error]) {
            // Handle the error.
            if(DEBUGDataAccess) NSLog(@"Error setting -1 comment to prayer");
        } else {
            if(DEBUGDataAccess) NSLog(@"-1 comment to prayer");
        }
    }
}

@end
