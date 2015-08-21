//
//  PrayerCreationController.m
//  Pray
//
//  Created by Jason LAPIERRE on 17/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "PrayerCreationController.h"

@interface PrayerCreationController ()

@end

@implementation PrayerCreationController


- (id)init {
    self = [super init];
    
    if (self) {
        typeStarted = NO;
    }
    
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:Colour_PrayDarkBlue];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupHeader];
    [self setupLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [prayerText addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated {
    [prayerText removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (void)setupHeader {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, 56*sratio)];
    [headerView setBackgroundColor:Colour_PrayDarkBlue];
    [self.view addSubview:headerView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(58*sratio, 20*sratio, 162*sratio, 26*sratio)];
    titleLabel.text = LocString(@"Post a prayer");
    titleLabel.font = [FontService systemFont:14*sratio];
    titleLabel.textColor = Colour_White;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake(self.view.screenWidth - 86*sratio, 20*sratio, 74*sratio, 30*sratio);
    [postButton setTitle:LocString(@"Post") forState:UIControlStateNormal];
    [postButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [postButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [postButton.layer setCornerRadius:5.0f];
    postButton.backgroundColor = Colour_PrayBlue;
    [postButton addTarget:self action:@selector(postPrayer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postButton];
}

- (void)setupLayout {
    [self.view setBackgroundColor:Colour_255RGB(61, 66, 78)];
    
    prayerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 56*sratio, self.view.screenWidth, self.view.screenHeight - 56*sratio)];
    [prayerImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:prayerImage];
    
    imageMask = [[UIView alloc] initWithFrame:prayerImage.frame];
    [imageMask setBackgroundColor:Colour_BlackAlpha(0.3)];
    imageMask.alpha = 0.0f;
    [self.view addSubview:imageMask];
    
    prayerText = [[UITextView alloc] initWithFrame:CGRectMake((self.view.screenWidth - 285*sratio)/2, 60*sratio, 285*sratio, 192*sratio)];
    [prayerText setBackgroundColor:Colour_Clear];
    [prayerText setTextColor:Colour_White];
    [prayerText setFont:[FontService systemFont:14*sratio]];
    [prayerText setText:LocString(@"Type your prayer here")];
    [prayerText setTextAlignment:NSTextAlignmentCenter];
    [prayerText setDelegate:self];
    [self.view  addSubview:prayerText];
    [prayerText becomeFirstResponder];
    
    addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImageButton setFrame:CGRectMake((self.view.screenWidth - 287*sratio)/2, 234*sratio, 287*sratio, 44*sratio)];
    [addImageButton setBackgroundImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
    [addImageButton setTitle:LocString(@"Add a background image") forState:UIControlStateNormal];
    [addImageButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [addImageButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addImageButton];
}

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark UIImagePicker delegates & Camera
- (void)takePhoto {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LocString(@"Select Photo Source")
                                                             delegate:self cancelButtonTitle:LocString(@"Cancel") destructiveButtonTitle:nil
                                                    otherButtonTitles:LocString(@"Photo Library"), LocString(@"Camera"), nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self setupCamera:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    
    else if (buttonIndex == 1) {
        [self setupCamera:UIImagePickerControllerSourceTypeCamera];
    }
    
    else if (buttonIndex == actionSheet.cancelButtonIndex) {
        
    }
}

- (void)setupCamera:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
    [cameraController setSourceType:sourceType];
    cameraController.delegate = self;
    cameraController.allowsEditing = YES;
    cameraController.navigationBarHidden = YES;
    cameraController.toolbarHidden = YES;
    
    [self presentViewController:cameraController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self gotPicture:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)gotPicture:(UIImage *)img {
	   
    [prayerImage setImage:img];
    selectedImage = img;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [UIView animateWithDuration:0.3 animations:^{
            imageMask.alpha = 1.0;
        }];
        
        [prayerText becomeFirstResponder];
    }];
}

- (UIImage *)resizePhoto:(UIImage *)originalImage newSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);// a CGSize that has the size you want
    [originalImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - UITextView delegates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEqualToString:@"\n"]) {
//        [prayerText resignFirstResponder];
//        return NO;
//    }
    
    if ([[textView.text stringByReplacingCharactersInRange:range withString:text] length] > 220) {
        return NO;
    }
    else if (!typeStarted && [textView.text isEqualToString:LocString(@"Type your prayer here")]) {
        typeStarted = YES;
        [textView setText:text];
        return NO;
    }
    
    return YES;
}


#pragma mark - Post Prayer
- (void)postPrayer {
    NSData *imageData = [self compressImage:selectedImage];
    [NetworkService postPrayerWithImage:imageData andText:prayerText.text];
}


#pragma mark - Helpers
- (NSData *)compressImage:(UIImage *)image {
    NSData *unCompressedImage = UIImageJPEGRepresentation(image, 1.0);
    if ([unCompressedImage length]<1000*MAXImageKbSizeBeforeCompression) {
        return unCompressedImage;
    }
    else return UIImageJPEGRepresentation(image, POSTImageQuality);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
