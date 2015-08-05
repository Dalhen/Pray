//
//  CDPrayer.h
//  
//
//  Created by Jason LAPIERRE on 04/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDComments, CDUser;

@interface CDPrayer : NSManagedObject

@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSString * commentsCount;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * creatorId;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * isLiked;
@property (nonatomic, retain) NSString * likesCount;
@property (nonatomic, retain) NSString * prayerText;
@property (nonatomic, retain) NSString * timeAgo;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) CDUser *creator;
@end

@interface CDPrayer (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(CDComments *)value;
- (void)removeCommentsObject:(CDComments *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
