//
//  ReligionSelectorController.m
//  Pray
//
//  Created by Jason LAPIERRE on 26/09/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "ReligionSelectorController.h"

@interface ReligionSelectorController ()

@end

@implementation ReligionSelectorController
@synthesize delegate;


- (void)loadView {
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:Colour_PrayDarkBlue];
    [self.navigationController setNavigationBarHidden:YES];

    [self setupHeader];
    [self setupLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    titleLabel.text = LocString(@"Select a religion");
    titleLabel.font = [FontService systemFont:14*sratio];
    titleLabel.textColor = Colour_White;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)setupLayout {
    [self.view setBackgroundColor:Colour_255RGB(61, 66, 78)];
    
    NSArray *religionsImages = [[NSArray alloc] initWithObjects:
                                LocString(@"chrisIcon"),
                                LocString(@"islamIcon"),
                                LocString(@"hinduIcon"),
                                LocString(@"buddhismIcon"),
                                LocString(@"shintoIcon"),
                                LocString(@"sikhIcon"),
                                LocString(@"judaismIcon"),
                                LocString(@"jainismIcon"),
                                LocString(@"bahaiIcon"),
                                LocString(@"caodaism"),
                                LocString(@"cheondoIcon"),
                                LocString(@"tenrikyoIcon"),
                                LocString(@"wiccaIcon"),
                                LocString(@"messiaIcon"),
                                LocString(@"seichoIcon"),
                                LocString(@"atheismIcon"), nil];
    
    NSArray *religionsTitles = [[NSArray alloc] initWithObjects:
                                LocString(@"Christianity"),
                                LocString(@"Islam"),
                                LocString(@"Hinduism"),
                                LocString(@"Buddhism"),
                                LocString(@"Shinto"),
                                LocString(@"Sikhism"),
                                LocString(@"Judaism"),
                                LocString(@"Jainism"),
                                LocString(@"Bahai"),
                                LocString(@"Caodaism"),
                                LocString(@"Cheondogyo"),
                                LocString(@"Tenrikyo"),
                                LocString(@"Wicca"),
                                LocString(@"Word Messianity"),
                                LocString(@"Seicho-no-ie"),
                                LocString(@"Atheism"), nil];
    
    for (NSInteger i = 0; i<4; i++) {
        for (NSInteger j = 0; j<3; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = Colour_PrayBlue;
            [button.layer setCornerRadius:5.0f];
            [button setFrame:CGRectMake(44*sratio + 84*sratio*j, 96*sratio + 96*sratio*i, 64*sratio, 64*sratio)];
            [button setBackgroundImage:[UIImage imageNamed:[religionsImages objectAtIndex:i*j]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(religionSelectedWithIndex:) forControlEvents:UIControlEventTouchUpInside];
            [button setTag:i*j];
            [self.view addSubview:button];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(38*sratio + 84*sratio*j, 92*sratio + 74*sratio*i, 84*sratio, 20*sratio)];
            label.text = [religionsTitles objectAtIndex:i*j];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [FontService systemFont:13*sratio];
            [self.view addSubview:label];
        }
    }
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)religionSelectedWithIndex:(id)sender {
    NSInteger index = [sender tag] + 1;
    [delegate religionSelectedWithIndex:index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
