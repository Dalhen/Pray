//
//  PrayerCreationController.m
//  Pray
//
//  Created by Jason LAPIERRE on 17/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "PrayerCreationController.h"
#import "MentionCell.h"

@interface PrayerCreationController ()

@end

@implementation PrayerCreationController
@synthesize delegate;


- (id)init {
    self = [super init];
    
    if (self) {
        typeStarted = NO;
        mentionsAdded = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithUser:(CDUser *)user {
    self = [super init];
    
    if (self) {
        typeStarted = NO;
        currentUser = user;
        mentionsAdded = [[NSMutableArray alloc] init];
        
        [mentionsAdded addObject:@{@"userObject":currentUser, @"mentionIndex":[NSNumber numberWithInteger:0]}];
    }
    
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:Colour_PrayDarkBlue];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupHeader];
    [self setupLayout];
    [self setupMentionsView];
    
    if (currentUser) {
        [prayerText setText:[NSString stringWithFormat:@"@%@ ", currentUser.username]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForEvents];
    
    [self checkLocation];
    //[prayerText addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unRegisterForEvents];
//    [prayerText removeObserver:self forKeyPath:@"contentSize"];
}


#pragma mark - Events registration
- (void)registerForEvents {
    Notification_Observe(JXNotification.UserServices.AutocompleteSuccess, searchForMentionUsersSuccess:);
    Notification_Observe(JXNotification.UserServices.AutocompleteFailed, searchForMentionUsersFailed);
    Notification_Observe(JXNotification.PostServices.PostPrayerSuccess, postPrayerSuccess);
    Notification_Observe(JXNotification.PostServices.PostPrayerFailed, postPrayerFailed);
    
    Notification_Observe(UIKeyboardWillShowNotification, keyboardWillShow:);
    Notification_Observe(UIKeyboardWillHideNotification, keyboardWillHide:);
}

- (void)unRegisterForEvents {
    Notification_Remove(JXNotification.UserServices.AutocompleteSuccess);
    Notification_Remove(JXNotification.UserServices.AutocompleteFailed);
    Notification_Remove(JXNotification.PostServices.PostPrayerSuccess);
    Notification_Remove(JXNotification.PostServices.PostPrayerFailed);
    
    Notification_Remove(UIKeyboardWillShowNotification);
    Notification_Remove(UIKeyboardWillHideNotification);
    
    Notification_RemoveObserver;
}


#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyBoardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardSize = keyBoardSize;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyBoardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardSize = keyBoardSize;
}


#pragma mark - Layout + TextView listeners
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    UITextView *tv = object;
//    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
//    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
//    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
//}

