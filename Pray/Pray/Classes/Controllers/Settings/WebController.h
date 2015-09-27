//
//  WebController.h
//  Pray
//
//  Created by Jason LAPIERRE on 27/09/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface WebController : BaseViewController {
    
    NSString *urlString;
}

- (id)initWithURL:(NSString *)url;

@end
