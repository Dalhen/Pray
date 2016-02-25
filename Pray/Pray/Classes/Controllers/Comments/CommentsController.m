//
//  CommentsController.m
//  Pray
//
//  Created by Jason LAPIERRE on 21/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "CommentsController.h"
#import "NSString+Extensions.h"
#import "ProfileController.h"
#import "UIImageView+Rounded.h"
#import "UIImageView+WebCache.h"
#import "MentionCell.h"
#import "UsersListController.h"

@interface CommentsController ()

@end

@implementation CommentsController


- (id)initWithPrayer:(CDPrayer *)prayer andDisplayCommentsOnly:(BOOL)display {
    self = [super init];
    
    if (self) {
        currentPrayer = prayer;
        comments = [[NSMutableArray alloc] init];
        mentionsAdded = [[NSMutableArray alloc] init];
        sendingStack = [[NSMutableArray alloc] init];
        displayCommentsOnly = display;
    }
    
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupHeader];
    [self setupTableView];
    
    if (displayCommentsOnly) {
        [self.view setBackgroundColor:Colour_255RGB(244, 244, 244)];
        [self setupCommentBar];
        [self loadComments];
    }
    else {
        [commentsTable setBackgroundColor:Colour_PrayDarkBlue];
        [self.view setBackgroundColor:Colour_PrayDarkBlue];
    }
}

- (void)setupHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, 56*sratio)];
    [headerView setBackgroundColor:Colour_255RGB(232, 232, 232)];
    [self.view addSubview:headerView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(76*sratio, 20*sratio, 162*sratio, 26*sratio)];
    titleLabel.text = (displayCommentsOnly? LocString(@"Comments") : LocString(@"Prayer"));
    titleLabel.font = [FontService systemFont:14*sratio];
    titleLabel.textColor = Colour_255RGB(82, 82, 82);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)setupTableView {
    commentsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 56*sratio, self.view.screenWidth, self.view.screenHeight - 56*sratio - 58)];
    [commentsTable setBackgroundColor:Colour_255RGB(244, 244, 244)];
    [commentsTable setSeparatorColor:Colour_255RGB(244, 244, 244)];
    [commentsTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [commentsTable setScrollsToTop:YES];
    [commentsTable setDelegate:self];
    [commentsTable setDataSource:self];
    [self.view addSubview:commentsTable];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTriggered) forControlEvents:UIControlEventValueChanged];
    [refreshControl setTintColor:Colour_White];
    [commentsTable addSubview:refreshControl];
}

- (void)setupCommentBar {
    addCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.screenHeight-58, self.view.screenWidth, 58)];
    [addCommentView setBackgroundColor:Colour_PrayBlue];
    [self.view addSubview:addCommentView];
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 10, self.view.screenWidth - 58, 42)];
    commentTextView.backgroundColor = Colour_PrayBlue;
    commentTextView.delegate = self;
    [commentTextView setFont:[FontService systemFont:14*sratio]];
    [commentTextView setTextColor:Colour_White];
    [commentTextView setText:LocString(@"Write a comment")];
    [commentTextView setReturnKeyType:UIReturnKeyDefault];
    [addCommentView addSubview:commentTextView];
    
    sendCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendCommentButton setBackgroundColor:Colour_White];
    [sendCommentButton setFrame:CGRectMake(self.view.screenWidth - 58, 0, 58, 58)];
    [sendCommentButton setImage:[UIImage imageNamed:@"paperPlane"] forState:UIControlStateNormal];
    [sendCommentButton addTarget:self action:@selector(postComment) forControlEvents:UIControlEventTouchUpInside];
    [addCommentView addSubview:sendCommentButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForEvents];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unRegisterForEvents];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Events registration
