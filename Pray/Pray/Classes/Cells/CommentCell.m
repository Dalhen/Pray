//
//  CommentCell.m
//  Pray
//
//  Created by Jason LAPIERRE on 21/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+Rounded.h"
#import "UIImageView+WebCache.h"


@implementation CommentCell
@synthesize delegate;


#pragma mark - Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupLayout];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [descriptionText removeFromSuperview];
    [self initDescriptionText];
}

- (void)initDescriptionText {
    descriptionText = [[TTTAttributedLabel alloc] initWithFrame:
                       CGRectMake(usernameLabel.left, usernameLabel.bottom - 7, 252, 0)];
    [descriptionText setBackgroundColor:Colour_Clear];
    [descriptionText setFont:[FontService systemFont:12*sratio]];
    [descriptionText setTextColor:Colour_255RGB(89, 89, 89)];
    [descriptionText setEnabledTextCheckingTypes:(NSTextCheckingTypeLink|NSTextCheckingTypeAddress|NSTextCheckingTypePhoneNumber)];
    [descriptionText setNumberOfLines:100];
    [descriptionText setDelegate:self];
    [self addSubview:descriptionText];
}


#pragma mark - Layout
- (void)setupLayout {
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding, kSmallPadding+4, 38, 38)];
    [iconImageView setRoundedToDiameter:38];
    [iconImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:iconImageView];
    
    UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [profileButton setFrame:CGRectMake(kPadding, kSmallPadding+4, 38, 38)];
    [profileButton setBackgroundColor:Colour_Clear];
    [profileButton addTarget:self action:@selector(showUserProfile) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:profileButton];
    
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right + kSmallPadding*2, 10, 252, 18)];
    [usernameLabel setBackgroundColor:Colour_Clear];
    [usernameLabel setFont:[FontService systemFont:12*sratio]];
    [usernameLabel setTextColor:Colour_PrayBlue];
    [self addSubview:usernameLabel];
    
    [self initDescriptionText];
    
//    timeAgoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.screenWidth - 66*sratio, usernameLabel.top + 4, 60*sratio, 15*sratio)];
//    [timeAgoLabel setFont:[FontService systemFont:12*sratio]];
//    [timeAgoLabel setTextAlignment:NSTextAlignmentRight];
//    [timeAgoLabel setTextColor:Colour_255RGB(158, 158, 158)];
//    [self.contentView addSubview:timeAgoLabel];
}


#pragma mark - Data update
- (void)updateWithComment:(CDComment *)aComment {
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:aComment.creator.avatar]];
    
    [usernameLabel setText:[[DataAccess getUserForID:aComment.creatorId] firstname]];
    [usernameLabel sizeToFit];
    
    [timeAgoLabel setText:aComment.timeAgo];
    
    [descriptionText setAttributedText:[self decorateTagsAndMentions:aComment.commentText]];
    [descriptionText sizeToFit];
    [self addSubview:descriptionText];
    
    [descriptionText setHeight:[delegate heightToFitCommentText:descriptionText.text]];
    [descriptionText setTop:usernameLabel.bottom];
}


#pragma mark - Attributed Strings
- (NSMutableAttributedString *)decorateTagsAndMentions:(NSString *)stringWithTags {
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:stringWithTags];
    
    [attString addAttribute:NSForegroundColorAttributeName value:Colour_255RGB(89, 89, 89) range:NSMakeRange(0, [stringWithTags length])];
    [attString addAttribute:NSFontAttributeName value:[FontService systemFont:13*sratio] range:NSMakeRange(0, [stringWithTags length])];
    
//    //Hashtags
//    NSRegularExpression *hashtagsExpression = [NSRegularExpression regularExpressionWithPattern:@"(#\\w+)" options:NO error:nil];
//    NSArray *hashtagsMatches = [hashtagsExpression matchesInString:stringWithTags options:0 range:NSMakeRange(0, [stringWithTags length])];
//    
//    for (NSTextCheckingResult *hashtagMatch in hashtagsMatches) {
//        NSRange hashtagMatchRange = [hashtagMatch rangeAtIndex:0];
//        
//        [attString addAttribute:NSForegroundColorAttributeName value:Colour_GreenGrape range:hashtagMatchRange];
//        [descriptionText addLinkToTransitInformation:@{@"hashtag":@""} withRange:hashtagMatchRange];
//    }
    
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *linksMatches = [linkDetector matchesInString:stringWithTags options:0 range:NSMakeRange(0, [stringWithTags length])];
    
    for (NSTextCheckingResult *linkMatch in linksMatches) {
        NSRange linkMatchRange = [linkMatch rangeAtIndex:0];
        [attString addAttribute:NSForegroundColorAttributeName value:Colour_255RGB(0, 122, 255) range:linkMatchRange];
        [descriptionText addLinkToURL:[NSURL URLWithString:[stringWithTags substringWithRange:linkMatchRange]] withRange:linkMatchRange];
    }
    
    //Mentions
    /*
     NSRegularExpression *mentionsExpression = [NSRegularExpression regularExpressionWithPattern:@"(@\\w+)" options:NO error:nil];
     NSArray *mentionsMatches = [mentionsExpression matchesInString:stringWithTags options:0 range:NSMakeRange(0, [stringWithTags length])];
     
     
     for (NSTextCheckingResult *mentionMatch in mentionsMatches) {
     NSRange mentionMatchRange = [mentionMatch rangeAtIndex:0];
     [attString addAttribute:NSForegroundColorAttributeName value:Colour_GreenGrape range:mentionMatchRange];
     
     //        NSString *mentionString = [stringWithTags substringWithRange:mentionMatchRange];
     //        NSRange linkRange = [stringWithTags rangeOfString:mentionString];
     //        NSString* user = [mentionString substringFromIndex:1];
     //        NSString* linkURLString = [NSString stringWithFormat:@"http://www.google.com"];
     NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName, (id)kCTUnderlineStyleAttributeName, nil];
     NSArray *objects = [[NSArray alloc] initWithObjects:Colour_GreenGrape, [NSNumber numberWithInt:kCTUnderlineStyleNone], nil];
     NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
     [descriptionText addLinkWithTextCheckingResult:mentionMatch attributes:linkAttributes];
     }
     */
    
    return attString;
}


#pragma mark - TTTAttributedString delegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result {
    //NSRange mentionMatchRange = [result rangeAtIndex:0];
    //NSString *mentionString = [descriptionText.text substringWithRange:mentionMatchRange];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    if ([components objectForKey:@"hashtag"]) {
        
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - Actions
- (void)showUserProfile {
    [delegate showUserProfileForCommentCell:self];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
