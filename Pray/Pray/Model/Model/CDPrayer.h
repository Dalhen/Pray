//
//  CDPrayer.h
//  
//
//  Created by Jason LAPIERRE on 04/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDComment, CDUser;

@interface CDPrayer : NSManagedObject

@property (nonatomic, retain) NSNumber * uniqueId;
@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSString * religionType;
@property (nonatomic, retain) NSString * commentsCount;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * creatorId;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * isLiked;
@property (nonatomic, retain) NSString * likesCount;
@property (nonatomic, retain) NSString * prayerText;
@property (nonatomic, retain) NSString * timeAgo;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) CDUser *creator;
@end

@interface CDPrayer (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(CDComment *)value;
- (void)removeCommentsObject:(CDComment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