- (void)registerForEvents {
    Notification_Observe(JXNotification.CommentsServices.GetPostCommentsSuccess, loadCommentsSuccess:);
    Notification_Observe(JXNotification.CommentsServices.GetPostCommentsFailed, loadCommentsFailed);
    Notification_Observe(JXNotification.CommentsServices.PostCommentSuccess, postCommentSuccess:);
    Notification_Observe(JXNotification.CommentsServices.PostCommentFailed, postCommentFailed:);
    Notification_Observe(JXNotification.CommentsServices.DeleteCommentSuccess, deleteCommentSuccess);
    Notification_Observe(JXNotification.CommentsServices.DeleteCommentFailed, deleteCommentFailed);
    Notification_Observe(JXNotification.UserServices.AutocompleteSuccess, searchForMentionUsersSuccess:);
    Notification_Observe(JXNotification.UserServices.AutocompleteFailed, searchForMentionUsersFailed);
    Notification_Observe(JXNotification.FeedServices.GetPrayerLikesListSuccess, getPrayerLikesSuccess:);
    Notification_Observe(JXNotification.FeedServices.GetPrayerLikesListFailed, getPrayerLikesFailed);
    
    Notification_Observe(UIKeyboardWillShowNotification, keyboardWillShow:);
    Notification_Observe(UIKeyboardWillHideNotification, keyboardWillHide:);
}

- (void)unRegisterForEvents {
    Notification_Remove(JXNotification.CommentsServices.GetPostCommentsSuccess);
    Notification_Remove(JXNotification.CommentsServices.GetPostCommentsFailed);
    Notification_Remove(JXNotification.CommentsServices.PostCommentSuccess);
    Notification_Remove(JXNotification.CommentsServices.PostCommentFailed);
    Notification_Remove(JXNotification.CommentsServices.DeleteCommentSuccess);
    Notification_Remove(JXNotification.CommentsServices.DeleteCommentFailed);
    Notification_Remove(JXNotification.FeedServices.GetPrayerLikesListSuccess);
    Notification_Remove(JXNotification.FeedServices.GetPrayerLikesListFailed);
    
    Notification_Remove(JXNotification.UserServices.AutocompleteSuccess);
    Notification_Remove(JXNotification.UserServices.AutocompleteFailed);
    
    Notification_Remove(UIKeyboardWillShowNotification);
    Notification_Remove(UIKeyboardWillHideNotification);
    
    Notification_RemoveObserver;
}


