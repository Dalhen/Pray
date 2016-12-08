//
//  PrayerCreationController.h
//  Pray
//
//  Created by Jason LAPIERRE on 17/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "ReligionSelectorController.h"
#import "ImageCropView.h"//

@protocol PrayerCreationDelegate <NSObject>

- (void)refreshTriggered;

@end

@interface PrayerCreationController : UIViewController <CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, ReligionSelectorDelegate, UITextViewDelegate> {
    
    UITableView *mentionsTable;
    
    UIImageView *prayerImage;
    UIView *imageMask;
    UIImage *selectedImage;
    UITextView *prayerText;
    UIButton *addImageButton;
    UIButton *selectReligionButton;
    
    BOOL typeStarted;
    
    BOOL userLocated;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSString *currentCityName;
    
    //Tagging
    BOOL removedSpaceCharacter;
    BOOL removedArobaseCharacter;
    BOOL addedSpaceCharacter;
    BOOL addedArobaseCharacter;
    BOOL isTagging;
    
    BOOL searchingForMentions;
    NSArray *mentions;
    NSMutableArray *mentionsAdded;
    NSInteger mentionIndex;
    NSInteger mentionTotal;
    NSString *currentMention;
    
    CGSize keyboardSize;
    
    //Praying for
    CDUser *currentUser;

    NSInteger religionType;
    UIImageView *religionIcon;
    
    ImageCropView *imageCropView;
}

@property(nonatomic, assign) id <PrayerCreationDelegate> delegate;


- (id)initWithUser:(CDUser *)user;

@end
