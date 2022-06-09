//
//  LJAddClientViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/4/15.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJAddClientViewController.h"
#import "LJReceptionListViewController.h"
#import "LJConsumptionViewController.h"

#define VIEWHEIGHT 50.0f

@interface LJAddClientViewController () {
    LJNornalView *maleView;
    LJNornalView *bociView;
    UIScrollView *backView;
    
    LJNornalView *femaleView;
    
    LJNornalView *allCountView;
    
    LJNornalView *salesmanNumberView;
    LJNornalView *salesmanNameView;
    LJNornalView *clientTypeView;
    LJNornalView *payView;
    
    UIButton *nextButton;
    
    NSArray *employeeTabs;
    NSArray *customTypeList;
    NSMutableArray *payTypeList;
    
    NSMutableArray *bianhaoArr;
    NSMutableArray *nameArr;
    NSMutableArray *typeArr;
    NSMutableArray *payArr;
    
}

@end

@implementation LJAddClientViewController
@synthesize topView, maleTextfield, femaleTextfield, clientTypeLabel, allCountTextfield, salesmanNameLabel, salesmanNumberLabel, pickView, myControl, isConsumption, payTextField;

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%f", kappScreenHeight);
    if (kappScreenHeight == 480) {
        if (self.bociString.length) {
            if (self.isConsumption) {
                backView.contentSize = CGSizeMake(kappScreenWidth, backView.frame.size.height + 110);
            } else {
                backView.contentSize = CGSizeMake(kappScreenWidth, backView.frame.size.height + 50);
            }
            
        } else {
            backView.contentSize = CGSizeMake(kappScreenWidth, backView.frame.size.height + 70);
        }
        
    } else if (kappScreenHeight == 568.0f) {
        if (self.bociString.length) {
            backView.contentSize = CGSizeMake(kappScreenWidth, backView.frame.size.height + 50);
        } else {
            backView.contentSize = CGSizeMake(kappScreenWidth, backView.frame.size.height);
        }
    } else {
        backView.contentSize = CGSizeMake(kappScreenWidth, backView.frame.size.height);
    }
    
//    payArr = [NSMutableArray arrayWithArray:@[@"预结", @"预结废弃", @"现金", @"POS", @"支票", @"支付宝", @"微信", @"会员卡", @"票券", @"押金", @"免单", @"打折", @"挂账", @"团购", @"套盒"]];
    
}

