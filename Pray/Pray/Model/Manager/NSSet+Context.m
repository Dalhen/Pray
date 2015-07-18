//
//  NSSet+Context.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "NSSet+Context.h"
#import "JXManagedObject.h"

/*-----------------------------------------------------------------------------------------------------*/

@implementation NSSet (Context)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - context saving
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addToContext:(NSManagedObjectContext *)context
          shouldSave:(BOOL)shouldSave {
	for(JXManagedObject *domainObject in self) {
		[domainObject addToContext:context
            andPerformOnMainThread:nil
                        shouldSave:NO
                  withNotification:nil];
	}
}

@end
