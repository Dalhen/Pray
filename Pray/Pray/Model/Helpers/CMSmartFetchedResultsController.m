//
//  CMSmartFetchedResultsController.m
//  JXVault
//
//  Created by Jason YL on 25/04/13.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "CMSmartFetchedResultsController.h"
#import "NSFetchedResultsController+Extensions.h"

/*-----------------------------------------------------------------------------------------------------*/

@implementation CMSmartFetchedResultsController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - creation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (CMSmartFetchedResultsController *)smartfetchedResultsControllerForTableview:(UITableView *)tableView
                                                             sectionIndex:(int)sectionIndex
                                                               firstIndex:(unsigned int)firstIndex
                                                            withCacheName:(NSString *)cacheName
                                                        coreDataClassName:(NSString *)className
                                                                predicate:(NSPredicate *)predicate
                                                          sortDescriptors:(NSArray *)sortDescriptors
                                                               sectionKey:(NSString *)sectionKey
                                                              andDelegate:(id <CMSmartFetchedResultsControllerDelegate>)delegate
{
    if (!className.isValidString)
        {
        printFailAndAbort(@"className is not valid");
        }
    if (!tableView.isValidObject)
        {
        printFailAndAbort(@"tableview is not valid");
        }
    
    NSFetchRequest *request = [CoreDataManager fetchRequestForClassName:className
                                                          withPredicate:predicate
                                                     andSortDescriptors:sortDescriptors
                                                              inContext:CoreDataManager.uiManagedObjectContext];
    CMSmartFetchedResultsController *controller = [[CMSmartFetchedResultsController alloc] initWithFetchRequest:request
                                                                                           managedObjectContext:CoreDataManager.uiManagedObjectContext
                                                                                             sectionNameKeyPath:sectionKey
                                                                                                      cacheName:cacheName];
    controller.tableView = tableView;
    controller.section = sectionIndex;
    controller.firstIndex = firstIndex;
    controller.delegate = controller;
    controller.superDelegate = delegate;
    
    NSError *error = nil;
    [controller performFetch:&error];
    if (error)
        {
        printErrorAndAbort(error);
        }
    
    return controller;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - delegate calls
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.section != -1)
        {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row + self.firstIndex
                                       inSection:self.section];
        newIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row + self.firstIndex
                                          inSection:self.section];
        }
    else if (self.firstIndex != 0)
        {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row + self.firstIndex
                                       inSection:newIndexPath.section];
        newIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row + self.firstIndex
                                          inSection:newIndexPath.section];
        }
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.superDelegate smartFetchedResultsController:self
                                       requestedUpdateForCell:[self.tableView cellForRowAtIndexPath:indexPath]
                                                  atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    if (self.section == -1)
        {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
        }
    else
        {
        //this is beta code
        printFailPointAndAbort;
        }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