- (void)setupHeader {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, 56*sratio)];
    [headerView setBackgroundColor:Colour_PrayDarkBlue];
    [self.view addSubview:headerView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(78*sratio, 20*sratio, 162*sratio, 26*sratio)];
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
    [self.view setBackgroundColor:Colour_White];//Colour_255RGB(61, 66, 78)];
    
    prayerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 56*sratio, self.view.screenWidth, self.view.screenHeight - 56*sratio)];
    [prayerImage setContentMode:UIViewContentModeScaleAspectFill];
    selectedImage = [self imageFromRandomColor];
    [prayerImage setImage:selectedImage];
    [self.view addSubview:prayerImage];
    
    imageMask = [[UIView alloc] initWithFrame:prayerImage.frame];
    [imageMask setBackgroundColor:Colour_BlackAlpha(0.3)];
    imageMask.alpha = 0.0f;
    [self.view addSubview:imageMask];
    
    prayerText = [[UITextView alloc] initWithFrame:CGRectMake((self.view.screenWidth - 285*sratio)/2, 64*sratio - (ISIPHONE4()? 6 : 0), 285*sratio, 140*sratio)];
    [prayerText setBackgroundColor:Colour_Clear];
    [prayerText setTextColor:Colour_255RGB(61, 66, 78)];//Colour_White];
    [prayerText setFont:[FontService systemFont:14*sratio]];
    //[prayerText setText:LocString(@"Type your prayer here")];
    [prayerText setTextAlignment:NSTextAlignmentCenter];
    [prayerText setDelegate:self];
    [self.view  addSubview:prayerText];
    [prayerText becomeFirstResponder];
    
    addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImageButton setFrame:CGRectMake((self.view.screenWidth - 184*sratio)/2, 234*sratio - (ISIPHONE4()? 60 : 0), 184*sratio, 38*sratio)];
    [addImageButton setBackgroundImage:[UIImage imageNamed:@"addImageButtonDark"] forState:UIControlStateNormal];
    [addImageButton setTitle:LocString(@"Add a background image") forState:UIControlStateNormal];
    [addImageButton setTitleColor:Colour_255RGB(61, 66, 78) forState:UIControlStateNormal];
    [addImageButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    addImageButton.titleLabel.font = [FontService systemFont:13*sratio];
    [addImageButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addImageButton];
    
    selectReligionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectReligionButton setFrame:CGRectMake((self.view.screenWidth - 98*sratio)/2, addImageButton.bottom + 16*sratio - (ISIPHONE4()? 8 : 0), 98*sratio, 38*sratio - (ISIPHONE4()? 4 : 0))];
    [selectReligionButton setBackgroundImage:[UIImage imageNamed:@"selectReligionButtonDark"] forState:UIControlStateNormal];
    [selectReligionButton setTitle:LocString(@"Select religion") forState:UIControlStateNormal];
    [selectReligionButton setTitleColor:Colour_255RGB(61, 66, 78) forState:UIControlStateNormal];
    [selectReligionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    selectReligionButton.titleLabel.font = [FontService systemFont:13*sratio];
    [selectReligionButton addTarget:self action:@selector(displayReligionSelector) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectReligionButton];
    
    religionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.screenWidth - 12*sratio - 38*sratio, self.view.screenHeight - keyboardSize.height - 12*sratio - 38*sratio, 34*sratio, 34*sratio)];
    [religionIcon setClipsToBounds:YES];
    [religionIcon setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:religionIcon];
}

- (void)setupMentionsView {
    mentionsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.screenHeight, self.view.screenWidth, 140) style:UITableViewStylePlain];
    [mentionsTable setDataSource:self];
    [mentionsTable setDelegate:self];
    [self.view addSubview:mentionsTable];
}

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Colors creation
- (UIImage *)imageFromRandomColor {
    UIColor *color = [self generateRandomColor];
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIColor *)generateRandomColor {
    NSArray *randomColors = [[NSArray alloc] initWithObjects:

                             Colour_255RGB(0, 31, 42),
                             Colour_255RGB(0, 0, 44),
                             Colour_255RGB(0, 0, 117),
                             Colour_255RGB(19, 19, 70),
                             Colour_255RGB(0, 31, 96),
                             Colour_255RGB(22, 165, 255),
                             Colour_255RGB(126, 191, 255),
                             Colour_255RGB(136, 199, 209),
                             Colour_255RGB(165, 93, 199),
                             Colour_255RGB(0, 112, 0),
                             Colour_255RGB(19, 113, 70),
                             Colour_255RGB(101, 163, 121),
                             Colour_255RGB(129, 200, 127),
                             Colour_255RGB(255, 135, 16),
                             Colour_255RGB(255, 150, 16),
                             Colour_255RGB(255, 171, 16),
                             Colour_255RGB(255, 214, 0),
                             Colour_255RGB(255, 0, 30),
                             Colour_255RGB(255, 86, 86),
                             Colour_255RGB(255, 117, 117),
                             Colour_255RGB(218, 40, 150),
                             Colour_255RGB(233, 118, 161),
                             
                             nil];
    
    return [randomColors objectAtIndex: arc4random() % [randomColors count]];
}


#pragma mark - Religion selection
- (void)displayReligionSelector {
    ReligionSelectorController *religionSelector = [[ReligionSelectorController alloc] init];
    [religionSelector setDelegate:self];
    [self.navigationController pushViewController:religionSelector animated:YES];
}