#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyBoardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardSize = keyBoardSize;
    
    [addCommentView setBottom:self.view.height - keyBoardSize.height];
    [commentsTable setHeight:addCommentView.top - 120];
    
    if (commentsTable.contentSize.height > self.view.height - 58 - 64) {
        CGPoint bottomOffset = CGPointMake(0, commentsTable.contentSize.height - commentsTable.bounds.size.height);
        [commentsTable setContentOffset:bottomOffset animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyBoardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardSize = keyBoardSize;
    [commentsTable setHeight:addCommentView.top - 120];
}


#pragma mark - LoadComments
- (void)refreshTriggered {
    [self loadComments];
}

- (void)loadComments {
    [NetworkService loadCommentsForPrayerID:[currentPrayer.uniqueId stringValue]];
}

- (void)loadCommentsSuccess:(NSNotification *)notification {
    refreshing = NO;
    
    //maxCommentsPerPage = [[notification.object objectForKey:@"page_size"] intValue];
    //maxPagesCount = [[notification.object objectForKey:@"page_count"] intValue];
    
    if (currentPage==0) {
        comments = [[NSMutableArray alloc] initWithArray:notification.object];
        if ([refreshControl isRefreshing]) [refreshControl endRefreshing];
        [commentsTable reloadData];
    }
    else {
        [comments addObjectsFromArray:notification.object];
        if ([refreshControl isRefreshing]) [refreshControl endRefreshing];
        [commentsTable reloadData];
    }
    
    [SVProgressHUD dismiss];
}

- (void)loadCommentsFailed {
    
}

- (void)refreshComments {
    comments = [[NSMutableArray alloc] initWithArray:[self sortComments:[DataAccess getCommentsForPrayer:currentPrayer.uniqueId]]];
    [commentsTable reloadData];
}

- (NSArray *)sortComments:(NSArray *)commentsToSort {
    return [commentsToSort sortedArrayUsingSelector:@selector(compareByID:)];
}


#pragma mark - Tagging (Autocomplete)
- (void)autocompleteSuccess:(NSNotification *)notification {
    mentions = [[NSArray alloc] initWithArray:notification.object];
    [commentsTable reloadData];
    [commentsTable setContentOffset:CGPointZero animated:YES];
}


#pragma mark - Post comment connection delegates
- (void)postComment {
    if (([commentTextView.text length] > 0 && [commentTextView isFirstResponder]) ||
        ![commentTextView.text isEqualToString:LocString(@"Write a comment")]) {
        
        searchingForMentions = NO;
        
        [self setTouchRecognizer:NO];
        
        NSManagedObjectContext *moc = [JXDataAccess getDBContext];
        CDComment *commentObject = (CDComment *)[NSEntityDescription insertNewObjectForEntityForName:@"CDComment" inManagedObjectContext:moc];
        commentObject.timeAgo = @"Sending...";
        commentObject.commentText = commentTextView.text;
        commentObject.creatorId = [NSNumber numberWithInt:[[UserService getUserID] intValue]];
        commentObject.tempIdentifier = [NSString randomAlphaStringWithLength:5 andNumeric:YES];
        [sendingStack addObject:commentObject];
        [comments addObject:commentObject];
        
        [commentsTable reloadData];
        
        NSMutableArray *finalMentions = [[NSMutableArray alloc] initWithCapacity:[mentionsAdded count]];
        for (NSDictionary *mentionObject in mentionsAdded) {
            //User mention
            if ([[mentionObject objectForKey:@"userObject"] isKindOfClass:[CDUser class]]) {
                CDUser *userObject = [mentionObject objectForKey:@"userObject"];
                NSString *mentionString = [userObject.uniqueId stringValue];
                [finalMentions addObject:mentionString];
            }
        }
        
        [NetworkService postComment:commentTextView.text withMentionString:[finalMentions componentsJoinedByString:@","] forPrayerID:[currentPrayer.uniqueId stringValue] andTempIdentifier:commentObject.tempIdentifier];
        
        [commentTextView resignFirstResponder];
    }
}

- (void)postCommentSuccess:(NSNotification *)notification {
    
    NSString *commentTempId = notification.object;
    NSMutableArray *tempComments = [[NSMutableArray alloc] initWithArray:comments];
    for (CDComment *comment in comments) {
        if ([comment.tempIdentifier isEqualToString:commentTempId]) {
            [tempComments removeObject:comment];
        }
    }
    comments = [[NSMutableArray alloc] initWithArray:tempComments];
    
    [commentTextView setText:@""];
    [sendCommentButton setEnabled:YES];
    [commentTextView resignFirstResponder];
    
    [commentTextView setText:LocString(@"Write a comment")];
    [addCommentView setBackgroundColor:Colour_PrayBlue];
    [commentTextView setBackgroundColor:Colour_PrayBlue];
    [commentTextView setTextColor:Colour_White];
    previousCommentHeight = 42;
    
    [self refreshComments];
    
    [addCommentView setHeight:58];
    [commentTextView setTop:10];
    [commentTextView setHeight:42];
    [addCommentView setTop:self.view.screenHeight - 58];
    
    [commentsTable setHeight:self.view.screenHeight - 58 - 68];
}

- (void)postCommentFailed:(NSNotification *)notification {
    
    NSString *commentTempId = notification.object;
    NSMutableArray *tempComments = [[NSMutableArray alloc] initWithArray:comments];
    for (CDComment *comment in comments) {
        if ([comment.tempIdentifier isEqualToString:commentTempId]) {
            [tempComments removeObject:comment];
        }
    }
    comments = [[NSMutableArray alloc] initWithArray:tempComments];
    
    [commentsTable reloadData];
    [SVProgressHUD showErrorWithStatus:LocString(@"We couldn't post your comment. Please check your connection and try again.")];
}


#pragma mark - Utilities
- (float)heightToFitCommentText:(NSString *)text {
    UITextView *ghostField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, commentTextWidth, 0)];
    [ghostField setFont:[FontService systemFont:13*sratio]];
    [ghostField setText:text];
    
    return (ghostField.contentSize.height < commentTextMinimumHeight) ? commentTextMinimumHeight : ghostField.contentSize.height;
}