- (void) loadData {
    NSString *url = self.bociString.length ? SALESMANLIST : RECEPTIONCUSTOMERTYPE;
    
    [[NetWorkingModel sharedInstance] GET:url parameters:@{@"storeCd":STORCDSTRING} success:^(AFHTTPRequestOperation *operation, id obj) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        bianhaoArr = [NSMutableArray array];
        nameArr = [NSMutableArray array];
        typeArr = [NSMutableArray array];
        payArr = [NSMutableArray array];
        if (ISSUCCESS) {
            
            
            self.salesmanNumberLabel.text = [userDefaults objectForKey:USERID];
            self.salesmanNameLabel.text = [userDefaults objectForKey:USERNAME];
            
            employeeTabs = [CONTENTOBJ objectForKey:@"empList"];
            customTypeList = [CONTENTOBJ objectForKey:@"customTypeList"];
            payTypeList = [NSMutableArray arrayWithArray:[CONTENTOBJ objectForKey:@"payTypes"]];
            [payTypeList insertObject:@{@"charValue1":@"请选择", @"parameterCd":@""} atIndex:0];
            
            for (NSDictionary *dic in employeeTabs) {
                [bianhaoArr addObject:[dic objectForKey:@"employeeId"]];
                [nameArr addObject:[dic objectForKey:@"name"]];
            }
            
            for (NSDictionary *dic  in customTypeList) {
                
                [typeArr addObject:[dic objectForKey:@"charValue1"]];
                if (self.customerType.length) {
                    if ([[dic objectForKey:@"parameterCd"] isEqualToString:self.customerType]) {
                        clientTypeLabel.text = [dic objectForKey:@"charValue1"];
                        self.parameterCd = self.customerType;
                    }
                }
            }
            
            for (NSDictionary *dic in payTypeList) {
                if (payArr == nil) {
                    payArr = [NSMutableArray array];
                }
                [payArr addObject:[dic objectForKey:@"charValue1"]];
            }
            
            if (!self.customerType.length) {
                BOOL isContained = NO;

                for (NSDictionary *dic in customTypeList) {
                    //                    默认显示社交 如果没有显示 第一行
                    if ([[dic objectForKey:@"charValue1"] isEqualToString:@"社交"]) {
                        clientTypeLabel.text = [dic objectForKey:@"charValue1"];
                        self.parameterCd = [dic objectForKey:@"parameterCd"];
                        isContained = YES;
                        break;
                    }
                }
                
                if (!isContained) {
                    clientTypeLabel.text = customTypeList.count ? [customTypeList[0] objectForKey:@"charValue1"] : @"请选择";
                    self.parameterCd = customTypeList.count ? [customTypeList[0] objectForKey:@"parameterCd"] : @"";
                }
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadData];
    
    // Do any additional setup after loading the view.
    backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kappScreenWidth, kappScreenHeight- kTopScreenWidth)];
    backView.bounces = YES;

    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    self.view.backgroundColor = gray238;
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    [self.view addSubview:topView];
    topView.delegate = self;
    if (isConsumption) {
        topView.backgroundColor = navLightBrownColor;
    } else {
        topView.backgroundColor = NavBackColor;
    }
    topView.titleLabel.text = @"基本信息";
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    
    // 波次
    bociView = [[LJNornalView alloc] initWithTitleName:@"波次"];
    bociView.delegaete = self;
    
    [backView addSubview:bociView];
    //    [maleView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(backView.mas_left).offset(0);
    //        make.right.equalTo(backView.mas_right).offset(0);
    //        make.top.equalTo(backView).offset(0);
    //        make.height.mas_equalTo(VIEWHEIGHT);
    //    }];
    if (self.bociString.length) {
        bociView.frame = CGRectMake(0, 0, kappScreenWidth, VIEWHEIGHT);
    } else {
        bociView.frame = CGRectMake(0, 0, kappScreenWidth, 0);
    }
    
    self.bociTextfield = [[UITextField alloc] init];
    [bociView addSubview:self.bociTextfield];
    [self.bociTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bociView.mas_right).offset(-20);
        make.top.equalTo(bociView);
        make.width.mas_equalTo(150);
        make.bottom.equalTo(bociView);
    }];
    self.bociTextfield.textAlignment = NSTextAlignmentRight;
    self.bociTextfield.delegate = self;
    self.bociTextfield.textColor = gray104;
    self.bociTextfield.text = self.bociString;
    self.bociTextfield.enabled = NO;
    bociView.clipsToBounds = YES;
    
    // 男顾客
    maleView = [[LJNornalView alloc] initWithTitleName:@"男顾客"];
    maleView.delegaete = self;
    
    [backView addSubview:maleView];
    
    [maleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bociView);
        make.right.equalTo(bociView);
        make.top.equalTo(bociView.mas_bottom);
        make.height.mas_equalTo(VIEWHEIGHT);
    }];
    maleTextfield = [[UITextField alloc] init];
    [maleView addSubview:maleTextfield];
    [maleTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(maleView.mas_right).offset(-20);
        make.top.equalTo(maleView);
        make.width.mas_equalTo(80);
        make.bottom.equalTo(maleView);
    }];
    maleTextfield.textAlignment = NSTextAlignmentRight;
    maleTextfield.text = @"0";
    maleTextfield.delegate = self;
    maleTextfield.textColor = gray104;

    
    // 女顾客
    femaleView = [[LJNornalView alloc] initWithTitleName:@"女顾客"];
    femaleView.delegaete = self;
    [backView addSubview:femaleView];
    [femaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maleView);
        make.right.equalTo(maleView);
        make.top.equalTo(maleView.mas_bottom);
        make.height.mas_equalTo(VIEWHEIGHT);
    }];
    femaleView.bottomLine.hidden = YES;
    
    femaleTextfield = [[UITextField alloc] init];
    [femaleView addSubview:femaleTextfield];
    [femaleTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(femaleView.mas_right).offset(-20);
        make.top.equalTo(femaleView);
        make.width.mas_equalTo(80);
        make.bottom.equalTo(femaleView);
    }];
    femaleTextfield.textAlignment = NSTextAlignmentRight;
    femaleTextfield.text = @"0";
    femaleTextfield.delegate = self;
    femaleTextfield.textColor = gray104;
    
    // 数量 共计
    allCountView = [[LJNornalView alloc] initWithTitleName:@"共计："];
    allCountView.delegaete = self;
    [backView addSubview:allCountView];
    [allCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maleView);
        make.right.equalTo(maleView);
        make.top.equalTo(femaleView.mas_bottom).offset(10);
        make.height.mas_equalTo(VIEWHEIGHT);
    }];
    allCountView.bottomLine.hidden = YES;
    
    
    allCountTextfield= [[UITextField alloc] init];
    [allCountView addSubview:allCountTextfield];
    if (self.isConsumption) {
        allCountTextfield.enabled = NO;
    } else {
        allCountTextfield.enabled = YES;
    }
    [allCountTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(allCountView.mas_right).offset(-20);
        make.top.equalTo(allCountView);
        make.width.mas_equalTo(80);
        make.bottom.equalTo(allCountView);
    }];
    allCountTextfield.textAlignment = NSTextAlignmentRight;
    allCountTextfield.text = @"0";
    allCountTextfield.delegate = self;
    allCountTextfield.textColor = gray104;
    
    // 接待员  销售员
    NSString *str = self.bociString.length ? @"推销员" : @"接待员";
    salesmanNumberView = [[LJNornalView alloc] initWithTitleName:[NSString stringWithFormat:@"%@编号", str]];
    salesmanNumberView.delegaete = self;
    [backView addSubview:salesmanNumberView];
    [salesmanNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maleView);
        make.right.equalTo(maleView);
        make.top.equalTo(allCountView.mas_bottom).offset(10);
        make.height.mas_equalTo(VIEWHEIGHT);
    }];
    
    salesmanNumberLabel= [[UITextField alloc] init];
    [salesmanNumberView addSubview:salesmanNumberLabel];
    [salesmanNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(salesmanNumberView.mas_right).offset(-20);
        make.top.equalTo(salesmanNumberView);
        make.width.mas_equalTo(180);
        make.bottom.equalTo(salesmanNumberView);
    }];
    salesmanNumberLabel.textAlignment = NSTextAlignmentRight;
    self.salesmanNumberLabel.text = [userDefaults objectForKey:USERID];
    salesmanNumberLabel.delegate = self;
    salesmanNumberLabel.textColor = gray104;
    salesmanNumberLabel.enabled = YES;
    
    // 接待员  销售员
    
    salesmanNameView = [[LJNornalView alloc] initWithTitleName:[NSString stringWithFormat:@"%@姓名", str]];
    salesmanNameView.delegaete = self;
    [backView addSubview:salesmanNameView];
    [salesmanNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maleView);
        make.right.equalTo(maleView);
        make.top.equalTo(salesmanNumberLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(VIEWHEIGHT);
    }];
    salesmanNameView.bottomLine.hidden = YES;
    
    salesmanNameLabel= [[UITextField alloc] init];
    [salesmanNameView addSubview:salesmanNameLabel];
    [salesmanNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(salesmanNameView.mas_right).offset(-20);
        make.top.equalTo(salesmanNameView);
        make.width.mas_equalTo(80);
        make.bottom.equalTo(salesmanNameView);
    }];
    salesmanNameLabel.textAlignment = NSTextAlignmentRight;
    self.salesmanNameLabel.text = [userDefaults objectForKey:USERNAME];
    salesmanNameLabel.delegate = self;
    salesmanNameLabel.textColor = gray104;
    salesmanNameLabel.enabled = NO;

    // 顾客类型
    clientTypeView = [[LJNornalView alloc] initWithTitleName:@"顾客类型"];
    clientTypeView.delegaete = self;
    [backView addSubview:clientTypeView];
    [clientTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maleView);
        make.right.equalTo(maleView);
        make.top.equalTo(salesmanNameView.mas_bottom).offset(10);
        make.height.mas_equalTo(VIEWHEIGHT);
    }];
    clientTypeView.bottomLine.hidden = YES;
    
    clientTypeLabel= [[UITextField alloc] init];
    [clientTypeView addSubview:clientTypeLabel];
    [clientTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(clientTypeView.mas_right).offset(-20);
        make.top.equalTo(clientTypeView);
        make.width.mas_equalTo(80);
        make.bottom.equalTo(clientTypeView);
    }];
    clientTypeLabel.textAlignment = NSTextAlignmentRight;
    clientTypeLabel.text = @"请选择";
    clientTypeLabel.delegate = self;
    clientTypeLabel.textColor = gray104;
    clientTypeLabel.enabled = NO;
    
    // 支付方式
    if (self.isConsumption) {
        payView = [[LJNornalView alloc] initWithTitleName:@"支付方式"];
        payView.delegaete = self;
        [backView addSubview:payView];
        [payView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(clientTypeView);
            make.right.equalTo(clientTypeView);
            make.top.equalTo(clientTypeView.mas_bottom).offset(10);
            make.height.mas_equalTo(VIEWHEIGHT);
        }];
        payView.bottomLine.hidden = YES;
        
        payTextField = [[UITextField alloc] init];
        [payView addSubview:payTextField];
        [payTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(payView.mas_right).offset(-20);
            make.top.equalTo(payView);
            make.width.mas_equalTo(80);
            make.bottom.equalTo(payView);
        }];
        payTextField.textAlignment = NSTextAlignmentRight;
        payTextField.text = @"请选择";
        payTextField.delegate = self;
        payTextField.textColor = gray104;
        payTextField.enabled = NO;
    }
    
    
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
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:nextButton];
    nextButton.clipsToBounds = YES;
