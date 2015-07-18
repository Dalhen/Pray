//
//  UIAlertView+Extensions.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "UIAlertView+Extensions.h"

/*-----------------------------------------------------------------------------------------------------*/

@implementation UIAlertView (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - alerts
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIAlertView *)showAlertWithTitle:(NSString *)title
                        andMessage:(NSString *)message;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
    [alertView show];
    return alertView;
}

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)alertTitle
                             andMessage:(NSString *)alertText
                               delegate:(id <UIAlertViewDelegate>)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertText
                                                   delegate:delegate
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    return alert;
}

@end
