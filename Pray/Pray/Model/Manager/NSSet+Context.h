//
//  NSSet+Context.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@interface NSSet (Context)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - context saving
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addToContext:(NSManagedObjectContext *)context
          shouldSave:(BOOL)shouldSave;

@end
