//
//  BaseViewController.h
//  Grape
//
//  Created by Jason LAPIERRE on 07/10/2013.
//  Copyright (c) 2013 - All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    typeStatus,
    typeImage,
    typeVideo,
    typeAudio,
    typeLocation,
    typeEvent,
    typeAlbum,
} MomentType;

@interface BaseViewController : UIViewController {
    
    UILabel *navTitle;
}

- (void)setupNavigationBar;
- (void)setupCustomBackButton;
- (void)setupPlainNavBar;
- (void)setupTransparentNavBar;
- (void)setupTitle:(NSString *)titleText;
- (void)setupCustomBackButtonHighlighted:(BOOL)isHighlighted;
- (void)setupAsModal;
- (void)closeModal;

@end
