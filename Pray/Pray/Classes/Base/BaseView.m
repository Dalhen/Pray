//
//  BaseView.m
//  Grape
//
//  Created by Jason LAPIERRE on 07/10/2013.
//  Copyright (c) 2013 - All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (id)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = Colour_White;
}

@end
