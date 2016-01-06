//
//  FeedController.h
//  Pray
//
//  Created by Jason LAPIERRE on 29/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "PrayerCell.h"
#import "PrayerCreationController.h"

@interface FeedController : UIViewController <UITableViewDataSource, UITableViewDelegate, PrayerCellDelegate, SWTableViewCellDelegate, PrayerCreationDelegate, UIDocumentInteractionControllerDelegate, UIActionSheetDelegate> {
 
    UIView *switchMenu;
    UIButton *feedButton;
    UIButton *followingButton;
    UITableView *mainTable;
    UIRefreshControl *refreshControl;
    BOOL refreshing;
    BOOL showDiscover;
    BOOL displayingSwitchMenu;
    
    NSMutableArray *prayers;
    
    NSInteger currentPage;
    NSInteger maxMomentPerPage;
    NSInteger maxPagesCount;
    
    UIButton *addPrayerButton;
    
    SWTableViewCell *currentlyEditedCell;
    UIAlertView *deletePostAlert;
    UIAlertView *reportPostAlert;
    
    UIImage *sharedImage;
}

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end
