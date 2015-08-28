//
//  NotificationsController.h
//  Pray
//
//  Created by Jason LAPIERRE on 17/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface NotificationsController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView *mainTable;
    UIRefreshControl *refreshControl;
    BOOL refreshing;
    
    NSArray *notifications;
}

@end
