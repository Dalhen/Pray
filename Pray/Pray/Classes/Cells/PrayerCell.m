//
//  PrayerCell.m
//  Pray
//
//  Created by Jason LAPIERRE on 04/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "PrayerCell.h"
#import "UIImageView+Rounded.h"
#import "UIImageView+WebCache.h"

#define kMaxTextSize 40

@implementation PrayerCell
@synthesize prayer;
@synthesize delegate;


#pragma mark - Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self setupLayout];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [userAvatar setImage:[UIImage new]];
    [imageView setImage:[UIImage new]];
}

- (UIColor *)generateRandomColor {
    NSArray *randomColors = [[NSArray alloc] initWithObjects:
                    Colour_255RGB(91, 189, 225),  //5bbde1
                    Colour_255RGB(191, 144, 197), //bf90c5
                    Colour_255RGB(141, 205, 159), //8dcd9f
                    Colour_255RGB(99, 140, 181),  //638cb5
                    Colour_255RGB(225, 157, 91),  //e19d5b
                    Colour_255RGB(141, 140, 181), //8d8cb5
                    Colour_255RGB(209, 229, 113), //d18171
                    Colour_255RGB(121, 133, 192), //7985c0
                    Colour_255RGB(106, 110, 128), //6a6e80
                    Colour_255RGB(123, 184, 113), //7bb871
                    nil];
    
    return [randomColors objectAtIndex: arc4random() % [randomColors count]];
}

- (void)setupLayout {
    self.clipsToBounds = YES;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, prayerCellHeight)];
    [imageView setBackgroundColor:Colour_255RGB(80, 92, 109)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [self.contentView addSubview:imageView];
    
    blackMask = [[UIView alloc] initWithFrame:imageView.frame];
    [blackMask setBackgroundColor:Colour_BlackAlpha(0.3)];
    [self.contentView addSubview:blackMask];
    
    userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(12*sratio, 8*sratio, 38*sratio, 38*sratio)];
    [userAvatar setRoundedToDiameter:38*sratio];
    [userAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:userAvatar];
    
    UIButton *userAction = [UIButton buttonWithType:UIButtonTypeCustom];
    [userAction setFrame:userAvatar.frame];
    [userAction addTarget:self action:@selector(showUser) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:userAction];
    
    username = [[UILabel alloc] initWithFrame:CGRectMake(userAvatar.right + 10*sratio, 12*sratio, 250*sratio, 20*sratio)];
    username.font = [FontService systemFont:14*sratio];
    username.textColor = Colour_White;
    username.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:username];
    
    timeAgo = [[UILabel alloc] initWithFrame:CGRectMake(username.left, username.bottom, 250*sratio,12*sratio)];
    timeAgo.font = [FontService systemFont:9*sratio];
    timeAgo.textColor = Colour_White;
    timeAgo.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timeAgo];
    
    textView = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake((self.screenWidth-280*sratio)/2, 64*sratio, 280*sratio, 200*sratio)];
    textView.numberOfLines = 8;
    textView.adjustsFontSizeToFitWidth = YES;
    textView.minimumScaleFactor = (14*sratio)/(kMaxTextSize*sratio);
    textView.font = [FontService systemFont:kMaxTextSize*sratio];
    textView.textColor = Colour_White;
    [textView setTextAlignment:NSTextAlignmentCenter];
    //[textView setEnabledTextCheckingTypes:(NSTextCheckingTypeLink|NSTextCheckingTypeAddress|NSTextCheckingTypePhoneNumber)];
    [textView setDelegate:self];
    [self.contentView addSubview:textView];
    
    likesIcon = [[UIImageView alloc] initWithFrame:CGRectMake(18*sratio, prayerCellHeight - 38*sratio, 22*sratio, 20*sratio)];
    likesIcon.image = [UIImage imageNamed:@"likeIconOFF"];
    [self.contentView addSubview:likesIcon];
    
    likesCount = [[UILabel alloc] initWithFrame:CGRectMake(likesIcon.right + 6*sratio, prayerCellHeight - 38*sratio, 0, 20*sratio)];
    likesCount.font = [FontService systemFont:13*sratio];
    likesCount.textColor = Colour_White;
    [self.contentView addSubview:likesCount];
    
    commentsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, prayerCellHeight - 38*sratio, 22*sratio, 21*sratio)];
    commentsIcon.image = [UIImage imageNamed:@"commentsIcon"];
    [self.contentView addSubview:commentsIcon];
    
    commentsCount = [[UILabel alloc] initWithFrame:CGRectMake(commentsIcon.right, prayerCellHeight - 38*sratio, 0, 20*sratio)];
    commentsCount.font = [FontService systemFont:13*sratio];
    commentsCount.textColor = Colour_White;
    [self.contentView addSubview:commentsCount];
    
    likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:likeButton];
    
    likeListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeListButton addTarget:self action:@selector(showLikesList) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:likeListButton];
    
    commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commentButton];
    
