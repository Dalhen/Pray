//
//  JXSingletonDefinitions.h
//
//
//  Created by Jason YL on 25/04/13.
//  Copyright (c) 2013 All rights reserved.
//

#import "JXUserService.h"
#import "JXCoreDataManager.h"
#import "JXDataAccess.h"

#define AppDelegate         ((JXAppDelegate *)[[UIApplication sharedApplication] delegate])
#define DeviceManager       [JXDeviceManager sharedInstance]
#define FontService         [JXFontService sharedInstance]
#define UserService         [JXUserService sharedInstance]
#define NetworkService      [JXNetworkService sharedInstance]
#define CoreDataManager     [JXCoreDataManager sharedInstance]
#define DataAccess          [JXDataAccess sharedInstance]

