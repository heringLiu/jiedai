//
//  LJAddClientViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/4/15.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJNornalView.h"
#import "LJPickerView.h"
#import "LJReceptionListViewController.h"
#import "LJConsumptionViewController.h"

@interface LJAddClientViewController : UIViewController <CustomTopNavigationViewDelegate, UITextFieldDelegate, TapViewDelegate, PickViewDelegate>

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (nonatomic, strong) NSString *bociString;

@property (nonatomic, strong) NSString *customerType;

// 波次
@property (nonatomic, strong) UITextField *bociTextfield;

// 男顾客
@property (nonatomic, strong) UITextField *maleTextfield;
// 女顾客
@property (nonatomic, strong) UITextField *femaleTextfield;
// 共计
@property (nonatomic, strong) UITextField *allCountTextfield;
// 推销员标号
@property (nonatomic, strong) UITextField *salesmanNumberLabel;
// 推销员姓名
@property (nonatomic, strong) UITextField *salesmanNameLabel;
// 客户类型
@property (nonatomic, strong) UITextField *clientTypeLabel;
// 支付方式
@property (nonatomic, strong) UITextField *payTextField;

@property (nonatomic, strong) UIControl *myControl;


@property (nonatomic, strong) LJPickerView *pickView;

@property (nonatomic, strong) NSString *selectType;

@property (nonatomic, strong) NSString *parameterCd;

@property (nonatomic, strong) NSString *employeeId;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *orderCd;

@property (nonatomic, assign) BOOL isConsumption;

@property (nonatomic, strong) NSString *roomCd;

@property (nonatomic, strong) NSString *settlePay;

@end
