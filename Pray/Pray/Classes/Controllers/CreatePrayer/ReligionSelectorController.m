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
    [self.view setBackgroundColor:Colour_White];
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
    [headerView setBackgroundColor:Colour_255RGB(232, 232, 232)];
    [self.view addSubview:headerView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(78*sratio, 20*sratio, 162*sratio, 26*sratio)];
    titleLabel.text = LocString(@"Select a religion");
    titleLabel.font = [FontService systemFont:14*sratio];
    titleLabel.textColor = Colour_255RGB(82, 82, 82);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)setupLayout {
    [self.view setBackgroundColor:Colour_White];
    
    NSArray *religionsImages = [[NSArray alloc] initWithObjects:
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
                                LocString(@"Messianity"),
                                LocString(@"Seicho-no-ie"),
                                LocString(@"Atheism"), nil];
    
    for (NSInteger i = 0; i<4; i++) {
        for (NSInteger j = 0; j<4; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = Colour_255RGB(127, 127, 127);
            [button.layer setCornerRadius:5.0f];
            [button setFrame:CGRectMake(8*sratio + 80*sratio*j, 92*sratio - (ISIPHONE4()? 20 : 0) + 102*sratio*i, 64*sratio, 64*sratio)];
            [button setImage:[UIImage imageNamed:[religionsImages objectAtIndex:4*i+j]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(religionSelectedWithIndex:) forControlEvents:UIControlEventTouchUpInside];
            [button setTag:4*i+j];
            [self.view addSubview:button];
            
            UILabel *label = [[UILabel alloc] initWithFrame:
                              CGRectMake(button.left - 14*sratio, button.bottom, button.width + 28*sratio, 25*sratio)];
            label.text = [religionsTitles objectAtIndex:4*i+j];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [FontService systemFont:12*sratio];
            label.textColor = Colour_255RGB(89, 89, 89);
            [self.view addSubview:label];
        }
    }
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)religionSelectedWithIndex:(id)sender {
    NSInteger index = [sender tag] + 1;
    [self goBack];
    [delegate religionSelectedWithIndex:index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
