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
    UITextField *profileCompany;
    UITextField *profileDepartment;
    UITextField *profilePosition;
    UITextField *profileEmail;
    UITextView *profileBlob;
    
    NSArray *departmentsArray;
    NSDictionary *selectedDepartment;
    UIView *panelView;
    UITableView *panelTable;
    
    NSString *tempProfileURL;
    NSString *tempFirstName;
    NSString *tempLastName;
    NSString *tempEmail;
    NSString *tempBlob;
    
    NSString *linkedInID;
    NSString *linkedProfileURL;
    NSString *companyID;
    NSString *companyLogoURL;
    UIImage *selectedImage;
    
    BOOL isSigningUp;
    BOOL isProfileViewing;
    
    NSDictionary *profileToView;
}

@end