- (void)religionSelectedWithIndex:(NSInteger)index {
    religionType = index;
    
    NSArray *religionsImages = [[NSArray alloc] initWithObjects:
                                LocString(@""),
                                LocString(@"chrisIcon.png"),
                                LocString(@"islamIcon.png"),
                                LocString(@"hinduIcon.png"),
                                LocString(@"buddhismIcon.png"),
                                LocString(@"shintoIcon.png"),
                                LocString(@"sikhIcon.png"),
                                LocString(@"judaismIcon.png"),
                                LocString(@"jainismIcon.png"),
                                LocString(@"bahaiIcon.png"),
                                LocString(@"caodaism.png"),
                                LocString(@"cheondoIcon.png"),
                                LocString(@"tenrikyoIcon.png"),
                                LocString(@"wiccaIcon.png"),
                                LocString(@"messiaIcon.png"),
                                LocString(@"seichoIcon.png"),
                                LocString(@"atheismIcon.png"), nil];
    
    [selectReligionButton setTitle:LocString(@"Modify religion") forState:UIControlStateNormal];
    [religionIcon setFrame:CGRectMake(self.view.screenWidth - 12*sratio - 38*sratio, self.view.screenHeight - keyboardSize.height - 12*sratio - 38*sratio, 34*sratio, 34*sratio)];
    [religionIcon setImage:[UIImage imageNamed:[religionsImages objectAtIndex:religionType]]];
}


#pragma mark - Location management
- (void)checkLocation {
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 500;
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    //DENIED
    if (status == kCLAuthorizationStatusDenied) {
        [SVProgressHUD dismiss];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocString(@"Location disabled!") message:LocString(@"Pray needs your location to share it with your prayers. Please turn location services back on in your phone settings. To do so, go to Settings > Privacy > Location Services.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    //NOT DETERMINED
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self startLocationManager];
    }
    
    //ACCEPTED
    else {
        [self startLocationManager];
    }
}

- (void)startLocationManager {
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
}


#pragma mark - LocationManager & MapKit Delegates
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (!userLocated) {
        userLocated = YES;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
        [self updateLocationNameFromLocation:location];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    
    if (error.domain == kCLErrorDomain && error.code == kCLErrorDenied) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocString(@"Location disabled!") message:LocString(@"Pray needs your location to share it with your prayers. Please turn location services back on in your phone settings. To do so, go to Settings > Privacy > Location Services.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - Location name & Google API
- (void)updateLocationNameFromLocation:(CLLocation *)location {
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count]>0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            currentCityName = [placemark.addressDictionary objectForKey:@"City"];
            currentLocation = placemark.location;
        }
    }];
}


#pragma mark UIImagePicker delegates & Camera
- (void)takePhoto {
    
    [prayerText resignFirstResponder];
    
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
        [prayerText becomeFirstResponder];
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
        
        [prayerText becomeFirstResponder];
    }];
}

