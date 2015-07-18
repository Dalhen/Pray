//
//  NSFetchedResultsController+Extensions.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@interface NSFetchedResultsController (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - utility
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSFetchedResultsController *)fetchedResultsControllerWithCacheName:(NSString *)cacheName
                                                    coreDataClassName:(NSString *)className
                                                            predicate:(NSPredicate *)predicate
                                                      sortDescriptors:(NSArray *)sortDescriptors
                                                           sectionKey:(NSString *)sectionKey
                                                          andDelegate:(NSObject <NSFetchedResultsControllerDelegate> *)delegate;

@end