//    nextButton.backgroundColor = isConsumption ? LightBrownColor : NavBackColor;
    
    [nextButton setBackgroundImage:[LJColorImage imageWithColor:isConsumption ? LightBrownColor : NavBackColor] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[LJColorImage imageWithColor:gray146] forState:UIControlStateSelected];
    
    [nextButton setBackgroundImage:[LJColorImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maleView.mas_left).offset(30);
        make.right.equalTo(maleView.mas_right).offset(-30);
        if (kappScreenHeight == 480 || kappScreenHeight == 568.0f) {
            if (self.isConsumption) {
                make.top.equalTo(payView.mas_bottom).offset(20);
            } else {
                make.top.equalTo(clientTypeView.mas_bottom).offset(20);
            }
            
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        }
        make.height.mas_equalTo(60);
    }];
    nextButton.layer.cornerRadius = 30;
    [nextButton setTitle:@"确定" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) nextButtonClick:(UIButton *) sender {
    if (sender.isSelected) {
        return;
    }
    if (clientTypeLabel.text.length == 0 || [clientTypeLabel.text isEqualToString:@"请选择"]) {
        SHOWTEXTINWINDOW(@"请选择客户类型", 1);
        return;
    }
    
    if ([self.allCountTextfield.text integerValue] <= 0) {
        SHOWTEXTINWINDOW(@"至少选择一位客户", 1);
        return;
    }
    
    [nextButton setSelected:YES];
    if (isConsumption) {
        
        
//        NSDictionary *dic = @{@"manQty":self.maleTextfield.text.length ? self.maleTextfield.text : @"0", @"womanQty":self.femaleTextfield.text.length ? self.femaleTextfield.text : @"0", @"customerQty":self.allCountTextfield.text.length ? self.allCountTextfield.text : @"0", @"salemanCd":self.salesmanNumberLabel.text.length ? self.salesmanNumberLabel.text : @"", @"salemanName":self.salesmanNameLabel.text.length ? self.salesmanNameLabel.text : @"", @"customerType":self.parameterCd.length ? self.parameterCd : @"", @"updateUser":[userDefaults objectForKey:USERID],  @"orderCd":self.orderCd.length ? self.orderCd : @"", @"customerTurnCd":self.bociString.length ? self.bociString : @"",  @"storeCd":STORCDSTRING, @"roomCd":self.roomCd.length ? self.roomCd : @""};
        
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:@{@"manQty":self.maleTextfield.text.length ? self.maleTextfield.text : @"0", @"womanQty":self.femaleTextfield.text.length ? self.femaleTextfield.text : @"0", @"customerQty":self.allCountTextfield.text.length ? self.allCountTextfield.text : @"0", @"salemanCd":self.salesmanNumberLabel.text.length ? self.salesmanNumberLabel.text : @"", @"salemanName":self.salesmanNameLabel.text.length ? self.salesmanNameLabel.text : @"", @"customerType":self.parameterCd.length ? self.parameterCd : @"",@"roomCd":self.roomCd.length ? self.roomCd : @"",   @"storeCd":STORCDSTRING,@"updateUser":[userDefaults objectForKey:USERID]}];
        
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:@{@"manQty":self.maleTextfield.text.length ? self.maleTextfield.text : @"0", @"womanQty":self.femaleTextfield.text.length ? self.femaleTextfield.text : @"0", @"customerQty":self.allCountTextfield.text.length ? self.allCountTextfield.text : @"0", @"salemanCd":self.salesmanNumberLabel.text.length ? self.salesmanNumberLabel.text : @"", @"salemanName":self.salesmanNameLabel.text.length ? self.salesmanNameLabel.text : @"", @"customerType":self.parameterCd.length ? self.parameterCd : @"", @"orderCd":self.orderCd.length ? self.orderCd : @"",@"updateUser":[userDefaults objectForKey:USERID]}];
        if (self.settlePay.length) {
            [dic1 setValue:self.settlePay forKey:@"settlePay"];
            [dic2 setValue:self.settlePay forKey:@"settlePay"];
        }
        
        
        NSString *url = self.bociString.length ? RECEPTIONCONSUMERADDCUSTOMER : RECEPTIONCONSUMERORDERINDSERT;
        
        NSDictionary *dic = self.bociString.length ? dic2 : dic1;
        
        NSLog(@"url = %@, dic = %@", url , dic);
        
        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
            DISMISS
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
            if (ISSUCCESS) {
                if (self.bociString.length) {
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LJConsumptionViewController class]]) {
                            LJConsumptionViewController *cVc = (LJConsumptionViewController *)vc;
                            [cVc loadData];
                        }
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    LJConsumptionViewController *next = [[LJConsumptionViewController alloc] init];
                    next.orderCd = [CONTENTOBJ objectForKey:@"orderCd"];
                    [self.navigationController pushViewController:next animated:YES];
                }
                
            } else {
                if ([OBJMESSAGE isEqualToString:@"error_sofa"]) {
                    SHOWTEXTINWINDOW(@"该房间剩余沙发数量不足", 1);
                } else {
                    BADREQUEST
                }
            }
            [nextButton setSelected:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [nextButton setSelected:NO];
        }];
        
        

    } else {
        
        NSDictionary *dic = @{@"manQty":self.maleTextfield.text.length ? self.maleTextfield.text : @"0", @"womanQty":self.femaleTextfield.text.length ? self.femaleTextfield.text : @"0", @"customerQty":self.allCountTextfield.text.length ? self.allCountTextfield.text : @"0", @"salemanCd":self.salesmanNumberLabel.text.length ? self.salesmanNumberLabel.text : @"", @"salemanName":self.salesmanNameLabel.text.length ? self.salesmanNameLabel.text : @"", @"customerType":self.parameterCd.length ? self.parameterCd : @"", @"updateUser":[userDefaults objectForKey:USERID], @"orderCd":self.orderCd.length ? self.orderCd : @"",  @"storeCd":STORCDSTRING};
        
        NSString *url = self.bociString.length ? RECEPTIONORDERHEADERCREATECUSTOMER : RECEPTIONORDERHEADERCREATE;
        
        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
            DISMISS
            if (ISSUCCESS) {
                if (self.bociString.length) {
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LJReceptionListViewController class]]) {
                            LJReceptionListViewController *cVc = (LJReceptionListViewController *)vc;
                            [cVc loadData];
                        }
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    LJReceptionListViewController *next = [[LJReceptionListViewController alloc] init];
                    
                    next.orderCd = [CONTENTOBJ objectForKey:@"orderCd"];
                    [self.navigationController pushViewController:next animated:YES];
                }
                
            }
            [nextButton setSelected:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [nextButton setSelected:NO];
        }];
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)closePickView {
    [self pickViewDone];
}

