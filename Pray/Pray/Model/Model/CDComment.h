//
//  CDComment.h
//  
//
//  Created by Jason LAPIERRE on 04/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPrayer, CDUser;

@interface CDComment : NSManagedObject

@property (nonatomic, retain) NSNumber * uniqueId;
@property (nonatomic, retain) NSString * commentText;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * creatorId;
@property (nonatomic, retain) NSString * timeAgo;
@property (nonatomic, retain) NSString * tempIdentifier;
@property (nonatomic, retain) CDUser *creator;
@property (nonatomic, retain) CDPrayer *prayer;
@property (nonatomic, retain) NSSet *tagged;
@end

@interface CDComment (CoreDataGeneratedAccessors)

- (void)addTaggedObject:(CDUser *)value;
- (void)removeTaggedObject:(CDUser *)value;
- (void)addTagged:(NSSet *)values;
- (void)removeTagged:(NSSet *)values;

- (NSComparisonResult)compareByDate:(CDComment *)other;
- (NSComparisonResult)compareByID:(CDComment *)other;

@end
