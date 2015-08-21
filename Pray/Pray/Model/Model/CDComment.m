//
//  CDComment.m
//  
//
//  Created by Jason LAPIERRE on 04/08/2015.
//
//

#import "CDComment.h"
#import "CDPrayer.h"
#import "CDUser.h"


@implementation CDComment

@dynamic uniqueId;
@dynamic commentText;
@dynamic creationDate;
@dynamic creatorId;
@dynamic timeAgo;
@dynamic tempIdentifier;
@dynamic creator;
@dynamic prayer;

- (NSComparisonResult)compareByDate:(CDComment *)other {
    return [self.creationDate compare:other.creationDate];
}

- (NSComparisonResult)compareByID:(CDComment *)other {
    return [self.uniqueId compare:other.uniqueId];
}

@end
