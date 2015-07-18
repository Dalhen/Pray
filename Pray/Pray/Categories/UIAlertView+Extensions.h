//
//  UIAlertView+Extensions.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@interface UIAlertView (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - alerts
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+(UIAlertView *)showAlertWithTitle:(NSString *)title
                        andMessage:(NSString *)message;
+ (UIAlertView *)showAlertViewWithTitle:(NSString *)alertTitle
                             andMessage:(NSString *)alertText
                               delegate:(id <UIAlertViewDelegate>)delegate;

@end
