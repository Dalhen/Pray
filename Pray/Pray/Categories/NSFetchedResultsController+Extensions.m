//
//  NSFetchedResultsController+Extensions.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "NSFetchedResultsController+Extensions.h"

/*-----------------------------------------------------------------------------------------------------*/

@implementation NSFetchedResultsController (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - utility
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSFetchedResultsController *)fetchedResultsControllerWithCacheName:(NSString *)cacheName
                                                    coreDataClassName:(NSString *)className
                                                            predicate:(NSPredicate *)predicate
                                                      sortDescriptors:(NSArray *)sortDescriptors
                                                           sectionKey:(NSString *)sectionKey
                                                          andDelegate:(NSObject <NSFetchedResultsControllerDelegate> *)delegate
{
    if (!className.isValidString)
        {
        printFailAndAbort(@"className is not valid");
        }
    
    NSFetchRequest *request = [CoreDataManager fetchRequestForClassName:className
                                                          withPredicate:predicate
                                                     andSortDescriptors:sortDescriptors
                                                              inContext:CoreDataManager.uiManagedObjectContext];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:CoreDataManager.uiManagedObjectContext
                                                                                   sectionNameKeyPath:sectionKey
                                                                                            cacheName:cacheName];
    controller.delegate = delegate;
    
    NSError *error = nil;
    [controller performFetch:&error];
    if (error)
        {
        printErrorAndAbort(error);
        }
    
    return controller;
}

@end
