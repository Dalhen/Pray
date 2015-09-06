//
//  CDUser.h
//  
//
//  Created by Jason LAPIERRE on 04/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDComment, CDPrayer;

@interface CDUser : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * facebookId;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * followersCount;
@property (nonatomic, retain) NSString * followingCount;
@property (nonatomic, retain) NSNumber * isFollowed;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * prayersCount;
@property (nonatomic, retain) NSNumber * uniqueId;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *prayers;
@end

@interface CDUser (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(CDComment *)value;
- (void)removeCommentsObject:(CDComment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addPrayersObject:(CDPrayer *)value;
- (void)removePrayersObject:(CDPrayer *)value;
- (void)addPrayers:(NSSet *)values;
- (void)removePrayers:(NSSet *)values;

@end
