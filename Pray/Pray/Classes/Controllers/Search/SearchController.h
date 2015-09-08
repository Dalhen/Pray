//
//  SearchController.h
//  Pray
//
//  Created by Jason LAPIERRE on 28/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrayerCell.h"
#import "UserCell.h"


@interface SearchController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, PrayerCellDelegate, SWTableViewCellDelegate, UserCellDelegate> {
    
    UISegmentedControl *segmentControl;
    BOOL isSearchingPeople;
    //UISearchBar *search;
    UITextField *search;
    
    UITableView *mainTable;
    UIRefreshControl *refreshControl;
    BOOL refreshing;
    
    NSArray *searchResults;
    
    CGSize keyboardSize;
    
    SWTableViewCell *currentlyEditedCell;
    UIAlertView *reportPostAlert;
}

@end
