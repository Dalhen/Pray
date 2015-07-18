//
//  UIViewController+Messaging.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface UIViewController (Extensions) <MFMailComposeViewControllerDelegate>

#pragma mark - mails
-(void)showMailViewWithSubject:(NSString *)subject
                  toRecipients:(NSArray *)toRecipients
                  ccRecipients:(NSArray *)ccRecipients
                 bccRecipients:(NSArray *)bccRecipients
                    attachData:(NSArray *)dataArray
                     dataTypes:(NSArray *)dataTypesArray
                 dataFileNames:(NSArray *)dataFileNames
                   messageBody:(NSString *)messageBody
                        isHTML:(BOOL)isHTML;

#pragma mark - numbers
- (void)callNumber:(NSString *)number;

#pragma mark - maps
- (void)openAddress:(NSString *)address;

#pragma mark - website
- (void)openWebsite:(NSString *)website;

@end
