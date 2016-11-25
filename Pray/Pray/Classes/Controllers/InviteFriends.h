//
//  InviteFriends.h
//  Pray
//
//  Created by Clement on 24/11/2016.
//  Copyright © 2016 Pray Ltd. All rights reserved.
//

#ifndef InviteFriends_h
#define InviteFriends_h

#import "BaseViewController.h"
#import "PrayerCell.h"
#import "PrayerCreationController.h"

@interface InviteFriends : UIViewController <UIActionSheetDelegate> {
    
    UIButton *feedButton;
    UIButton *followingButton;
    UITableView *mainTable;
    UIImageView *logoImage;
    UILabel *titleLabel;
    UIView *bottomView;
    UITextField *emailField;
    UITextField *passwordField;

}

@end

#endif /* InviteFriends_h */