//    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, prayerCellHeight-1, self.screenWidth, 1)];
//    [separator setBackgroundColor:Colour_PrayDarkBlue];
//    [self.contentView addSubview:separator];
    
    religionType = [[UIImageView alloc] initWithFrame:CGRectMake(self.screenWidth - 12*sratio - 38*sratio, 8*sratio, 34*sratio, 34*sratio)];
    [religionType setClipsToBounds:YES];
    [religionType setContentMode:UIViewContentModeScaleAspectFit];
    //[religionType setRoundedToDiameter:38*sratio];
    //religionType.backgroundColor = Colour_PrayDarkBlueAlpha(0.95f);
    [self.contentView addSubview:religionType];
    
    sharePrayerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sharePrayerButton setFrame:CGRectMake(self.screenWidth - 46*sratio, prayerCellHeight - 46*sratio, 38*sratio, 38*sratio)];
    [sharePrayerButton setImage:[UIImage imageNamed:@"shareIcon"] forState:UIControlStateNormal];
    [sharePrayerButton addTarget:self action:@selector(sharePrayer) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:sharePrayerButton];
}


#pragma mark - Update
- (void)updateWithPrayerObject:(CDPrayer *)prayerObject {
    
    prayer = prayerObject;
    
    if (prayer.imageURL != nil && ![prayer.imageURL isEqualToString:@""]) {
    [imageView setBackgroundColor:Colour_255RGB(80, 92, 109)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:prayer.imageURL]];
    }
    else {
    [imageView setBackgroundColor:[self generateRandomColor]];
    }
    
    if (prayer.creator.avatar != nil && ![prayer.creator.avatar isEqualToString:@""]) {
        [userAvatar sd_setImageWithURL:[NSURL URLWithString:prayer.creator.avatar] placeholderImage:[UIImage imageNamed:@"emptyProfile"]];
    }
    else {
        [userAvatar setImage:[UIImage imageNamed:@"emptyProfile"]];
    }
    
    //Username
    [username setText:[NSString stringWithFormat:@"%@ %@", prayer.creator.firstname, prayer.creator.lastname]];
    
    //Time & Location
    if (prayer.locationName) {
        [timeAgo setText:[NSString stringWithFormat:@"%@ • %@", prayer.timeAgo, prayer.locationName]];
    }
    else {
        [timeAgo setText:prayer.timeAgo];
    }
    
    //Prayer Text
    [textView setAttributedText:[self decorateTagsAndMentions:prayer.prayerText]];
    [textView setLineBreakMode:NSLineBreakByTruncatingTail];
    
    //Likes & Comments
    [likesIcon setImage:[UIImage imageNamed:(prayer.isLiked.boolValue)? @"likeIconON" : @"likeIconOFF"]];
    
    [likesCount setText:prayer.likesCount];
    [likesCount sizeToFit];
    [likesCount setHeight:20*sratio];
    [likesCount setLeft:likesIcon.right + 6*sratio];
    [commentsIcon setLeft:likesCount.right + 24*sratio];

    [commentsCount setText:prayer.commentsCount];
    [commentsCount sizeToFit];
    [commentsCount setHeight:20*sratio];
    [commentsCount setLeft:commentsIcon.right + 6*sratio];
    
    likeButton.frame = CGRectMake(likesIcon.left - 10*sratio, prayerCellHeight - 48*sratio, 10*sratio + likesIcon.width + 6*sratio , 42*sratio);
    likeListButton.frame = CGRectMake(likeButton.right, likeButton.top, likesCount.width + 10*sratio, 42*sratio);
    //+ likesCount.width + 10*sratio
    
    commentButton.frame = CGRectMake(commentsIcon.left - 10*sratio, prayerCellHeight - 48*sratio, 10*sratio + commentsIcon.width + 6*sratio + commentsCount.width + 10*sratio, 42*sratio);
    
    //Religion Type
    [religionType setImage:[UIImage imageNamed:[self getImageNameForReligionIndex:labs([prayer.religionType integerValue])]]];
    if ([prayer.religionType integerValue] == 0) {
        [religionType setHidden:YES];
    }
    else [religionType setHidden:NO];
}

- (NSString *)getImageNameForReligionIndex:(NSInteger)integer {
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
    
    return [religionsImages objectAtIndex:integer];
}


