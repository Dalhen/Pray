//
//  JXDeviceFactory.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

typedef enum {
    JXDeviceType_iPhone480,
    JXDeviceType_iPhone568,
    JXDeviceType_iPad,
}JXDeviceType;

/*-----------------------------------------------------------------------------------------------------*/

@interface JXDeviceManager : NSObject
@property (nonatomic, unsafe_unretained) JXDeviceType deviceType;
@property (nonatomic, unsafe_unretained, readonly) BOOL isRetina;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - instance
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (JXDeviceManager *)sharedInstance;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - utility
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(BOOL)isIpad;
-(BOOL)isIphone480;
-(BOOL)isIphone568;

@end