- (void)gotPicture:(UIImage *)img {
	   
    [prayerImage setImage:img];
    [self.view setBackgroundColor:Colour_255RGB(61, 66, 78)];
    [prayerText setTextColor:Colour_White];
    [addImageButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [selectReligionButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [addImageButton setBackgroundImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
    [selectReligionButton setBackgroundImage:[UIImage imageNamed:@"selectReligionButton"] forState:UIControlStateNormal];
    
    selectedImage = img;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [UIView animateWithDuration:0.3 animations:^{
            imageMask.alpha = 1.0;
        }];
        
        [addImageButton setTitle:LocString(@"Change background image") forState:UIControlStateNormal];
        
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


#pragma mark - Tagging (Autocomplete)
- (void)autocompleteSuccess:(NSNotification *)notification {
    mentions = [[NSArray alloc] initWithArray:notification.object];
    [mentionsTable reloadData];
    [mentionsTable setContentOffset:CGPointZero animated:YES];
}


#pragma mark - UITextView delegates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEqualToString:@"\n"]) {
//        [prayerText resignFirstResponder];
//        return NO;
//    }
    
    addedSpaceCharacter = ([text isEqualToString:@" "])? YES : NO;
    addedArobaseCharacter = ([text isEqualToString:@"@"])? YES : NO;
    removedSpaceCharacter = ([[textView.text substringWithRange:range] isEqualToString:@" "])? YES : NO;
    removedArobaseCharacter = ([[textView.text substringWithRange:range] isEqualToString:@"@"])? YES : NO;
    
    if ([[textView.text stringByReplacingCharactersInRange:range withString:text] length] > 220) {
        return NO;
    }
    else if (!typeStarted) {
        typeStarted = YES;
        [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:text]];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    //Mentions
    NSRange selectedRange = textView.selectedRange;
    
    UITextPosition *beginning = textView.beginningOfDocument;
    UITextPosition *start = [textView positionFromPosition:beginning offset:selectedRange.location];
    UITextPosition *end = [textView positionFromPosition:start offset:selectedRange.length];
    
    UITextRange* textRange = [textView.tokenizer rangeEnclosingPosition:end withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionLeft];
    
    //NSLog(@"Word that is currently being edited is : %@", [textView textInRange:textRange]);
    
    
    UITextPosition* selectionStart = textRange.start;
    UITextPosition* selectionEnd = textRange.end;
    
    const NSInteger location = [textView offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [textView offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    //Started typing a second letter after an @ or removed a letter in a word
    if (location>0 && !removedSpaceCharacter) {
        NSString *startingCharacter = [textView.text substringWithRange:NSMakeRange(location-1, 1)];
        
        //New tag or tag edition
        if ([startingCharacter isEqualToString:@"@"]) {
            isTagging = YES;
            
            if ((location > 1 && [[textView.text substringWithRange:NSMakeRange(location-2, 1)] isEqualToString:@" "]) || location == 1) {
                
                NSRegularExpression *mentionsExpression = [NSRegularExpression regularExpressionWithPattern:@"(@\\w+)" options:NO error:nil];
                NSArray *mentionsMatches = [mentionsExpression matchesInString:textView.text options:0 range:NSMakeRange(0, [textView.text length])];
                
                NSInteger mIndex = 0;
                for (NSTextCheckingResult *mentionMatch in mentionsMatches) {
                    NSRange mentionMatchRange = [mentionMatch rangeAtIndex:0];
                    if (mentionMatchRange.location == location-1 && mentionMatchRange.length == length+1) {
                        mIndex = [mentionsMatches indexOfObject:mentionMatch];
                    }
                }
                
                //[cancelCommentButton setHidden:YES];
                [self mentionStartedWithText:[textView textInRange:textRange] mentionIndex:mIndex andMentionTotal:[mentionsMatches count]];
            }
        }
    }
    else {
        if (addedArobaseCharacter) {
            isTagging = YES;
        }
        else if (isTagging) {
            isTagging = NO;
            
            if (addedSpaceCharacter) {
                [self mentionEnded];
            }
            else {
                [self mentionRemoved];
            }
            //[cancelCommentButton setHidden:NO];
        }
    }
}


#pragma mark - Mentions
- (void)mentionStartedWithText:(NSString *)text mentionIndex:(NSInteger)index andMentionTotal:(NSInteger)total {
    searchingForMentions = YES;
    currentMention = text;
    mentionIndex = index;
    mentionTotal = total;
    
    [NetworkService autocompleteForTag:text];
}

- (void)mentionRemoved {
    if (searchingForMentions) {
        if ([mentionsAdded count]>mentionIndex) {
            [mentionsAdded removeObjectAtIndex:mentionIndex];
        }
    }
    
    searchingForMentions = NO;
    [self hideMentionsList];
    [mentionsTable reloadData];
}

- (void)mentionEnded {
    if (searchingForMentions) {
        //editing existing mention
        if (mentionTotal == [mentionsAdded count]) {
            [mentionsAdded replaceObjectAtIndex:mentionIndex withObject:@{@"userObject":currentMention, @"mentionIndex":[NSNumber numberWithInteger:mentionIndex]}];
        }
        //adding fake mention
        else if (mentionTotal > [mentionsAdded count]) {
            [mentionsAdded insertObject:@{@"userObject":currentMention, @"mentionIndex":[NSNumber numberWithInteger:mentionIndex]} atIndex:mentionIndex];
        }
    }
    
    searchingForMentions = NO;
    [self hideMentionsList];
    [mentionsTable reloadData];
}

- (void)searchForMentionUsersSuccess:(NSNotification *)notification {
    mentions = [[NSArray alloc] initWithArray:notification.object];
    [mentionsTable reloadData];
    [mentionsTable setContentOffset:CGPointZero animated:YES];
    [self showMentionsList];
}

- (void)searchForMentionUsersFailed {
    
}

- (void)showMentionsList {
    [UIView animateWithDuration:0.3 animations:^{
        [mentionsTable setBottom:self.view.screenHeight - keyboardSize.height];
    }];
}

- (void)hideMentionsList {
    [UIView animateWithDuration:0.3 animations:^{
        [mentionsTable setTop:self.view.screenHeight];
    }];
}


#pragma mark - CommentsTableView delegate & datasource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46*sratio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([mentions count]>0? [mentions count] : 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([mentions count]>0) {
        MentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MentionCell"];
        
        if(!cell) {
            cell = [[MentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MentionCell"];
            [cell setBackgroundColor:Colour_White];
        }
        
        [cell setDetailsWithUserObject:[mentions objectAtIndex:indexPath.row]];
        
        return cell;
    }
    //disclaimer
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DisclaimerCell"];
        
        if(!cell) {
            cell = [[MentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DisclaimerCell"];
            [cell setBackgroundColor:Colour_White];
        }
        
        [cell.textLabel setText:LocString(@"No results.")];
        [cell.textLabel setTextColor:Colour_255RGB(206, 206, 206)];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([mentions count]>0) {
        CDUser *userObject = [mentions objectAtIndex:indexPath.row];
        NSDictionary *userMention = @{@"userObject":userObject, @"mentionIndex":[NSNumber numberWithInteger:mentionIndex]};
        
        //Inserting mention
        if (mentionTotal > [mentionsAdded count]) {
            [mentionsAdded insertObject:userMention atIndex:mentionIndex];
        }
        
        //Replacing mention
        if (mentionTotal == [mentionsAdded count]) {
            [mentionsAdded replaceObjectAtIndex:mentionIndex withObject:userMention];
        }
        
        //Updating comment box text to selected user
        NSRegularExpression *mentionsExpression = [NSRegularExpression regularExpressionWithPattern:@"(@\\w+)" options:NO error:nil];
        NSArray *mentionsMatches = [mentionsExpression matchesInString:prayerText.text options:0 range:NSMakeRange(0, [prayerText.text length])];
        
        NSTextCheckingResult *mentionMatch = [mentionsMatches objectAtIndex:mentionIndex];
        NSRange mentionMatchRange = [mentionMatch rangeAtIndex:0];
        
        NSMutableString *commentStr = [[NSMutableString alloc] initWithString:prayerText.text];
        
//        NSString *unfilteredString = [userObject.firstname capitalizedString];
//        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
//        NSString *filteredString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
//[commentStr replaceCharactersInRange:mentionMatchRange withString:[NSString stringWithFormat:@"@%@", filteredString]];
        
        NSString *username = userObject.username;
        [commentStr replaceCharactersInRange:mentionMatchRange withString:[NSString stringWithFormat:@"@%@", username]];
        [prayerText setText:commentStr];
        
        //Closing search box
        searchingForMentions = NO;
        [self hideMentionsList];
        [mentionsTable reloadData];
    }
}


#pragma mark - Post Prayer
- (void)postPrayer {
    NSData *imageData = [self compressImage:selectedImage];
    [SVProgressHUD showWithStatus:LocString(@"Sharing your prayer...") maskType:SVProgressHUDMaskTypeGradient];
    
    searchingForMentions = NO;
    [self hideMentionsList];
    
    NSMutableArray *finalMentions = [[NSMutableArray alloc] initWithCapacity:[mentionsAdded count]];
    for (NSDictionary *mentionObject in mentionsAdded) {
        //User mention
        if ([[mentionObject objectForKey:@"userObject"] isKindOfClass:[CDUser class]]) {
            CDUser *userObject = [mentionObject objectForKey:@"userObject"];
            NSString *mentionString = [userObject.uniqueId stringValue];
            [finalMentions addObject:mentionString];
        }
    }
    
    NSString *currentLatitude = [NSString stringWithFormat:@"%3.6f", currentLocation.coordinate.latitude];
    NSString *currentLongitude = [NSString stringWithFormat:@"%3.6f", currentLocation.coordinate.longitude];
    
    [NetworkService postPrayerWithImage:imageData
                                   text:prayerText.text
                           religionType:[NSString stringWithFormat:@"%li", (long)religionType]
                      withMentionString:[finalMentions componentsJoinedByString:@","]
                               latitude:currentLatitude? currentLatitude : @""
                              longitude:currentLongitude? currentLongitude : @""
                        andLocationName:currentCityName? currentCityName : @""];
}

- (void)postPrayerSuccess {
    [SVProgressHUD showSuccessWithStatus:LocString(@"Your prayer has been shared.")];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([delegate respondsToSelector:@selector(refreshTriggered)]) {
            [delegate refreshTriggered];
        }
    }];
}

- (void)postPrayerFailed {
    [SVProgressHUD showErrorWithStatus:LocString(@"Your prayer couldn't be shared. Please check your connection and try again.")];
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