#pragma mark - UITextView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:LocString(@"Write a comment")]) {
        [textView setText:@""];
    }
    else {
        //float numLines = textView.contentSize.height/textView.font.lineHeight;
        [UIView animateWithDuration:0.3 animations:^{
            [addCommentView setHeight:previousCommentHeight + 16 + 5];
            [addCommentView setBottom:self.view.height - keyboardSize.height];
            [sendCommentButton setFrame:CGRectMake(self.view.screenWidth - 58, 0, 58, addCommentView.height)];
            [textView setHeight:previousCommentHeight];
            [textView setTop:10];
        }];
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    addedSpaceCharacter = ([text isEqualToString:@" "])? YES : NO;
    addedArobaseCharacter = ([text isEqualToString:@"@"])? YES : NO;
    removedSpaceCharacter = ([[textView.text substringWithRange:range] isEqualToString:@" "])? YES : NO;
    removedArobaseCharacter = ([[textView.text substringWithRange:range] isEqualToString:@"@"])? YES : NO;
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [addCommentView setBackgroundColor:Colour_White];
    [commentTextView setBackgroundColor:Colour_White];
    [commentTextView setTextColor:Colour_DarkGray];
    [self setTouchRecognizer:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    
//    float numLines = textView.contentSize.height/textView.font.lineHeight;
//    
//    if (numLines == 1) {
//        [addCommentView setFrame:CGRectMake(0, self.view.screenHeight-keyboardSize.height-120, self.view.screenWidth, 58)];
//        [commentTextView setFrame:CGRectMake(8, 10, self.view.screenWidth-58, 42)];
//        [sendCommentButton setFrame:CGRectMake(self.view.screenWidth - 58, 0, 58, 58)];
//        previousCommentHeight = 42.0f;
//    }
//    else if (numLines < 5) {
//        [UIView animateWithDuration:0.3 animations:^{
//            [addCommentView setHeight:textView.contentSize.height + 16 + 5];
//            [addCommentView setBottom:self.view.screenHeight - keyboardSize.height - 58];
//            [sendCommentButton setFrame:CGRectMake(self.view.screenWidth - 58, 0, 58, addCommentView.height)];
//            [textView setHeight:textView.contentSize.height];
//            [textView setTop:10];
//            
//            [cancelCommentButton setFrame:CGRectMake(0, 0, self.view.screenWidth, self.view.screenHeight + kPadding - keyboardSize.height - addCommentView.height - 58)];
//        }];
//        
//        previousCommentHeight = textView.contentSize.height;
//    }
//    
//    [commentsTable setHeight:addCommentView.top - 120];
//    
//    if (commentsTable.contentSize.height > self.view.screenHeight - 58 - 64) {
//        CGPoint bottomOffset = CGPointMake(0, commentsTable.contentSize.height - commentsTable.bounds.size.height);
//        [commentsTable setContentOffset:bottomOffset animated:YES];
//    }
//    
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
                
                [cancelCommentButton setHidden:YES];
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
            [cancelCommentButton setHidden:NO];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [UIView animateWithDuration:0.3 animations:^{
        [sendCommentButton setFrame:CGRectMake(self.view.screenWidth - 58, 0, 58, 58)];
        [addCommentView setBackgroundColor:Colour_PrayBlue];
        [commentTextView setBackgroundColor:Colour_PrayBlue];
        [commentTextView setTextColor:Colour_White];
    }];
    
    if ([textView.text isEqualToString:@""]) {
        [textView setText:LocString(@"Write a comment")];
        [addCommentView setBackgroundColor:Colour_PrayBlue];
        [commentTextView setBackgroundColor:Colour_PrayBlue];
        [commentTextView setTextColor:Colour_White];
    }
    
    [commentsTable setHeight:addCommentView.top];
    
    if (commentsTable.contentSize.height > self.view.screenHeight - 58 - 64) {
        CGPoint bottomOffset = CGPointMake(0, commentsTable.contentSize.height - commentsTable.bounds.size.height);
        [commentsTable setContentOffset:bottomOffset animated:YES];
    }
}

- (void)setTouchRecognizer:(BOOL)enabled {
    if (enabled) {
        cancelCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelCommentButton setFrame:CGRectMake(0, 0, self.view.screenWidth, self.view.screenHeight + kPadding - keyboardSize.height - addCommentView.height - 58)];
        [cancelCommentButton setBackgroundColor:Colour_Clear];
        [cancelCommentButton addTarget:self action:@selector(cancelCommentBox) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelCommentButton];
    }
    else {
        [cancelCommentButton removeFromSuperview];
    }
}

- (void)cancelCommentBox {
    [commentTextView resignFirstResponder];
    [addCommentView setHeight:58];
    [commentTextView setTop:10];
    [commentTextView setHeight:42];
    [addCommentView setTop:self.view.screenHeight - 58];
    
    [self setTouchRecognizer:NO];
    
    [commentsTable setHeight:self.view.screenHeight - 58 - 68];
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
    [commentsTable reloadData];
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
    [commentsTable reloadData];
}

