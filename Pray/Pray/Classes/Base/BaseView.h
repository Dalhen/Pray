//
//  BaseView.h
//  Grape
//
//  Created by Jason LAPIERRE on 07/10/2013.
//  Copyright (c) 2013 - All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

- (void)setupEmptyDataSetWithText:(NSString *)text;
- (void)setupEmptyDataSetWithText:(NSString *)text andTop:(CGFloat)top;
- (void)setupEmptyDataSetWithText:(NSString *)text andTop:(CGFloat)top inView:(UIView *)insertView;

@end
