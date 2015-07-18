//
//  CDUser.h
//  
//
//  Created by Jason LAPIERRE on 18/07/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDUser : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * facebookId;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSNumber * uniqueId;
@property (nonatomic, retain) NSString * username;

@end
