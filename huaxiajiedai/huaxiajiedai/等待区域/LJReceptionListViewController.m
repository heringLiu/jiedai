//
//  LJReceptionListViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/4/18.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJReceptionListViewController.h"
#import "LJHLGridView.h"
#import "LJAddClientViewController.h"
#import "ShoppingMallTabBarViewController.h"
#import "LJReceptionDetailModel.h"
#import "LJWaitingAreaViewController.h"

#define gridViewWidth 100 + 80 * 5 + 3 * 60
@interface LJReceptionListViewController () <SelectRoomDelegate, GridViewDelegate> {
    
    UIView *lineView;
    
    LJHLGridView *gridView;
//    订单号
    UILabel *orderNumberLabel;
//    当日波数
    UILabel *daysBoNumberLabel;
//    人数
    UILabel *personCountLbel;
    
    UIScrollView *backView;
    
    UIButton *nextButton;

    NSArray *_tables;
    NSArray *_dataModels;
    NSArray *_rowExamples;
    
    NSInteger _stepperPreviousValue;
    
    UIScrollView *listScrollView;
    
    UIButton *leftBottomButton;
    
    UIButton *rightBottomButton;
    
    CGFloat keyboardSizeHeight;
    
    LJReceptionListRowView *firstReceptionView ;
    LJReceptionListRowView *secondReceptionView;
    LJReceptionListRowView *thirdReceptionView;
    
    UIView *firstLineView;
    
    NSArray *employeeTabs;
    NSArray *customTypeList;
    
    NSMutableArray *bianhaoArr;
    NSMutableArray *nameArr;
    NSMutableArray *typeArr;
    
    
    CGFloat listHeight;
}

@end

@implementation LJReceptionListViewController
@synthesize topView, rightMenuView, dataList, myControl, pickView;

- (void)layoutSubviews {
    listScrollView.contentSize = CGSizeMake(gridViewWidth, listScrollView.frame.size.height);
}


