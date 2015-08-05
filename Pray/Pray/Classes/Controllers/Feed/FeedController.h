//
//  FeedController.h
//  Pray
//
//  Created by Jason LAPIERRE on 29/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "PrayerCell.h"

@interface FeedController : BaseViewController <UITableViewDataSource, UITableViewDelegate, PrayerCellDelegate> {
 
    UITableView *mainTable;
    UIRefreshControl *refreshControl;
    BOOL refreshing;
    
    NSMutableArray *prayers;
    
    NSInteger currentPage;
    NSInteger maxMomentPerPage;
    NSInteger maxPagesCount;
}

@end
