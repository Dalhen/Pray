//
//  SignupController.h
//  Pray
//
//  Created by Jason LAPIERRE on 26/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SignupController : BaseViewController <UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIScrollViewDelegate> {
    
    UIScrollView *mainScroll;
    
    UIImageView *profileImage;
    UITextField *profileUsername;
    UITextField *profileFirstName;
    UITextField *profileLastName;
    UITextField *profilePassword;
    UITextField *profileEmail;
    UITextView *profileBlob;
    
    UIView *panelView;
    UITableView *panelTable;
    
    UIImage *selectedImage;
}

@end