- (void) loadData {
    if (self.orderCd.length) {
//        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] GET:RECEPTIONORDERHEADEREDIT parameters:@{@"orderCd":self.orderCd} success:^(AFHTTPRequestOperation *operation, id obj) {
//            DISMISS
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
            if (ISSUCCESS) {
                self.dataDic = CONTENTOBJ;
                self.headerEntity = [[LJConsumptionHeaderModel alloc] init];
                [self.headerEntity setValuesForKeysWithDictionary:CONTENTOBJ];
                [self.headerEntity setValuesForKeysWithDictionary:[CONTENTOBJ objectForKey:@"receptionOrderHeadTab"]];
                [self createUI];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } else {
        SHOWTEXTINWINDOW(@"缺少单号", 1);
    }
}

- (void)closePickView {
    [self pickViewDone];
}

- (void)selectedDone:(NSInteger)index {
    [gridView selectedDone:index];
}


- (void)pickViewDone {
    [UIView animateWithDuration:0.3 animations:^{
        myControl.hidden = YES;
        pickView.frame = CGRectMake(0, kappScreenHeight, kappScreenWidth, 260);
    }];
    
}

- (void) showPickViewWithData:(NSMutableArray *) datas {
    nameArr = datas;
    [self.view endEditing:YES];
    pickView.datas = datas;
    [UIView animateWithDuration:0.3 animations:^{
        myControl.hidden = NO;
        pickView.frame = CGRectMake(0, kappScreenHeight - 260, kappScreenWidth, 260);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"didAppear");
    backView.contentSize = CGSizeMake(kappScreenWidth, 50 + 70 * 1 + 50 + listHeight + 100 > kappScreenHeight - kTopScreenWidth ? 50 + 70 * 1 + 50 + listHeight + 100 : kappScreenHeight - kTopScreenWidth);
    
    listScrollView.contentSize = CGSizeMake(gridViewWidth, listScrollView.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    listHeight = 300;
    [self loadData];
    
    [self registerForKeyboardNotifications];
    self.view.backgroundColor = gray238;
    self.automaticallyAdjustsScrollViewInsets = NO;
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    [self.view addSubview:topView];
    topView.delegate = self;
    topView.backgroundColor = NavBackColor;
    topView.titleLabel.text = @"接待订单详情";
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    [topView.rightButton setImage:[UIImage imageNamed:@"icon_Menu"] forState:UIControlStateNormal];
    topView.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
    backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth)];
    [self.view addSubview:backView];
    backView.backgroundColor = gray238;
    backView.delegate = self;
    
    
    rightMenuView = [[LJMenuView alloc] initWithFrame:CGRectMake(kappScreenWidth, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth)isConsumption:NO];
    rightMenuView.delegate = self;
    [self.view addSubview:rightMenuView];
    
}


- (void)rightButtonPressed {
    NSLog(@"right");
    if (rightMenuView.frame.origin.x == kappScreenWidth) {
        [self saveData];
        [UIView animateWithDuration:0.3 animations:^{
            rightMenuView.frame = CGRectMake(0, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth);
            [topView.rightButton setTitle:@"隐藏" forState:UIControlStateNormal];
            [topView.rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }];
    } else {
//        [self loadData];
        [UIView animateWithDuration:0.3 animations:^{
            rightMenuView.frame = CGRectMake(kappScreenWidth, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth);
            [topView.rightButton setTitle:@"" forState:UIControlStateNormal];
            [topView.rightButton setImage:[UIImage imageNamed:@"icon_Menu"] forState:UIControlStateNormal];
        }];
    }
}

- (void)leftButtonPressed {
    NSLog(@"left");
    if (rightMenuView && rightMenuView.frame.origin.x == 0) {
//        [self loadData];
        [UIView animateWithDuration:0.3 animations:^{
            rightMenuView.frame = CGRectMake(kappScreenWidth, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth);
            [topView.rightButton setTitle:@"" forState:UIControlStateNormal];
            [topView.rightButton setImage:[UIImage imageNamed:@"icon_Menu"] forState:UIControlStateNormal];
        }];
    } else {
        if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[LJAddClientViewController class]]) {
            ShoppingMallTabBarViewController *tab = [[ShoppingMallTabBarViewController alloc] init];
            if (tab.selectedIndex) {
                tab.selectedIndex = 0;
                [tab.bottomTabBarView selectIndex:0];
            }
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}

- (void)sendSelectedTag:(NSInteger)buttonTag {
    NSLog(@"%ld", (long)buttonTag);
    if (buttonTag == 1000) {
        // 增加客户
        LJAddClientViewController *next = [[LJAddClientViewController alloc] init];
        next.orderCd = self.headerEntity.orderCd;
        next.roomCd = self.roomCd;
        next.bociString = self.headerEntity.customerTurnCd;
        [self rightButtonPressed];
        [self.navigationController pushViewController:next animated:YES];
    } else if (buttonTag == 1001) {
        // 删除客户
        if (self.pendingList) {
            [self.pendingList removeAllObjects];
        } else {
            self.pendingList = [NSMutableArray array];
        }
        for (int i = 0; i < self.dataList.count; i++) {
            LJReceptionDetailModel *entity = [self.dataList objectAtIndex:i];
            if (entity.isSelected) {
                if (![self.pendingList containsObject:entity.customerCd]) {
                    [self.pendingList addObject:entity.customerCd];
                }
            }
        }
        if (self.pendingList.count) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"确定删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            av.tag = 2000;
            [av show];
        } else {
            SHOWTEXTINWINDOW(@"请至少选择一条", 1);
        }
        
    } else if (buttonTag == 1003) {
//        增加明细
        if (self.orderDetailParamList) {
            [self.orderDetailParamList removeAllObjects];
        } else {
            self.orderDetailParamList = [NSMutableArray array];
        }
        
        for (int i = 0; i < self.dataList.count; i++) {
            LJReceptionDetailModel *entity = [self.dataList objectAtIndex:i];
            if (entity.isSelected) {
                BOOL flag = YES;
                for (LJReceptionDetailModel *model in self.orderDetailParamList) {
                    if ([model.customerCd isEqualToString:entity.customerCd]) {
                        flag = NO;
                        break;
                    }
                }
                if (flag) {
                    [self.orderDetailParamList addObject:entity];
                }
            }
        }
        
        if (self.orderDetailParamList.count) {
            NSMutableArray *arr = [NSMutableArray array];
            for (LJReceptionDetailModel *entity in self.orderDetailParamList) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (entity.sex.length) {
                    [dic setValue:entity.sex forKey:@"sex"];
                }
                if (entity.customerCd.length) {
                    [dic setValue:entity.customerCd forKey:@"customerCd"];
                }
                [arr addObject:dic];
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (self.headerEntity.customerTurnCd.length) {
                [dic setValue:self.headerEntity.customerTurnCd forKey:@"customerTurnCd"];
            }
            if (self.headerEntity.salemanCd.length) {
                [dic setValue:self.headerEntity.salemanCd forKey:@"saleManCd"];
            }
            if (self.headerEntity.orderCd.length) {
                [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
            }
            if (arr.count) {
                [dic setValue:arr forKey:@"orderDetil"];
            }
            
            [[NetWorkingModel sharedInstance] POST:RECEPTIONADDRECEPIONDETAIL parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                if (ISSUCCESS) {
                    SHOWTEXTINWINDOW(@"操作成功", 1);
                    [self rightButtonPressed];
                    [self loadData];
                } else {
                    BADREQUEST
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
        } else {
            SHOWTEXTINWINDOW(@"请至少选择一位客户", 1);
        }
        
    } else if (buttonTag == 1004) {
//        删除明细
        if (self.orderDetailParamList) {
            [self.orderDetailParamList removeAllObjects];
        } else {
            self.orderDetailParamList = [NSMutableArray array];
        }
        for (int i = 0; i < self.dataList.count; i++) {
            LJReceptionDetailModel *entity = [self.dataList objectAtIndex:i];
            if (entity.isSelected) {
                if (![self.orderDetailParamList containsObject:entity]) {
                    [self.orderDetailParamList addObject:entity];
                }
            }
        }
        if (self.orderDetailParamList.count) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"确定删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            av.tag = 2001;
            [av show];
        } else {
            SHOWTEXTINWINDOW(@"请至少选择一条", 1);
        }

    } else if (buttonTag == 1004) {
//        点钟
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2000) {
        if (buttonIndex == 1) {
            // 删除客户
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (self.headerEntity.orderCd.length) {
                [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
            }
            if ([[userDefaults objectForKey:USERID] length]) {
                [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
            }
            if (self.pendingList.count) {
                [dic setValue:self.pendingList forKey:@"customerCds"];
            }
            NSLog(@"删除客户参数  %@\n 请求地址 %@", dic, RECEPTIONORDERHEADERCUSTOMERDELETE);
            SHOWSTATUSCLEAR
            [[NetWorkingModel sharedInstance] POST:RECEPTIONORDERHEADERCUSTOMERDELETE parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                DISMISS
                if (ISSUCCESS) {
                    SHOWTEXTINWINDOW(@"删除成功", 1);
                    [self loadData];
                } else if ([OBJMESSAGE isEqualToString:@"error_Noauthority"]) {
                    SHOWTEXTSELFVIEW(@"没有权限", 1)
//                    SHOWTEXTINWINDOW(@"没有权限", 1);
                } else {
                    BADREQUEST
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            [self rightButtonPressed];
            
        }
    } else if (alertView.tag == 2001) {
//        删除明细
        if (buttonIndex == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (LJReceptionDetailModel *entity in self.orderDetailParamList) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (entity.projectCd.length) {
                    [dic setValue:entity.projectCd forKey:@"projectCd"];
                }
                if (entity.customerCd.length) {
                    [dic setValue:entity.customerCd forKey:@"customerCd"];
                }
                if (entity.detailNo.length) {
                    [dic setValue:entity.detailNo forKey:@"detailNo"];
                }
                [arr addObject:dic];
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];

            if (self.headerEntity.orderCd.length) {
                [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
            }
            if ([[userDefaults objectForKey:USERID] length]) {
                [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
            }
            if (arr.count) {
                [dic setValue:arr forKey:@"orderDetailParamList"];
            }
            SHOWSTATUSCLEAR
            [[NetWorkingModel sharedInstance] POST:RECEPTIODELETEDETAIL parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                DISMISS
                if (ISSUCCESS) {
                    SHOWTEXTINWINDOW(@"删除成功", 1);
                    [self loadData];
                } else if ([OBJMESSAGE isEqualToString:@"error_Noauthority"]) {
                   SHOWTEXTSELFVIEW(@"没有权限", 1)
                } else {
                    SHOWTEXTINWINDOW(@"操作失败", 1);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            [self rightButtonPressed];

        }
    }
}

-  (void) createUI {
    if (dataList == nil) {
        dataList = [NSMutableArray array];
    } else {
        [dataList removeAllObjects];
    }
    
    
    for (NSDictionary *dic in [self.dataDic objectForKey:@"receptionOrderDetailTabList"]) {
        LJReceptionDetailModel *entity = [[LJReceptionDetailModel alloc] init];
        [entity setValuesForKeysWithDictionary:dic];
        entity.o_projectCd = entity.projectCd;
        [dataList addObject:entity];
    }
    
    if (dataList.count == 0) {
        if (self.isZhuan) {
            
            if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[LJAddClientViewController class]]) {
                ShoppingMallTabBarViewController *tab = [[ShoppingMallTabBarViewController alloc] init];
                if (tab.selectedIndex) {
                    tab.selectedIndex = 0;
                    [tab.bottomTabBarView selectIndex:0];
                }
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            } else {
                self.tabBarController.selectedIndex = 0;
                ShoppingMallTabBarViewController *tab = (ShoppingMallTabBarViewController *)self.tabBarController;
                [tab.bottomTabBarView selectIndex:0];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } else {
            if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[LJAddClientViewController class]]) {
                ShoppingMallTabBarViewController *tab = [[ShoppingMallTabBarViewController alloc] init];
                if (tab.selectedIndex) {
                    tab.selectedIndex = 0;
                    [tab.bottomTabBarView selectIndex:0];
                }
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            } else {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        
        
    }
    
    if (backView == nil) {
        backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth)];
        [self.view addSubview:backView];
        backView.backgroundColor = gray238;
        backView.delegate = self;
    }
    
    if (dataList.count < 5) {
        listHeight = (dataList.count+1) * 50;
    } else {
        listHeight = 300;
    }
    NSLog(@"加载了数据  %lu", (unsigned long)dataList.count);
    backView.contentSize = CGSizeMake(kappScreenWidth, 50 + 70 * 1 + 50 + listHeight + 100 > kappScreenHeight - kTopScreenWidth ? 50 + 70 * 1 + 50 + listHeight + 100 : kappScreenHeight - kTopScreenWidth);
    
    // 第一行
    if (!firstLineView) {
        firstLineView = [[UIView alloc] init];
        [backView addSubview:firstLineView];
        [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kappScreenWidth);
            make.top.equalTo(backView);
            make.left.equalTo(self.view);
            make.height.mas_equalTo(50);
        }];
        firstLineView.backgroundColor = WhiteColor;
    }
    
    //    人数
    if (personCountLbel == nil) {
        personCountLbel = [UILabel new];
        [firstLineView addSubview:personCountLbel];
        [personCountLbel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(firstLineView.mas_right).offset(-20);
            make.centerY.equalTo(firstLineView.mas_centerY);
            make.top.equalTo(firstLineView);
        }];
        
        personCountLbel.textColor = gray104;
        personCountLbel.font = FONT12;
        personCountLbel.textAlignment = NSTextAlignmentRight;
    }
    
    //    波数
    if (daysBoNumberLabel == nil) {
        daysBoNumberLabel = [UILabel new];
        [firstLineView addSubview:daysBoNumberLabel];
        [daysBoNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (kappScreenWidth <= 320) {
                make.right.equalTo(personCountLbel.mas_left).offset(-3);
            } else {
                make.right.equalTo(personCountLbel.mas_left).offset(-10);
            }
            
            make.centerY.equalTo(firstLineView.mas_centerY);
            make.top.equalTo(firstLineView);
        }];
        daysBoNumberLabel.lineBreakMode = NSLineBreakByTruncatingHead;
        daysBoNumberLabel.textColor = gray104;
        daysBoNumberLabel.font = FONT12;
        daysBoNumberLabel.textAlignment = NSTextAlignmentRight;
    }
    
    //    订单号
    if (orderNumberLabel == nil) {
        orderNumberLabel = [UILabel new];
        [firstLineView addSubview:orderNumberLabel];
        [orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstLineView).offset(20);
            make.centerY.equalTo(firstLineView.mas_centerY);
            make.top.equalTo(firstLineView);
            if (kappScreenWidth <= 320) {
                make.right.equalTo(daysBoNumberLabel.mas_left).offset(-3);
            } else {
                make.right.equalTo(daysBoNumberLabel.mas_left).offset(-10);
            }
            
        }];
        orderNumberLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        orderNumberLabel.textColor = gray104;
        orderNumberLabel.font = FONT12;
    }
    
    
    
    // line
    if (!lineView) {
        lineView =  [UIView new];
        [firstLineView addSubview:lineView];
        lineView.backgroundColor = gray238;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstLineView);
            make.right.equalTo(firstLineView);
            make.bottom.equalTo(firstLineView);
            make.height.mas_equalTo(1);
        }];
    }
    
    // 接待  录入  变更
    CGFloat height = 70;
    if (kappScreenWidth == 320) {
        height = 70;
    }
    if (!firstReceptionView ) {
        firstReceptionView = [[LJReceptionListRowView alloc] init];
        [backView addSubview:firstReceptionView];
        [firstReceptionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstLineView);
            make.right.equalTo(firstLineView);
            make.top.equalTo(firstLineView.mas_bottom);
            make.height.mas_equalTo(height);
        }];
    }
    
    if (!listScrollView) {
        listScrollView = [[UIScrollView alloc] init];
        listScrollView.backgroundColor = WhiteColor;
        listScrollView.bounces = NO;
        [backView addSubview:listScrollView];
        
    }
    
    listScrollView.frame = CGRectMake(0,  50 + 70 * 1 + 10, kappScreenWidth, listHeight);
    
    if (!gridView) {
        gridView = [[LJHLGridView alloc] init];
        gridView.isConsumption = NO;
        gridView.superVC = self;
        gridView.delegate = self;
        gridView.dataList = dataList;
        [listScrollView addSubview:gridView];
    }
    
    gridView.frame = CGRectMake(0, 0, gridViewWidth, listHeight);
    gridView.dataList = dataList;
    
    if (leftBottomButton) {
        [leftBottomButton removeFromSuperview];
        [rightBottomButton removeFromSuperview];
        
    }
    leftBottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:leftBottomButton];
    [leftBottomButton setBackgroundImage:[LJColorImage imageWithColor:gray146] forState:UIControlStateSelected];
    
    [leftBottomButton setBackgroundImage:[LJColorImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    
    
    rightBottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:rightBottomButton];
    
    leftBottomButton.clipsToBounds = YES;
    rightBottomButton.clipsToBounds = YES;
    [rightBottomButton setBackgroundImage:[LJColorImage imageWithColor:gray146] forState:UIControlStateSelected];
    
    [rightBottomButton setBackgroundImage:[LJColorImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    
    [leftBottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kappScreenHeight - kTopScreenWidth - (50 + 1 * height + 10 + listHeight) > 110) {
            make.bottom.equalTo(self.view).offset(-30);
            make.left.equalTo(self.view).offset(30);
            make.right.equalTo(self.view.mas_centerX).offset(-15);
            make.height.mas_equalTo(50);
        } else {
            make.top.equalTo(listScrollView.mas_bottom).offset(30);
            make.left.equalTo(self.view).offset(30);
            make.right.equalTo(self.view.mas_centerX).offset(-30);
            make.height.mas_equalTo(50);
        }
        
    }];
    leftBottomButton.backgroundColor = LightBrownColor;
    [leftBottomButton setTitle:@"消费单" forState:UIControlStateNormal];
    
    leftBottomButton.layer.cornerRadius = 25;
    
    [rightBottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(15);
        make.right.equalTo(self.view).offset(-30);
        make.centerY.equalTo(leftBottomButton);
        make.height.mas_equalTo(50);
    }];
    rightBottomButton.backgroundColor = NavBackColor;
    [rightBottomButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [leftBottomButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBottomButton setTitle:@"确定" forState:UIControlStateNormal];
    rightBottomButton.layer.cornerRadius = 25;
   
    orderNumberLabel.text =[NSString stringWithFormat:@"单号:%@", [[self.dataDic objectForKey:@"receptionOrderHeadTab"]  objectForKey:@"orderCd"]];

    daysBoNumberLabel.text = [NSString stringWithFormat:@"当日波数:%@", [[self.dataDic objectForKey:@"receptionOrderHeadTab"]  objectForKey:@"customerTurnCd"]];

    personCountLbel.text = [NSString stringWithFormat:@"人数:%@", [[self.dataDic objectForKey:@"receptionOrderHeadTab"]  objectForKey:@"customerQty"]];


    firstReceptionView.nameLabel.text = [NSString stringWithFormat:@"接待员:%@",[[self.dataDic objectForKey:@"receptionOrderHeadTab"] objectForKey:@"salemanName"]];
    firstReceptionView.numberLabel.text = [NSString stringWithFormat:@"编号:%@",[[self.dataDic objectForKey:@"receptionOrderHeadTab"] objectForKey:@"salemanCd"]];
    firstReceptionView.dutyLabel.text = [NSString stringWithFormat:@"职务:%@",[self.dataDic objectForKey:@"salemanPosition"]];
    firstReceptionView.timeLbael.text = [NSString stringWithFormat:@"接待时间:%@",[[self.dataDic objectForKey:@"receptionOrderHeadTab"] objectForKey:@"createDate"]];
    
    
   
//    secondReceptionView.nameLabel.text = [NSString stringWithFormat:@"录入员:%@",[self.dataDic objectForKey:@"createUserName"]];
//    secondReceptionView.numberLabel.text = [NSString stringWithFormat:@"编号:%@",[[self.dataDic objectForKey:@"receptionOrderHeadTab"] objectForKey:@"createUser"]];
//    secondReceptionView.dutyLabel.text = [NSString stringWithFormat:@"职务:%@",[self.dataDic objectForKey:@"createUserName"]];
//    
//    secondReceptionView.timeLbael.text = [NSString stringWithFormat:@"录入时间:%@",[[self.dataDic objectForKey:@"receptionOrderHeadTab"] objectForKey:@"createDate"]];
//    
//    
//    thirdReceptionView.nameLabel.text = [NSString stringWithFormat:@"变更员:%@",[self.dataDic objectForKey:@"updateUserName"]];
//    thirdReceptionView.numberLabel.text = [NSString stringWithFormat:@"编号:%@",[[self.dataDic objectForKey:@"receptionOrderHeadTab"] objectForKey:@"updateUser"]];
//    thirdReceptionView.dutyLabel.text = [NSString stringWithFormat:@"职务:%@",[self.dataDic objectForKey:@"updateUserPosition"]];
//    
//    thirdReceptionView.timeLbael.text = [NSString stringWithFormat:@"变更时间:%@",[[self.dataDic objectForKey:@"receptionOrderHeadTab"] objectForKey:@"updateDate"]];
    
    [self.view bringSubviewToFront:topView];
    [self.view bringSubviewToFront:rightMenuView];
    
    myControl = [[UIControl alloc] init];
    myControl.frame = CGRectMake(0, 0, kappScreenWidth, kappScreenHeight);
    myControl.backgroundColor = [UIColor blackColor];
    myControl.alpha = 0.4;
    [myControl addTarget:self action:@selector(closePickView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myControl];
    myControl.hidden = YES;
    
    pickView = [[LJPickerView alloc] init];
    pickView.delegate = self;
    pickView.frame = CGRectMake(0, kappScreenHeight, kappScreenWidth, 260);
    [self.view addSubview:pickView];
    pickView.backgroundColor = WhiteColor;
    
    listScrollView.contentSize = CGSizeMake(gridViewWidth, listScrollView.frame.size.height);
}


- (void) buttonPressed:(UIButton *) sender {
    if (sender == rightBottomButton) {
        if (sender.isSelected) {
            return;
        }
        [sender setSelected:YES];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
        [dic setValue:[userDefaults objectForKey:USERID] forKey:@"updateUser"];
        NSMutableArray *arr = [NSMutableArray array];
        for (LJReceptionDetailModel *entity in self.dataList) {
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
            if (entity.orderCd.length) {
                [mutDic setValue:entity.orderCd forKey:@"orderCd"];
            }
            
            if (entity.customerCd.length) {
                [mutDic setValue:entity.customerCd forKey:@"customerCd"];
            }
            
            if (entity.projectCd.length) {
                [mutDic setValue:entity.projectCd forKey:@"projectCd"];
            }
            if (entity.detailNo.length) {
                [mutDic setValue:entity.detailNo forKey:@"detailNo"];
            }
            
            if (entity.sex.length) {
                [mutDic setValue:entity.sex forKey:@"sex"];
            }
            if (entity.artificer1Cd.length) {
                [mutDic setValue:entity.artificer1Cd forKey:@"artificer1Cd"];
            }
            
            if (entity.artificer1SelectType.length) {
                [mutDic setValue:entity.artificer1SelectType forKey:@"artificer1SelectType"];
            }
            
            if (entity.artificer2Cd.length) {
                [mutDic setValue:entity.artificer2Cd forKey:@"artificer2Cd"];
            }
            
            if (entity.artificer2SelectType.length) {
                [mutDic setValue:entity.artificer2SelectType forKey:@"artificer2SelectType"];
            }
            if (entity.artificer3Cd.length) {
                [mutDic setValue:entity.artificer3Cd forKey:@"artificer3Cd"];
            }
            if (entity.artificer3SelectType.length) {
                [mutDic setValue:entity.artificer3SelectType forKey:@"artificer3SelectType"];
            }
            
            if (entity.artificer4Cd.length) {
                [mutDic setValue:entity.artificer4Cd forKey:@"artificer4Cd"];
            }
            
            if (entity.artificer4SelectType.length) {
                [mutDic setValue:entity.artificer4SelectType forKey:@"artificer4SelectType"];
            }
            
            if (entity.projectNum.length) {
                [mutDic setValue:entity.projectNum forKey:@"projectNum"];
            }
            if (entity.salemanName.length) {
                [mutDic setValue:entity.salemanName forKey:@"salemanName"];
            }
            if (entity.salemanCd.length) {
                [mutDic setValue:entity.salemanCd forKey:@"salemanCd"];
            }
            
//            [mutDic setValue:@"2" forKey:@"d"];
            
            [arr addObject:mutDic];
        }
        [dic setValue:arr forKey:@"detailList"];
        
        NSLog(@"dic %@", dic);
        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] POST:RECEPTIONUPDATE parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
            DISMISS
            if (ISSUCCESS) {
//                [self loadData];
                if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[LJAddClientViewController class]]) {
                    ShoppingMallTabBarViewController *tab = [[ShoppingMallTabBarViewController alloc] init];
                    if (tab.selectedIndex) {
                        tab.selectedIndex = 1;
                        [tab.bottomTabBarView selectIndex:1];
                    }
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                } else {
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                if ([OBJMESSAGE isEqualToString:@"artificer_project_error"]) {
                    SHOWTEXTINWINDOW(@"该技师不会此项目", 1);
                } else if ([OBJMESSAGE isEqualToString:@"same_artificer_error"]) {
                    SHOWTEXTINWINDOW(@"每位客户只能点钟一位技师", 1);
                } else {
                    BADREQUEST
                }
            }
            [sender setSelected:NO];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [sender setSelected:NO];
        }];
    } else if (sender == leftBottomButton) {
        if (sender.isSelected) {
            return;
        }
        [sender setSelected:YES];
        
        NSInteger count = 0;
        for (LJReceptionDetailModel *entity in self.dataList) {
            if (entity.isSelected) {
                count ++;
            }
        }
        
        if (count == 0) {
            SHOWTEXTINWINDOW(@"请选择明细", 1);
            [sender setSelected:NO];
            return;
        }
        
        BOOL flag = NO;
        for (LJReceptionDetailModel *entity in self.dataList) {
            if (!entity.qtyUpdateFlg && !entity.projectName.length && entity.isSelected) {
                flag = YES;
                break;
            }
        }
        
        if (flag) {
            SHOWTEXTINWINDOW(@"请选择项目", 1);
            [sender setSelected:NO];
            return;
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
        [dic setValue:[userDefaults objectForKey:USERID] forKey:@"updateUser"];
        NSMutableArray *arr = [NSMutableArray array];
        for (LJReceptionDetailModel *entity in self.dataList) {
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
            if (entity.orderCd.length) {
                [mutDic setValue:entity.orderCd forKey:@"orderCd"];
            }
            
            if (entity.customerCd.length) {
                [mutDic setValue:entity.customerCd forKey:@"customerCd"];
            }
            
            if (entity.projectCd.length) {
                [mutDic setValue:entity.projectCd forKey:@"projectCd"];
            }
            if (entity.detailNo.length) {
                [mutDic setValue:entity.detailNo forKey:@"detailNo"];
            }
            
            if (entity.sex.length) {
                [mutDic setValue:entity.sex forKey:@"sex"];
            }
            if (entity.artificer1Cd.length) {
                [mutDic setValue:entity.artificer1Cd forKey:@"artificer1Cd"];
            }
            
            if (entity.artificer1SelectType.length) {
                [mutDic setValue:entity.artificer1SelectType forKey:@"artificer1SelectType"];
            }
            
            if (entity.artificer2Cd.length) {
                [mutDic setValue:entity.artificer2Cd forKey:@"artificer2Cd"];
            }
            
            if (entity.artificer2SelectType.length) {
                [mutDic setValue:entity.artificer2SelectType forKey:@"artificer2SelectType"];
            }
            if (entity.artificer3Cd.length) {
                [mutDic setValue:entity.artificer3Cd forKey:@"artificer3Cd"];
            }
            if (entity.artificer3SelectType.length) {
                [mutDic setValue:entity.artificer3SelectType forKey:@"artificer3SelectType"];
            }
            
            if (entity.artificer4Cd.length) {
                [mutDic setValue:entity.artificer4Cd forKey:@"artificer4Cd"];
            }
            
            if (entity.artificer4SelectType.length) {
                [mutDic setValue:entity.artificer4SelectType forKey:@"artificer4SelectType"];
            }
            
            if (entity.projectNum.length) {
                [mutDic setValue:entity.projectNum forKey:@"projectNum"];
            }
            
            if (entity.salemanName.length) {
                [mutDic setValue:entity.salemanName forKey:@"salemanName"];
            }
            if (entity.salemanCd.length) {
                [mutDic setValue:entity.salemanCd forKey:@"salemanCd"];
            }
            
            [arr addObject:mutDic];
        }
        [dic setValue:arr forKey:@"detailList"];
        
        NSLog(@"dic %@", dic);
        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] POST:RECEPTIONUPDATE parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
            DISMISS
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
            if (ISSUCCESS) {
                LJSelectRoomViewController *next = [[LJSelectRoomViewController alloc] init];
                next.delegate = self;
                next.isConsumption = NO;
                next.navColor = NavBackColor;
                next.titleString = @"选择房间";
                next.view.backgroundColor = WhiteColor;
                
                
                [self.navigationController pushViewController:next animated:YES];
            } else {
                if ([OBJMESSAGE isEqualToString:@"artificer_project_error"]) {
                    SHOWTEXTINWINDOW(@"该技师不会此项目", 1);
                } else if ([OBJMESSAGE isEqualToString:@"same_artificer_error"]) {
                    SHOWTEXTINWINDOW(@"每位客户只能点钟一位技师", 1);
                }  else {
                    BADREQUEST
                }
            }
            [sender setSelected:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [sender setSelected:NO];
        }];
        // 转消费单
        
    }
}

