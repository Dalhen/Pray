//
//  CDComments.h
//  
//
//  Created by Jason LAPIERRE on 04/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPrayer, CDUser;

@interface CDComments : NSManagedObject

@property (nonatomic, retain) NSString * commentText;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * creatorId;
@property (nonatomic, retain) NSString * timeAgo;
@property (nonatomic, retain) CDUser *creator;
@property (nonatomic, retain) CDPrayer *prayer;

@end
