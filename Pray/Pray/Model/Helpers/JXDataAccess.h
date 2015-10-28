//
//  JXDataAccess.h
//  Pray
//
//  Created by Jason LAPIERRE on 18/07/2015.
//  Copyright (c) 2015 Jason LAPIERRE. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JXDataAccess : NSObject

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Instance
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (JXDataAccess *)sharedInstance;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helpers
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSManagedObjectContext*)getDBContext;
+ (NSMutableArray*)getTableData:(NSString*)tableName;
+ (void)truncateTable:(NSString *)tableName;
+ (void)createTable:(NSString *)tableName arrayOfData:(NSArray *)arrayOfData;
+ (void)saveEdits;
- (void)clearDatabase;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - User
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (CDUser *)addUserWithData:(NSDictionary *)userObject;

- (NSArray *)addUsers:(NSArray *)usersData;

- (CDUser *)getUserForID:(NSNumber *)uniqueId;

- (CDUser *)getUserForUsername:(NSString *)username;

- (void)followUser:(NSNumber *)userId;

- (void)unfollowUser:(NSNumber *)userId;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Prayer
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (CDPrayer *)addPrayerWithData:(NSDictionary *)prayerData;

- (NSArray *)addPrayers:(NSArray *)prayersData;

- (CDPrayer *)getPrayerForID:(NSNumber *)uniqueId;

- (void)add1LikeToPrayerWithID:(NSNumber *)prayerId;

- (void)remove1LikeToPrayerWithID:(NSNumber *)prayerId;

- (void)removePrayerForID:(NSNumber *)prayerId;

- (void)deleteAllPrayers;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Comment
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (CDComment *)addCommentWithData:(NSDictionary *)commentData toPrayer:(NSNumber *)prayerId;

- (NSArray *)addCommentsWithData:(NSArray *)commentsData toPrayer:(NSNumber *)prayerId;

- (CDComment *)getCommentForID:(NSNumber *)uniqueId;

- (NSArray *)getCommentsForPrayer:(NSNumber *)uniqueId;

- (void)removeCommentForID:(NSNumber *)commentId;

- (void)add1CommentToPrayer:(CDPrayer *)prayer;

- (void)remove1CommentFromPrayer:(CDPrayer *)prayer;

@end