- (void)pickViewDone {
    [UIView animateWithDuration:0.3 animations:^{
        myControl.hidden = YES;
        pickView.frame = CGRectMake(0, kappScreenHeight, kappScreenWidth, 260);
    }];
    
}

- (void)selectedDone:(NSInteger)index {
    if ([self.selectType isEqualToString:@"type"] && customTypeList.count>index) {
        clientTypeLabel.text = [[customTypeList objectAtIndex:index] objectForKey:@"charValue1"];
        self.parameterCd  = [[customTypeList objectAtIndex:index] objectForKey:@"parameterCd"];
        
    } else if ([self.selectType isEqualToString:@"saleman"] && employeeTabs.count > index) {
        salesmanNameLabel.text = [[employeeTabs objectAtIndex:index] objectForKey:@"name"];
        self.name = salesmanNameLabel.text;
        self.salesmanNumberLabel.text = [[employeeTabs objectAtIndex:index] objectForKey:@"employeeId"];
        self.employeeId = self.salesmanNumberLabel.text;
    } else if ([self.selectType isEqualToString:@"pay"] && payTypeList.count > index) {
        self.payTextField.text = [payArr objectAtIndex:index];
        self.settlePay = [[payTypeList objectAtIndex:index] objectForKey:@"parameterCd"];
    }
}

