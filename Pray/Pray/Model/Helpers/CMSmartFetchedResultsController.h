//
//  CMSmartFetchedResultsController.h
//  JXVault
//
//  Created by Jason YL on 25/04/13.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@class CMSmartFetchedResultsController;
@protocol CMSmartFetchedResultsControllerDelegate <NSObject>
- (void)smartFetchedResultsController:(CMSmartFetchedResultsController *)controller
               requestedUpdateForCell:(UITableViewCell *)cell
                          atIndexPath:(NSIndexPath *)indexPath;
@end

/*-----------------------------------------------------------------------------------------------------*/

#define kCMSmartFetchedResultsController_noSectionIndex -1
#define kCMSmartFetchedResultsController_noRowIndex 0

/*-----------------------------------------------------------------------------------------------------*/

@interface CMSmartFetchedResultsController : NSFetchedResultsController <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, unsafe_unretained) int section;
@property (nonatomic, unsafe_unretained) int firstIndex;
@property (nonatomic, unsafe_unretained) id <CMSmartFetchedResultsControllerDelegate> superDelegate;

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
                                                              andDelegate:(id <CMSmartFetchedResultsControllerDelegate>)delegate;

@end
