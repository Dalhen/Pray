//
//  UIViewController+Messaging.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UIViewController+Extensions.h"
#import "UIAlertView+Extensions.h"

@implementation UIViewController (Extensions)


#pragma mark - mails
-(void)showMailViewWithSubject:(NSString *)subject
                  toRecipients:(NSArray *)toRecipients
                  ccRecipients:(NSArray *)ccRecipients
                 bccRecipients:(NSArray *)bccRecipients
                    attachData:(NSArray *)dataArray
                     dataTypes:(NSArray *)dataTypesArray
                 dataFileNames:(NSArray *)dataFileNames
                   messageBody:(NSString *)messageBody
                        isHTML:(BOOL)isHTML
{
    if ([MFMailComposeViewController canSendMail])
        {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        if (subject.isValidString)
            {
            [picker setSubject:subject];
            }
        if (toRecipients.isValidObject)
            {
            [picker setToRecipients:toRecipients];
            }
        if (ccRecipients.isValidObject)
            {
            [picker setCcRecipients:ccRecipients];
            }
        if (bccRecipients.isValidObject)
            {
            [picker setBccRecipients:bccRecipients];
            }
        
        if (dataArray.isValidObject)
            {
            int index = 0;
            for (NSData *data in dataArray)
                {
                [picker addAttachmentData:data
                                 mimeType:dataFileNames[index]
                                 fileName:dataFileNames[index]];
                
                index++;
                }
            }
        
        if (messageBody.isValidString)
            {
            [picker setMessageBody:messageBody
                            isHTML:isHTML];
            
            }
        
        [self presentViewController:picker
                                animated:YES completion:nil];
        }
    else
        {
        [UIAlertView showAlertWithTitle:@"Could not send mail"
                             andMessage:@"This device is not currently configured for sending mails. Please add mail accounts into your device configuration and try again later."];
        }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    if (result == MFMailComposeResultFailed)
        {
        [UIAlertView showAlertWithTitle:@"Could not send mail"
                             andMessage:@"Please check your internet availability and try again later."];
        }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - numbers
- (void)callNumber:(NSString *)number
{
    NSURL *numberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", number]];
    if ([[UIApplication sharedApplication] canOpenURL:numberUrl])
        {
        [[UIApplication sharedApplication] openURL:numberUrl];
        }
}

#pragma mark - maps
- (void)openAddress:(NSString *)address
{
    NSURL *numberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?q=%@", address]];
    if ([[UIApplication sharedApplication] canOpenURL:numberUrl])
        {
        [[UIApplication sharedApplication] openURL:numberUrl];
        }
}

#pragma mark - website
- (void)openWebsite:(NSString *)website
{
    if (![website hasPrefix:@"http"])
    {
        website = [NSString stringWithFormat:@"https://%@", website];
    }
    NSURL *websiteUrl = [NSURL URLWithString:website];
    if ([[UIApplication sharedApplication] canOpenURL:websiteUrl])
    {
        [[UIApplication sharedApplication] openURL:websiteUrl];
    }
}

@end