- (void)searchForMentionUsersSuccess:(NSNotification *)notification {
    mentions = [[NSArray alloc] initWithArray:notification.object];
    [commentsTable reloadData];
    [commentsTable setContentOffset:CGPointZero animated:YES];
}

- (void)searchForMentionUsersFailed {
    
}


#pragma mark - CommentsTableView delegate & datasource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //Mentions
    if (searchingForMentions) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    //Standard
    else {
        //Comments Only
        if (displayCommentsOnly) {
            if ([comments count]>0) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            }
            else {
                UIView *disclaimerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, 44)];
                
                UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, disclaimerView.width, 22)];
                [textLabel setTextAlignment:NSTextAlignmentCenter];
                [textLabel setFont:[FontService systemFont:13*sratio]];
                [textLabel setTextColor:Colour_255RGB(93, 98, 113)];
                [textLabel setText:LocString(@"Be the first to comment on this prayer!")];
                [disclaimerView addSubview:textLabel];
                
                return disclaimerView;
            }
        }
        
        //Full moment + comments
        else {
            UIView *prayerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, 320*sratio)];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, prayerCellHeight)];
            [imageView setBackgroundColor:Colour_255RGB(80, 92, 109)];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [imageView setClipsToBounds:YES];
            [prayerView addSubview:imageView];
            
            if (currentPrayer.imageURL != nil && ![currentPrayer.imageURL isEqualToString:@""]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:currentPrayer.imageURL]];
            }
            
            UIView *blackMask = [[UIView alloc] initWithFrame:imageView.frame];
            [blackMask setBackgroundColor:Colour_BlackAlpha(0.3)];
            [prayerView addSubview:blackMask];
            
            UIImageView *userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(12*sratio, 8*sratio, 38*sratio, 38*sratio)];
            [userAvatar setRoundedToDiameter:38*sratio];
            [userAvatar setContentMode:UIViewContentModeScaleAspectFill];
            [prayerView addSubview:userAvatar];
            
            if (currentPrayer.creator.avatar != nil && ![currentPrayer.creator.avatar isEqualToString:@""]) {
                [userAvatar sd_setImageWithURL:[NSURL URLWithString:currentPrayer.creator.avatar] placeholderImage:[UIImage imageNamed:@"emptyProfile"]];
            }
            else {
                [userAvatar setImage:[UIImage imageNamed:@"emptyProfile"]];
            }
            
            UIButton *userAction = [UIButton buttonWithType:UIButtonTypeCustom];
            [userAction setFrame:userAvatar.frame];
            [userAction addTarget:self action:@selector(showUserFromPrayer) forControlEvents:UIControlEventTouchUpInside];
            [prayerView addSubview:userAction];
            
            UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(userAvatar.right + 10*sratio, 12*sratio, 250*sratio, 20*sratio)];
            username.font = [FontService systemFont:14*sratio];
            username.textColor = Colour_White;
            username.textAlignment = NSTextAlignmentLeft;
            [username setText:[NSString stringWithFormat:@"%@ %@", currentPrayer.creator.firstname, currentPrayer.creator.lastname]];
            [prayerView addSubview:username];
            
            UILabel *timeAgo = [[UILabel alloc] initWithFrame:CGRectMake(username.left, username.bottom, 250*sratio,12*sratio)];
            timeAgo.font = [FontService systemFont:9*sratio];
            timeAgo.textColor = Colour_White;
            timeAgo.textAlignment = NSTextAlignmentLeft;
            [timeAgo setText:currentPrayer.timeAgo];
            [prayerView addSubview:timeAgo];
            
            UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake((self.view.screenWidth-280*sratio)/2, 64*sratio, 280*sratio, 200*sratio)];
            textView.numberOfLines = 8;
            textView.adjustsFontSizeToFitWidth = YES;
            textView.minimumScaleFactor = (14*sratio)/(50*sratio);
            textView.font = [FontService systemFont:50*sratio];
            textView.textColor = Colour_White;
            [textView setTextAlignment:NSTextAlignmentCenter];
            [textView setText:currentPrayer.prayerText];
            [prayerView addSubview:textView];
            
            likesIcon = [[UIImageView alloc] initWithFrame:CGRectMake(18*sratio, prayerCellHeight - 38*sratio, 22*sratio, 20*sratio)];
            likesIcon.image = [UIImage imageNamed:@"likeIconOFF"];
            [likesIcon setImage:[UIImage imageNamed:(currentPrayer.isLiked.boolValue)? @"likeIconON" : @"likeIconOFF"]];
            [prayerView addSubview:likesIcon];
            
            likesCount = [[UILabel alloc] initWithFrame:CGRectMake(likesIcon.right + 6*sratio, prayerCellHeight - 38*sratio, 0, 20*sratio)];
            likesCount.font = [FontService systemFont:13*sratio];
            likesCount.textColor = Colour_White;
            [prayerView addSubview:likesCount];
            
            likeListButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [likeListButton addTarget:self action:@selector(showLikesList) forControlEvents:UIControlEventTouchUpInside];
            [prayerView addSubview:likeListButton];
            
            UIImageView *commentsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, prayerCellHeight - 38*sratio, 22*sratio, 21*sratio)];
            commentsIcon.image = [UIImage imageNamed:@"commentsIcon"];
            [prayerView addSubview:commentsIcon];
            
            commentsCount = [[UILabel alloc] initWithFrame:CGRectMake(commentsIcon.right, prayerCellHeight - 38*sratio, 0, 20*sratio)];
            commentsCount.font = [FontService systemFont:13*sratio];
            commentsCount.textColor = Colour_White;
            [prayerView addSubview:commentsCount];
            
            UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [prayerView addSubview:likeButton];
            
            [likesCount setText:currentPrayer.likesCount];
            [likesCount sizeToFit];
            [likesCount setHeight:20*sratio];
            [likesCount setLeft:likesIcon.right + 6*sratio];
            [commentsIcon setLeft:likesCount.right + 24*sratio];
            
            [commentsCount setText:currentPrayer.commentsCount];
            [commentsCount sizeToFit];
            [commentsCount setHeight:20*sratio];
            [commentsCount setLeft:commentsIcon.right + 6*sratio];
            
            UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            commentButton.frame = CGRectMake(commentsIcon.left - 10*sratio, prayerCellHeight - 48*sratio, 10*sratio + commentsIcon.width + 6*sratio + commentsCount.width + 10*sratio, 42*sratio);
            [commentButton addTarget:self action:@selector(showCommentsList) forControlEvents:UIControlEventTouchUpInside];
            [prayerView addSubview:commentButton];
            
            likeButton.frame = CGRectMake(likesIcon.left - 10*sratio, prayerCellHeight - 48*sratio, 10*sratio + likesIcon.width + 6*sratio , 42*sratio);
            likeListButton.frame = CGRectMake(likeButton.right, likeButton.top, likesCount.width + 10*sratio, 42*sratio);
            
            return prayerView;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    //Mentions
    if (searchingForMentions) {
        return 0;
    }
    
    //Standard
    else {
        if (displayCommentsOnly) {
            if ([comments count]>0) {
                return 0;
            }
            else {
                return 44;
            }
        }
        else {
            return 320*sratio;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Mentions
    if (searchingForMentions) {
        return 46*sratio;
    }
    
    //Standard
    else {
        return 24*sratio + [self heightToFitCommentText:[(CDComment *)[comments objectAtIndex:indexPath.row] commentText]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Mentions
    if (searchingForMentions) {
        return ([mentions count]>0? [mentions count] : 1);
    }
    
    //Normal
    else return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Mentions
    if (searchingForMentions) {
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
    
    //Comments
    else {
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommentCell class])];
        
        if(!cell) {
            cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:NSStringFromClass([CommentCell class])];
            cell.delegate = self;
        }
        
        CDComment *comment = [comments objectAtIndex:indexPath.row];
        [cell updateWithComment:comment];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (searchingForMentions) {
        
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
            NSArray *mentionsMatches = [mentionsExpression matchesInString:commentTextView.text options:0 range:NSMakeRange(0, [commentTextView.text length])];
            
            NSTextCheckingResult *mentionMatch = [mentionsMatches objectAtIndex:mentionIndex];
            NSRange mentionMatchRange = [mentionMatch rangeAtIndex:0];
            
            NSMutableString *commentStr = [[NSMutableString alloc] initWithString:commentTextView.text];
            
//            NSString *unfilteredString = [userObject.firstname capitalizedString];
//            NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
//            NSString *filteredString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
            
            NSString *username = userObject.username;
            
            [commentStr replaceCharactersInRange:mentionMatchRange withString:[NSString stringWithFormat:@"@%@", username]];
            [commentTextView setText:commentStr];
            
            //Closing search box
            searchingForMentions = NO;
            [commentsTable reloadData];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (searchingForMentions) {
        return NO;
    }
    else {
        CDComment *comment = [comments objectAtIndex:indexPath.row];
        if ([comment.creatorId isEqualToNumber:[UserService getUserIDNumber]]) {
            return YES;
        }
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocString(@"Delete comment") message:LocString(@"Are you sure you want to delete this comment?") delegate:self cancelButtonTitle:LocString(@"Cancel") otherButtonTitles:@"Delete", nil];
        [alert setTag:indexPath.row];
        [alert show];
    }
    
    [tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LocString(@"Delete");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [SVProgressHUD showWithStatus:LocString(@"Deleting comment...") maskType:SVProgressHUDMaskTypeGradient];
        CDComment *comment = [comments objectAtIndex:[alertView tag]];
        [NetworkService deleteCommentWithID:[comment.uniqueId stringValue]];
        
        [comments removeObjectAtIndex:[alertView tag]];
        [commentsTable beginUpdates];
        [commentsTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[alertView tag] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [commentsTable endUpdates];
    }
}


#pragma mark - Delete comment
- (void)deleteCommentSuccess {
    [DataAccess remove1CommentFromPrayer:currentPrayer];
    [SVProgressHUD showSuccessWithStatus:LocString(@"Comment deleted!")];
}

- (void)deleteCommentFailed {
    [SVProgressHUD showErrorWithStatus:LocString(@"We couldn't delete this comment. Please check your connection and try again.")];
    [self refreshComments];
}


#pragma mark - UserProfile
- (void)showUserForCell:(CommentCell *)cell {
    
    CDComment *comment = [comments objectAtIndex:[[commentsTable indexPathForCell:cell] row]];
    
    if (comment.creator) {
        ProfileController *profileController = [[ProfileController alloc] initWithUser:comment.creator];
        [self.navigationController pushViewController:profileController animated:YES];
    }
}

- (void)showUserForUserObject:(CDUser *)user {
    ProfileController *profileController = [[ProfileController alloc] initWithUser:user];
    [self.navigationController pushViewController:profileController animated:YES];
}

- (void)showUserFromPrayer {
    ProfileController *profileController = [[ProfileController alloc] initWithUser:currentPrayer.creator];
    [self.navigationController pushViewController:profileController animated:YES];
}


#pragma mark - Likes
#pragma mark - Prayer Likes list
- (void)showLikesList {
    [SVProgressHUD showWithStatus:LocString(@"Loading likes...")];
    [NetworkService getPrayerLikesListForID:[currentPrayer.uniqueId stringValue]];
}

- (void)getPrayerLikesSuccess:(NSNotification *)notification {
    [SVProgressHUD dismiss];
    UsersListController *usersListController = [[UsersListController alloc] initWithTitle:LocString(@"Likes")
                                                                             andUsersList:notification.object];
    [self.navigationController pushViewController:usersListController animated:YES];
}

- (void)getPrayerLikesFailed {
    [SVProgressHUD showSuccessWithStatus:LocString(@"We couldn't get the list of likes. Please check your internet connection and try again.")];
}



#pragma mark - Prayer show comments
- (void)showCommentsList {
    CommentsController *commentsController = [[CommentsController alloc] initWithPrayer:currentPrayer andDisplayCommentsOnly:YES];
    [self.navigationController pushViewController:commentsController animated:YES];
}


#pragma mark - Prayer Actions
- (void)likeButtonClicked {
    [likesIcon setImage:[UIImage imageNamed:(currentPrayer.isLiked.boolValue)? @"likeIconOFF" : @"likeIconON"]];
    
    if (currentPrayer.isLiked.boolValue == NO) {
        [likesCount setText:[NSString stringWithFormat:@"%d",[likesCount.text intValue]+1]];
        [SVProgressHUD showSuccessWithStatus:LocString(@"Liked!")];
        [DataAccess add1LikeToPrayerWithID:currentPrayer.uniqueId];
        [NetworkService likePostWithID:[currentPrayer.uniqueId stringValue]];
    }
    else {
        [likesCount setText:[NSString stringWithFormat:@"%d",[likesCount.text intValue]-1]];
        [DataAccess remove1LikeToPrayerWithID:currentPrayer.uniqueId];
        [NetworkService unlikePostWithID:[currentPrayer.uniqueId stringValue]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
