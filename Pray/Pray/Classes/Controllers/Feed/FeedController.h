//
//  FeedController.h
//  Pray
//
//  Created by Jason LAPIERRE on 29/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "PrayerCell.h"

@interface FeedController : UIViewController <UITableViewDataSource, UITableViewDelegate, PrayerCellDelegate, SWTableViewCellDelegate> {
 
    UITableView *mainTable;
    UIRefreshControl *refreshControl;
    BOOL refreshing;
    
    NSMutableArray *prayers;
    
    NSInteger currentPage;
    NSInteger maxMomentPerPage;
    NSInteger maxPagesCount;
    
    UIButton *addPrayerButton;
    
    SWTableViewCell *currentlyEditedCell;
    UIAlertView *deletePostAlert;
    UIAlertView *reportPostAlert;
}

@end
