//
//  HLBoxInfoViewController.m
//  huaxiajishi
//
//  Created by gjhgj on 2017/11/1.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "HLBoxInfoViewController.h"

@interface HLBoxInfoViewController (){
    UIView *topBackView;
    HLBoxInfoView *boxCdView;
    HLBoxInfoView *boxNameView;
    HLBoxInfoView *customNameView;
    HLBoxInfoView *customPhoneView;
    HLBoxInfoView *leftNumView;
    HLBoxInfoView *allNumView;
    HLBoxInfoView *saleDateView;
    HLBoxInfoView *updateDateView;
}

@end

@implementation HLBoxInfoViewController
@synthesize topView,myTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = gray238;
    self.automaticallyAdjustsScrollViewInsets = NO;
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    topView.delegate = self;
    [self.view addSubview:topView];
    topView.titleLabel.text = @"套盒信息扫码查询";
    topView.backgroundColor = navLightBrownColor ;
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    //    [topView.rightButton setImage:[UIImage imageNamed:@"icon_Search_bg color"] forState:UIControlStateNormal];
    topView.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    topView.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);

    UIScrollView *backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kappScreenWidth, kappScreenHeight-64)];
    [self.view addSubview:backView];
    backView.contentSize = CGSizeMake(kappScreenWidth, 10 + 70 + 10 + 8*50 + 7);
    
    topBackView = [[UIView alloc] init];
    topBackView.backgroundColor = WhiteColor;
    [backView addSubview:topBackView];
    topBackView.frame = CGRectMake(10, 10, kappScreenWidth - 20, 70);
    
    self.boxCdLabel = [[UILabel alloc] init];
    [topBackView addSubview:self.boxCdLabel];
    self.boxCdLabel.frame = CGRectMake(0, 25, kappScreenWidth - 20, 20);
    self.boxCdLabel.text = @"扫描到的条形码为：";
    self.boxCdLabel.font = FONT14;
    self.boxCdLabel.textColor = gray81;
    self.boxCdLabel.textAlignment = NSTextAlignmentCenter;
    
    
    boxCdView = [[HLBoxInfoView alloc] init];
    [backView addSubview:boxCdView];
    [boxCdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
        make.top.equalTo(topBackView.mas_bottom).offset(10);
    }];
    boxCdView.nameLabel.text = @"套盒编号：";
    boxCdView.valueLabel.text = @"无";
    
    boxNameView = [[HLBoxInfoView alloc] init];
    [backView addSubview:boxNameView];
    [boxNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
        make.top.equalTo(boxCdView.mas_bottom).offset(1);
    }];
    boxNameView.nameLabel.text = @"套盒名称：";
    boxNameView.valueLabel.text = @"无";
    
    customNameView = [[HLBoxInfoView alloc] init];
    [backView addSubview:customNameView];
    [customNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
        make.top.equalTo(boxNameView.mas_bottom).offset(1);
    }];
    customNameView.nameLabel.text = @"客户名称";
    customNameView.valueLabel.text = @"无";
    
    customPhoneView = [[HLBoxInfoView alloc] init];
    [backView addSubview:customPhoneView];
    [customPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
        make.top.equalTo(customNameView.mas_bottom).offset(1);
    }];
    customPhoneView.nameLabel.text = @"客户电话：";
    customPhoneView.valueLabel.text = @"无";
 
    leftNumView = [[HLBoxInfoView alloc] init];
    [backView addSubview:leftNumView];
    [leftNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
        make.top.equalTo(customPhoneView.mas_bottom).offset(1);
    }];
    leftNumView.nameLabel.text = @"剩余次数：";
    leftNumView.valueLabel.text = @"无";
    
    allNumView = [[HLBoxInfoView alloc] init];
    [backView addSubview:allNumView];
    [allNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
        make.top.equalTo(leftNumView.mas_bottom).offset(1);
    }];
    allNumView.nameLabel.text = @"总共次数：";
    allNumView.valueLabel.text = @"无";
    
    saleDateView = [[HLBoxInfoView alloc] init];
    [backView addSubview:saleDateView];
    [saleDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
        make.top.equalTo(allNumView.mas_bottom).offset(1);
    }];
    saleDateView.nameLabel.text = @"销售日期：";
    saleDateView.valueLabel.text = @"无";
    
    updateDateView = [[HLBoxInfoView alloc] init];
    [backView addSubview:updateDateView];
    [updateDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
        make.top.equalTo(saleDateView.mas_bottom).offset(1);
    }];
    updateDateView.nameLabel.text = @"消费日期：";
    updateDateView.valueLabel.text = @"无";
    
    
    [self getData];
    
    
    
}

- (void) getData {
    [[NetWorkingModel sharedInstance] POST:BOXCDINFO parameters:@{@"boxCd":self.boxCd} success:^(AFHTTPRequestOperation *operation, id obj) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", jsonString);
        
        if (ISSUCCESS) {
            NSDictionary *dic = [CONTENTOBJ objectAtIndex:0];
            self.boxCdLabel.text = [NSString stringWithFormat:@"扫描到的条形码为：%@", self.boxCd];
            boxCdView.valueLabel.text = [dic objectForKey:@"boxCd"];
            boxNameView.valueLabel.text = [dic objectForKey:@"boxName"];
            customNameView.valueLabel.text = [dic objectForKey:@"customerName"];
            customPhoneView.valueLabel.text = [dic objectForKey:@"telNo"];
            leftNumView.valueLabel.text = [dic objectForKey:@"leftTimesNum"];
            allNumView.valueLabel.text = [dic objectForKey:@"timesNum"];
            saleDateView.valueLabel.text = [dic objectForKey:@"saleDate"];
            updateDateView.valueLabel.text = [dic objectForKey:@"updateDate"];
        } else {
            if ([OBJMESSAGE isEqualToString:@"error"]) {
                SHOWTEXTINWINDOW(@"查询没有信息", 1.5);
            } else {
                SHOWTEXTINWINDOW(@"查询错误", 1.5);
            }
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

- (void)leftButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
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