#pragma mark - Attributed Strings
- (NSMutableAttributedString *)decorateTagsAndMentions:(NSString *)stringWithTags {
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:stringWithTags];
    
    [attString addAttribute:NSForegroundColorAttributeName value:Colour_White range:NSMakeRange(0, [stringWithTags length])];
    [attString addAttribute:NSFontAttributeName value:[self findFontSizeToFillContentsWithText:stringWithTags] range:NSMakeRange(0, [stringWithTags length])];
    
    //Mentions
    NSRegularExpression *mentionsExpression = [NSRegularExpression regularExpressionWithPattern:@"(@\\w+)" options:NO error:nil];
    NSArray *mentionsMatches = [mentionsExpression matchesInString:stringWithTags options:0 range:NSMakeRange(0, [stringWithTags length])];
    
    for (NSTextCheckingResult *mentionMatch in mentionsMatches) {
        NSRange mentionMatchRange = [mentionMatch rangeAtIndex:0];
        [attString addAttribute:NSForegroundColorAttributeName value:Colour_PrayBlue range:mentionMatchRange];
        
      
        NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName, (id)kCTUnderlineStyleAttributeName, nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:Colour_PrayBlue, [NSNumber numberWithInt:kCTUnderlineStyleNone], nil];
        NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        [textView addLinkWithTextCheckingResult:mentionMatch attributes:linkAttributes];
        //[descriptionText addLinkToTransitInformation:@{@"tag":@""} withRange:mentionMatchRange];
    }
    
    return attString;
}


#pragma mark - Font size finder
- (UIFont *)findFontSizeToFillContentsWithText:(NSString *)text {
    
    for (int i = kMaxTextSize*sratio; i>14*sratio; i--) {
        
        UIFont *font = [UIFont fontWithName:textView.font.fontName size:(CGFloat)i];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font}];
        
        CGRect rectSize = [attributedText boundingRectWithSize:CGSizeMake(280*sratio, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        if (rectSize.size.height <= 100*sratio) {
            return [FontService systemFont:(CGFloat)i];
            break;
        }
    }
    
    return [FontService systemFont:14*sratio];
}


#pragma mark - TTTAttributedString delegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result {
    NSRange mentionMatchRange = [result rangeAtIndex:0];
    
    NSRegularExpression *mentionsExpression = [NSRegularExpression regularExpressionWithPattern:@"(@\\w+)" options:NO error:nil];
    NSArray *mentionsMatches = [mentionsExpression matchesInString:textView.text options:0 range:NSMakeRange(0, [textView.text length])];
    
    if ([mentionsMatches count]>0) {
        NSString *mentionString = [[textView.text substringWithRange:mentionMatchRange] substringFromIndex:1];
        CDUser *userClicked = [DataAccess getUserForUsername:mentionString];
        [delegate showUserForUserObject:userClicked];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    
    if ([components objectForKey:@"hashtag"]) {
        
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - Actions
- (void)likeButtonClicked {
    [likesIcon setImage:[UIImage imageNamed:(prayer.isLiked.boolValue)? @"likeIconOFF" : @"likeIconON"]];
    
    if (prayer.isLiked.boolValue == NO) {
        [likesCount setText:[NSString stringWithFormat:@"%d",[likesCount.text intValue]+1]];
        [SVProgressHUD showSuccessWithStatus:LocString(@"You've joined this prayer.")];
        [DataAccess add1LikeToPrayerWithID:prayer.uniqueId];
    }
    else {
        [likesCount setText:[NSString stringWithFormat:@"%d",[likesCount.text intValue]-1]];
        [DataAccess remove1LikeToPrayerWithID:prayer.uniqueId];
    }
    
    [delegate likeButtonClickedForCell:self];
}

- (void)commentButtonClicked {
    [delegate commentButtonClickedForCell:self];
}

- (void)showLikesList {
    [delegate showLikesListForCell:self];
}


#pragma mark - Display user profile
- (void)showUser {
    [delegate showUserForCell:self];
}


#pragma mark - Share Prayer
- (void)sharePrayer {
    if ([delegate respondsToSelector:@selector(sharePrayerImage:)]) {
        [likesIcon setHidden:YES];
        [likesCount setHidden:YES];
        [commentsIcon setHidden:YES];
        [commentsCount setHidden:YES];
        [sharePrayerButton setHidden:YES];
        
        [delegate sharePrayerImage:[self imageFromUIView:self.contentView]];
        
        [likesIcon setHidden:NO];
        [likesCount setHidden:NO];
        [commentsIcon setHidden:NO];
        [commentsCount setHidden:NO];
        [sharePrayerButton setHidden:NO];
    }
}

- (UIImage *)imageFromUIView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
