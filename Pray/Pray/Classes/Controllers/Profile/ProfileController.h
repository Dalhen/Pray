//
//  ProfileController.h
//  Pray
//
//  Created by Jason LAPIERRE on 17/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "PrayerCell.h"


@interface ProfileController : UIViewController <PrayerCellDelegate, UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate> {
    
    CDUser *currentUser;
    
    UIImageView *userAvatar;
    UILabel *usernameLabel;
    UILabel *userDescription;
    
    UILabel *userPrayers;
    UILabel *userFollowers;
    UILabel *userFollowing;
    
    UIView *profileHeader;
    
    UITableView *mainTable;
    UIRefreshControl *refreshControl;
    BOOL refreshing;
    
    NSMutableArray *prayers;
    NSInteger currentPage;
    NSInteger maxMomentPerPage;
    NSInteger maxPagesCount;
    
    SWTableViewCell *currentlyEditedCell;
    UIAlertView *deletePostAlert;
    UIAlertView *reportPostAlert;
}

- (id)initWithUser:(CDUser *)aUser;

@end
