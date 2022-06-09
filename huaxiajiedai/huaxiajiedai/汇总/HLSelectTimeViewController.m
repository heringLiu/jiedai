//
//  HLSelectTimeViewController.m
//  huaxiajishi
//
//  Created by gjhgj on 2017/9/24.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "HLSelectTimeViewController.h"

@interface HLSelectTimeViewController ()

@end

@implementation HLSelectTimeViewController
@synthesize topView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = gray238;
    self.automaticallyAdjustsScrollViewInsets = NO;
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    topView.delegate = self;
    [self.view addSubview:topView];
    topView.titleLabel.text = @"";
    topView.backgroundColor = navLightBrownColor ;
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    //    [topView.rightButton setImage:[UIImage imageNamed:@"icon_Search_bg color"] forState:UIControlStateNormal];
    topView.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    topView.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
//    self.mySearchView = [[HLSearchView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kappScreenWidth, 20*4 + 30 * (kappScreenWidth / 320.0f) * 3)];
//    self.mySearchView.backgroundColor = [UIColor whiteColor];
//    self.mySearchView.delegate = self;
//    [self.view addSubview:self.mySearchView];
    
}


- (void)HLbeginSearch {
    
}

- (void)HLsearchProject {
    
}

@end
