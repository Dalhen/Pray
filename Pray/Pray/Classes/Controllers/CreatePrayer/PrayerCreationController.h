//
//  PrayerCreationController.h
//  Pray
//
//  Created by Jason LAPIERRE on 17/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface PrayerCreationController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextViewDelegate> {
    
    UIImageView *prayerImage;
    UIView *imageMask;
    UIImage *selectedImage;
    UITextView *prayerText;
    UIButton *addImageButton;
    
    BOOL typeStarted;
}

@end