- (void)tapView:(UIView *)tapView {
    NSLog(@"点击了");
    
    if (tapView == salesmanNameView) {
        self.selectType = @"saleman";
        [self showPickViewWithData:nameArr];
        
    } else if (tapView == clientTypeView) {
        self.selectType = @"type";
        [self showPickViewWithData:typeArr];
        
    } else if (tapView == payView) {
        self.selectType = @"pay";
        [self showPickViewWithData:payArr];
        
    } else {
        [self.view endEditing:YES];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger lengthOfString = string.length;
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
        unichar character = [string characterAtIndex:loopIndex];
        if (character < 48) return NO; // 48 unichar for 0
        if (character > 57) return NO; // 57 unichar for 9
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""] || textField.text.length == 0) {
        textField.text = @"0";
    }
    if (textField == maleTextfield || textField == femaleTextfield) {
        allCountTextfield.text = [NSString stringWithFormat:@"%ld", [maleTextfield.text integerValue] + [femaleTextfield.text integerValue]];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
    
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    return YES;
}


- (void) showPickViewWithData:(NSMutableArray *) datas {
    [self.view endEditing:YES];
    pickView.datas = datas;
    [UIView animateWithDuration:0.3 animations:^{
        myControl.hidden = NO;
        pickView.frame = CGRectMake(0, kappScreenHeight - 260, kappScreenWidth, 260);
    }];
}

- (void)leftButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
