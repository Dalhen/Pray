//
//  CommentsController.m
//  Pray
//
//  Created by Jason LAPIERRE on 21/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "CommentsController.h"
#import "NSString+Extensions.h"
#import "CommentCell.h"

@interface CommentsController ()

@end

@implementation CommentsController


- (id)initWithPrayer:(CDPrayer *)prayer {
    self = [super init];
    
    if (self) {
        currentPrayer = prayer;
        comments = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:Colour_PrayDarkBlue];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupHeader];
    [self setupTableView];
    [self loadComments];
}

- (void)setupHeader {
    
}

- (void)setupTableView {
    commentsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 56*sratio, self.view.screenWidth, self.view.screenHeight - 56*sratio)];
    [commentsTable setBackgroundColor:Colour_PrayDarkBlue];
    [commentsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [commentsTable setScrollsToTop:YES];
    [commentsTable setDelegate:self];
    [commentsTable setDataSource:self];
    [self.view addSubview:commentsTable];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTriggered) forControlEvents:UIControlEventValueChanged];
    [refreshControl setTintColor:Colour_White];
    [commentsTable addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForEvents];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unRegisterForEvents];
}


#pragma mark - Events registration
- (void)registerForEvents {
    Notification_Observe(JXNotification.CommentsServices.GetPostCommentsSuccess, loadCommentsSuccess:);
    Notification_Observe(JXNotification.CommentsServices.GetPostCommentsFailed, loadCommentsFailed);
    Notification_Observe(JXNotification.CommentsServices.DeleteCommentSuccess, deleteCommentSuccess);
    Notification_Observe(JXNotification.CommentsServices.DeleteCommentFailed, deleteCommentFailed);
    Notification_Observe(JXNotification.FeedServices.ReportPostSuccess, reportPostSuccess);
    Notification_Observe(JXNotification.FeedServices.ReportPostFailed, reportPostFailed);
    
    Notification_Observe(UIKeyboardWillShowNotification, keyboardWillShow:);
    Notification_Observe(UIKeyboardWillHideNotification, keyboardWillHide:);
}

- (void)unRegisterForEvents {
    Notification_Remove(JXNotification.CommentsServices.GetPostCommentsSuccess);
    Notification_Remove(JXNotification.CommentsServices.GetPostCommentsFailed);
    Notification_Remove(JXNotification.CommentsServices.DeleteCommentSuccess);
    Notification_Remove(JXNotification.CommentsServices.DeleteCommentFailed);
    Notification_Remove(JXNotification.FeedServices.ReportPostSuccess);
    Notification_Remove(JXNotification.FeedServices.ReportPostFailed);
    
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


#pragma mark - Layout
- (void)setupCommentBar {
    addCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-114, 320, 50)];
    [addCommentView setBackgroundColor:Colour_255RGB(241, 241, 241)];
    [self.view addSubview:addCommentView];
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, 233, 34)];
    commentTextView.backgroundColor = Colour_White;
    [commentTextView.layer setCornerRadius:3.0f];
    commentTextView.delegate = self;
    [commentTextView setFont:[FontService systemFont:13*sratio]];
    [commentTextView setTextColor:Colour_255RGB(220, 220, 220)];
    [commentTextView setReturnKeyType:UIReturnKeyDefault];
    [commentTextView setText:LocString(@"Write a comment...")];
    [addCommentView addSubview:commentTextView];
    
    sendCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendCommentButton setFrame:CGRectMake(commentTextView.right + 8, 8, 65, 34)];
    [sendCommentButton setBackgroundColor:Colour_PrayBlue];
    [sendCommentButton.layer setCornerRadius:3.0f];
    [sendCommentButton setTitle:LocString(@"Send") forState:UIControlStateNormal];
    [sendCommentButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [sendCommentButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [addCommentView addSubview:sendCommentButton];
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


#pragma mark - Post comment connection delegates
- (void)postComment {
    if (([commentTextView.text length] > 0 && [commentTextView isFirstResponder]) ||
        ![commentTextView.text isEqualToString:LocString(@"Write a comment")]) {
        
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
        
        [NetworkService postCommentForPrayerID:[currentPrayer.uniqueId stringValue] andTempIdentifier:commentObject.tempIdentifier];
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
    
    [addCommentView setOrigin:CGPointMake(0, self.view.screenHeight-122)];
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
    [ghostField sizeToFit];
    
    return (ghostField.height < commentTextMinimumHeight) ? commentTextMinimumHeight : ghostField.height;
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

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [addCommentView setBackgroundColor:Colour_255RGB(247, 247, 247)];
    [commentTextView setBackgroundColor:Colour_255RGB(247, 247, 247)];
    [commentTextView setTextColor:Colour_DarkGray];
    [self setTouchRecognizer:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    float numLines = textView.contentSize.height/textView.font.lineHeight;
    
    if (numLines == 1) {
        [addCommentView setFrame:CGRectMake(0, self.view.screenHeight-keyboardSize.height-120, self.view.screenWidth, 58)];
        [commentTextView setFrame:CGRectMake(8, 10, self.view.screenWidth-58, 42)];
        [sendCommentButton setFrame:CGRectMake(self.view.screenWidth - 58, 0, 58, 58)];
        previousCommentHeight = 42.0f;
    }
    else if (numLines < 5) {
        [UIView animateWithDuration:0.3 animations:^{
            [addCommentView setHeight:textView.contentSize.height + 16 + 5];
            [addCommentView setBottom:self.view.screenHeight - keyboardSize.height - 58];
            [sendCommentButton setFrame:CGRectMake(self.view.screenWidth - 58, 0, 58, addCommentView.height)];
            [textView setHeight:textView.contentSize.height];
            [textView setTop:10];
            
            [cancelCommentButton setFrame:CGRectMake(0, 0, self.view.screenWidth, self.view.screenHeight + kPadding - keyboardSize.height - addCommentView.height - 58)];
        }];
        
        previousCommentHeight = textView.contentSize.height;
    }
    
    [commentsTable setHeight:addCommentView.top - 120];
    
    if (commentsTable.contentSize.height > self.view.screenHeight - 58 - 64) {
        CGPoint bottomOffset = CGPointMake(0, commentsTable.contentSize.height - commentsTable.bounds.size.height);
        [commentsTable setContentOffset:bottomOffset animated:YES];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [UIView animateWithDuration:0.3 animations:^{
        [sendCommentButton setFrame:CGRectMake(self.view.screenWidth - 58, 0, 58, 58)];
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
    [addCommentView setTop:self.view.screenHeight - 120];
    
    [self setTouchRecognizer:NO];
    
    [commentsTable setHeight:self.view.screenHeight - 58 - 68];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