- (void)sendRoom:(LJRoomModel *)room {
    // 转消费单
    self.isZhuan = YES;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
    if (room.roomCd.length) {
        [dic setValue:room.roomCd forKey:@"roomCd"];
    }
    if (self.orderCd.length) {
        [dic setValue:self.orderCd forKey:@"orderCd"];
    }
    
    if (self.pendingList) {
        [self.pendingList removeAllObjects];
    } else {
        self.pendingList = [NSMutableArray array];
    }
    for (int i = 0; i < self.dataList.count; i++) {
        LJReceptionDetailModel *entity = [self.dataList objectAtIndex:i];
        if (entity.isSelected) {
            if (![self.pendingList containsObject:entity.customerCd]) {
                [self.pendingList addObject:entity.customerCd];
            }
        }
    }
    
    if (self.pendingList.count) {
        [dic setValue:self.pendingList forKey:@"customerCds"];
    } else {
        SHOWTEXTINWINDOW(@"至少选择一条", 1);
        return;
    }
    NSLog(@"dic = %@", dic);
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:JIEDAIXIAOFEI parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        if (ISSUCCESS) {
            [self loadData];
        } else {
            if ([OBJMESSAGE isEqualToString:@"error_sex"]) {
                SHOWTEXTINWINDOW(@"性别不能为空", 1);
            } else if ([OBJMESSAGE isEqualToString:@"error_sofa"]) {
                SHOWTEXTINWINDOW(@"房间沙发数量不足", 1);
            } else if ([OBJMESSAGE isEqualToString:@"error_project"]) {
                SHOWTEXTINWINDOW(@"项目不能为空", 1);
            }  else if ([OBJMESSAGE isEqualToString:@"error_waiting"]) {
                SHOWTEXTINWINDOW(@"多人项目只能选择空闲技师", 1);
//                [[iToast makeText:@"多人项目只能选择空闲技师"] show];
            } else {
                BADREQUEST
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

- (void) saveData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
    [dic setValue:[userDefaults objectForKey:USERID] forKey:@"updateUser"];
    NSMutableArray *arr = [NSMutableArray array];
    for (LJReceptionDetailModel *entity in self.dataList) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
        if (entity.orderCd.length) {
            [mutDic setValue:entity.orderCd forKey:@"orderCd"];
        }
        
        if (entity.customerCd.length) {
            [mutDic setValue:entity.customerCd forKey:@"customerCd"];
        }
        
        if (entity.projectCd.length) {
            [mutDic setValue:entity.projectCd forKey:@"projectCd"];
        }
        if (entity.detailNo.length) {
            [mutDic setValue:entity.detailNo forKey:@"detailNo"];
        }
        
        if (entity.sex.length) {
            [mutDic setValue:entity.sex forKey:@"sex"];
        }
        if (entity.artificer1Cd.length) {
            [mutDic setValue:entity.artificer1Cd forKey:@"artificer1Cd"];
        }

        if (entity.artificer1SelectType.length) {
            [mutDic setValue:entity.artificer1SelectType forKey:@"artificer1SelectType"];
        }
        
        if (entity.artificer2Cd.length) {
            [mutDic setValue:entity.artificer2Cd forKey:@"artificer2Cd"];
        }
        
        if (entity.artificer2SelectType.length) {
            [mutDic setValue:entity.artificer2SelectType forKey:@"artificer2SelectType"];
        }
        if (entity.artificer3Cd.length) {
            [mutDic setValue:entity.artificer3Cd forKey:@"artificer3Cd"];
        }
        if (entity.artificer3SelectType.length) {
            [mutDic setValue:entity.artificer3SelectType forKey:@"artificer3SelectType"];
        }
        
        if (entity.artificer4Cd.length) {
            [mutDic setValue:entity.artificer4Cd forKey:@"artificer4Cd"];
        }
        
        if (entity.artificer4SelectType.length) {
            [mutDic setValue:entity.artificer4SelectType forKey:@"artificer4SelectType"];
        }
        
        if (entity.projectNum.length) {
            [mutDic setValue:entity.projectNum forKey:@"projectNum"];
        }
        
        if (entity.salemanName.length) {
            [mutDic setValue:entity.salemanName forKey:@"salemanName"];
        }
        if (entity.salemanCd.length) {
            [mutDic setValue:entity.salemanCd forKey:@"salemanCd"];
        }
        
        [arr addObject:mutDic];
    }
    [dic setValue:arr forKey:@"detailList"];
    
    NSLog(@"dic %@", dic);
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:RECEPTIONUPDATE parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        DISMISS
        if (ISSUCCESS) {
            
        } else {
            if ([OBJMESSAGE isEqualToString:@"artificer_project_error"]) {
                SHOWTEXTINWINDOW(@"该技师不会此项目", 1);
            } else if ([OBJMESSAGE isEqualToString:@"same_artificer_error"]) {
                SHOWTEXTINWINDOW(@"每位客户只能点钟一位技师", 1);
            } else {
                BADREQUEST
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}



//键盘控制
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary* info = [notif userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    if(kbSize.height == 216)
    {
        keyboardSizeHeight = kbSize.height;
    }
    else
    {
        keyboardSizeHeight = kbSize.height;   //252 - 216 系统键盘的两个不同高度
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        backView.frame = CGRectMake(0.0f, 50-keyboardSizeHeight, self.view.frame.size.width, self.view.frame.size.height);
    }];
    //输入框位置动画加载
    //    [self begainMoveUpAnimation:keyboardhight];
    
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    keyboardSizeHeight = keyboardSize.height;
    [UIView animateWithDuration:0.1 animations:^{
        backView.frame = CGRectMake(0.0f, kTopScreenWidth, backView.frame.size.width, backView.frame.size.height);
    }];
    
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (backView.frame.size.height - keyboardSizeHeight);//键盘高度216 或者 253
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0) {
        //        backView.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
@end
