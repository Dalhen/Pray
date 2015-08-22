//
//  LeftMenuController.h
//  Pray
//
//  Created by Jason LAPIERRE on 26/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "BaseViewController.h"


@interface LeftMenuController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    int selectedLine;
}

@property(nonatomic, strong) UITableView *mainTable;

@end
