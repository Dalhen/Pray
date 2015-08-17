//
//  AppDelegate.h
//  Pray
//
//  Created by Jason LAPIERRE on 18/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LeftMenuController.h"

@class PKRevealController;

@interface JXAppDelegate : UIResponder <UIApplicationDelegate> {
    
    UIButton *notificationPopup;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong, readwrite) PKRevealController *revealController;
@property (strong, nonatomic) LeftMenuController *leftMenuViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)updateFrontViewControllerWithController:(UIViewController *)controller andFocus:(BOOL)focus;


#pragma mark - Main Views
- (void)displayPrehome;
- (void)displayMainView;


#pragma mark - Push Notifications
- (void)launchPushNotifications;

@end

