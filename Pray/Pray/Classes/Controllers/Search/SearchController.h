//
//  SearchController.h
//  Pray
//
//  Created by Jason LAPIERRE on 28/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView *mainTable;
    UIRefreshControl *refreshControl;
    BOOL refreshing;
    
    NSArray *results;
}

@end
