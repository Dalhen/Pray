//
//  AppDelegate.h
//  Pray
//
//  Created by Jason LAPIERRE on 18/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PKRevealController.h"
#import "LeftMenuController.h"

@interface JXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) PKRevealController *revealController;
@property (strong, nonatomic) LeftMenuController *leftMenuViewController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)updateFrontViewControllerWithController:(UIViewController *)controller andFocus:(BOOL)focus;


@end

