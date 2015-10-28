//
//  AppDelegate.m
//  Pray
//
//  Created by Jason LAPIERRE on 18/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "JxAppDelegate.h"
#import <Parse/Parse.h>
#import "WelcomeController.h"
#import "FeedController.h"
#import "PKRevealController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define ParseAppID @"EqAODz0M3ylafH0njkPSXuZVC3AJC0CuXHHa0MvY"
#define ParseClientKEY @"qZdatXWjpE1mdfLhoLhiEuyKAlzRTutxZU5Mm5w2"

@interface JXAppDelegate ()

@end

@implementation JXAppDelegate
@synthesize window;
@synthesize navigationController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setupParse];
    [self setupWindow];
    [self launchApp];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


#pragma mark - Setup
- (void)setupWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
}

- (void)setupParse {
    [Parse setApplicationId:ParseAppID clientKey:ParseClientKEY];
}

- (void)launchPushNotifications {
    // Register for Push Notitications, if running iOS 8
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                               UIRemoteNotificationTypeAlert |
                                                                               UIRemoteNotificationTypeSound)];
    }
}


#pragma mark - Starting App
- (void)launchApp {
    
    if ([UserService isUserLoggedIn]) {
        [self launchPushNotifications];
        [self displayMainView];
    }
    else {
        [self displayPrehome];
    }
}

- (void)displayPrehome {
    WelcomeController *welcomeController = [[WelcomeController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:welcomeController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
}

- (void)displayMainView {
    self.leftMenuViewController = [[LeftMenuController alloc] init];
    FeedController *feedController = [[FeedController alloc] init];
    [self loadRootViewController:feedController];
}


#pragma mark - PKReveal delegates
- (void)loadRootViewController:(UIViewController *)newViewController {
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newViewController];
    navController.navigationBar.barTintColor = Colour_PrayDarkBlue;
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:navController leftViewController:self.leftMenuViewController];
    [self.revealController setRecognizesPanningOnFrontView:NO];
    self.window.rootViewController = self.revealController;
    [self.window makeKeyAndVisible];
}

- (void)updateFrontViewControllerWithController:(UIViewController *)controller andFocus:(BOOL)focus {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    if (!ISIOS6()) navController.navigationBar.barTintColor = Colour_PrayDarkBlue;
    [self.revealController setFrontViewController:navController];
    [self.revealController resignPresentationModeEntirely:YES animated:YES completion:nil];
}



#pragma mark - Push notifications delegates
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
        [self launchedFromNotification:[userInfo objectForKey:@"cdata"]];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    if ([UserService getUserID]) {
        [NetworkService updateDeviceToken:deviceToken];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (debugMode) NSLog(@"App failed to register for push notifications. Error: %@", [error description]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[PFPush handlePush:userInfo];
    
    //App was in the background
    if (application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground) {
        [self launchedFromNotification:[userInfo objectForKey:@"cdata"]];
    }
    
    //App was in the foreground
    else {
        NSDictionary *notificationInfo = [userInfo objectForKey:@"cdata"];
        switch ([[notificationInfo objectForKey:@"type"] intValue]) {
                
//                //New message
//            case 1:
//                Notification_Post(JXNotification.PushNotificationServices.NewMessages, nil);
//                break;
//                
//                //New match confirmed
//            case 2:
//                [[[UIAlertView alloc] initWithTitle:LocString(@"New lunch") message:LocString(@"You have a new lunch confirmed!") delegate:nil cancelButtonTitle:LocString(@"Ok") otherButtonTitles:nil] show];
//                Notification_Post(JXNotification.PushNotificationServices.NewMeeting, nil);
//                break;
//                
//                //Match cancelled
//            case 3:
//                [[[UIAlertView alloc] initWithTitle:LocString(@"Lunch canceled") message:LocString(@"One of your lunches has been canceled!") delegate:nil cancelButtonTitle:LocString(@"Ok") otherButtonTitles:nil] show];
//                Notification_Post(JXNotification.PushNotificationServices.NewMeeting, nil);
//                break;
//                
//                //Match updated
//            case 4:
//                [[[UIAlertView alloc] initWithTitle:LocString(@"Lunch updated") message:LocString(@"The time of one of your lunches has been changed!") delegate:nil cancelButtonTitle:LocString(@"Ok") otherButtonTitles:nil] show];
//                Notification_Post(JXNotification.PushNotificationServices.NewMeeting, nil);
//                break;
                
                
            default:
                break;
        }
    }
}

- (void)launchedFromNotification:(NSDictionary *)notification {
    switch ([[notification objectForKey:@"notification_type"] intValue]) {
            
            //Comment a prayer
        case 1:
            
            break;
            
            //Like a prayer
        case 2:
            
            break;
            
            //Tags in a prayer
        case 3:
            break;
            
            //Tags in a comment
        case 4:
            break;
            
            
        default:
            break;
    }
}

- (void)showNotificationPopupWithText:(NSString *)text {
    if (!notificationPopup) {
        notificationPopup = [UIButton buttonWithType:UIButtonTypeCustom];
        [notificationPopup setFrame:CGRectMake(0, -65, self.window.width, 65)];
        [notificationPopup setBackgroundColor:Colour_PrayBlue];
        [notificationPopup setTitleColor:Colour_White forState:UIControlStateNormal];
        [notificationPopup.titleLabel setFont:[FontService systemFontBold:13]];
    }
    
    [notificationPopup setTitle:text forState:UIControlStateNormal];
    [[[self.window subviews] lastObject] addSubview:notificationPopup];
    
    [UIView animateWithDuration:0.3 animations:^{
        [notificationPopup setTop:0];
    } completion:^(BOOL finished) {
        [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(hideNotificationPanel) userInfo:nil repeats:NO];
    }];
}

- (void)hideNotificationPanel {
    [UIView animateWithDuration:0.3 animations:^{
        [notificationPopup setTop:-65];
    } completion:^(BOOL finished) {
        [notificationPopup removeFromSuperview];
    }];
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.pray.Pray" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Pray" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Pray.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
