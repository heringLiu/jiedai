//
//  LJCollectionHeaderView.h
//  huaxiajiedai
//
//  Created by qm on 16/4/20.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderViewDelegate <NSObject>

-(void) selectedAll:(UIButton *) sender ;

@end


@interface LJCollectionHeaderView : UIView

@property (nonatomic, assign) id<HeaderViewDelegate> delegate;

/*
 [cell setCellWithTitle:@"全选"];
 [cell setCellWithTitle:@"客户编号"];

 [cell setCellWithTitle:@"性别"];

 [cell setCellWithTitle:@"沙发号"];

 [cell setCellWithTitle:@"项目名称"];

 [cell setCellWithTitle:@"技师"];

 [cell setCellWithTitle:@"房间"];

 [cell setCellWithTitle:@"数量"];

 [cell setCellWithTitle:@"金额"];

 [cell setCellWithTitle:@"项目状态"];

 [cell setCellWithTitle:@"结算状态"];

 [cell setCellWithTitle:@"推销员"];
 */

//@property (nonatomic, assign) BOOL isConsumption;

@property (nonatomic, strong) UIButton *selectedAllBtn;
@property (nonatomic, strong) UIButton *custmerCdBtn;
@property (nonatomic, strong) UIButton *clientNumberBtn;

@property (nonatomic, strong) UIButton *sexBtn;

@property (nonatomic, strong) UIButton *projectNameBtn;

@property (nonatomic, strong) UIButton *sofaBtn;

@property (nonatomic, strong) UIButton *techniciaBtn;

@property (nonatomic, strong) UIButton *roomNuberBtn;


@property (nonatomic, strong) UIButton *countNumberBtn;


@property (nonatomic, strong) UIButton *moneyBtn;

@property (nonatomic, strong) UIButton *projectStatusBtn;

@property (nonatomic, strong) UIButton *accountStatusBtn;

@property (nonatomic, strong) UIButton *salesmanBtn;

@property (nonatomic, strong) UIButton *serviceStatusBtn;


- (instancetype)initWithFrame:(CGRect)frame isConsumpton:(BOOL) isConsumption isAll:(BOOL) isAll;




@end
