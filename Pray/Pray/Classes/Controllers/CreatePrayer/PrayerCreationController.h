//
//  PrayerCreationController.h
//  Pray
//
//  Created by Jason LAPIERRE on 17/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface PrayerCreationController : UIViewController <CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextViewDelegate> {
    
    UIImageView *prayerImage;
    UIView *imageMask;
    UIImage *selectedImage;
    UITextView *prayerText;
    UIButton *addImageButton;
    
    BOOL typeStarted;
    
    BOOL userLocated;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSString *currentCityName;
}

@end
