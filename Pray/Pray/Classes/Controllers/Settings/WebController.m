//
//  WebController.m
//  Pray
//
//  Created by Jason LAPIERRE on 27/09/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "WebController.h"
#import "BaseView.h"

@interface WebController ()

@end

@implementation WebController



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        urlString = url;
    }
    return self;
}


- (void)loadView {
    self.view = [[BaseView alloc] init];
    [self.view setBackgroundColor:Colour_White];
    
    [self setupLayout];
    [self setupHeader];
}


#pragma mark - Layout
- (void)setupHeader {
    [self.navigationController setNavigationBarHidden:YES];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)setupLayout {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
