//
//  HLSearchViewController.m
//  huaxiajishi
//
//  Created by gjhgj on 2017/9/19.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "HLSearchViewController.h"

@interface HLSearchViewController ()

@end

@implementation HLSearchViewController
@synthesize topView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

- (void)leftButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)beginSearch {
    // 获取beginSearch 时间 返回上一级查询
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
