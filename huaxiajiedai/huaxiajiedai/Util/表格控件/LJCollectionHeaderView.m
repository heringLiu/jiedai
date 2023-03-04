//
//  LJCollectionHeaderView.m
//  huaxiajiedai
//
//  Created by qm on 16/4/20.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJCollectionHeaderView.h"

@implementation LJCollectionHeaderView
@synthesize selectedAllBtn, clientNumberBtn, sexBtn, sofaBtn, projectNameBtn, techniciaBtn, roomNuberBtn, countNumberBtn, moneyBtn, projectStatusBtn, accountStatusBtn, salesmanBtn, serviceStatusBtn, custmerCdBtn;


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}
/* @"全选" @"客户编号" @"性别" @"沙发号" @"项目名称" @"技师" @"房间" @"数量" @"金额" @"项目状态" @"结算状态" @"推销员" */
- (instancetype)initWithFrame:(CGRect)frame isConsumpton:(BOOL) isConsumption isAll:(BOOL)isAll;{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WhiteColor;
        
        selectedAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:selectedAllBtn];
        [selectedAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(60);
        }];
        [selectedAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [selectedAllBtn setTitle:@"取消" forState:UIControlStateSelected];
        [selectedAllBtn setTitleColor:gray104 forState:UIControlStateNormal];
        [selectedAllBtn setTitleColor:gray104 forState:UIControlStateSelected];
        selectedAllBtn.titleLabel.font = FONT16;
        selectedAllBtn.tag = 1000;
        [selectedAllBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        custmerCdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:custmerCdBtn];
        [custmerCdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selectedAllBtn.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(isAll ? 160 : 0);
        }];
        [custmerCdBtn setTitle:@"消费单号" forState:UIControlStateNormal];
        [custmerCdBtn setTitleColor:gray146 forState:UIControlStateNormal];
        custmerCdBtn.titleLabel.font = FONT14;
        custmerCdBtn.tag = 1021;
        
        clientNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:clientNumberBtn];
        [clientNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(custmerCdBtn.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(80);
        }];
        [clientNumberBtn setTitle:@"客户编号" forState:UIControlStateNormal];
        [clientNumberBtn setTitleColor:gray146 forState:UIControlStateNormal];
        clientNumberBtn.titleLabel.font = FONT14;
        clientNumberBtn.tag = 1001;
        
        sexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:sexBtn];
        [sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(clientNumberBtn.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(60);
        }];
        [sexBtn setTitle:@"性别" forState:UIControlStateNormal];
        [sexBtn setTitleColor:gray146 forState:UIControlStateNormal];
        sexBtn.titleLabel.font = FONT14;
        sexBtn.tag = 1002;
        
        
        projectNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:projectNameBtn];
        [projectNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sexBtn.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(100);
        }];
        [projectNameBtn setTitle:@"项目名称" forState:UIControlStateNormal];
        [projectNameBtn setTitleColor:gray146 forState:UIControlStateNormal];
        projectNameBtn.titleLabel.font = FONT14;
        projectNameBtn.tag = 1004;
        
        
        techniciaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:techniciaBtn];
        [techniciaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(projectNameBtn.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(80);
        }];
        [techniciaBtn setTitle:@"技师" forState:UIControlStateNormal];
        [techniciaBtn setTitleColor:gray146 forState:UIControlStateNormal];
        techniciaBtn.titleLabel.font = FONT14;
        techniciaBtn.tag = 1005;
        
        sofaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:sofaBtn];
        [sofaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(techniciaBtn.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(isConsumption ? 60 : 0);
        }];
        sofaBtn.clipsToBounds = YES;
        [sofaBtn setTitle:@"沙发" forState:UIControlStateNormal];
        [sofaBtn setTitleColor:gray146 forState:UIControlStateNormal];
        sofaBtn.titleLabel.font = FONT14;
        sofaBtn.tag = 1003;
        
        roomNuberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:roomNuberBtn];
        [roomNuberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sofaBtn.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(isConsumption ? 100 : 0);
        }];
        roomNuberBtn.clipsToBounds = YES;
        [roomNuberBtn setTitle:@"房间" forState:UIControlStateNormal];
        [roomNuberBtn setTitleColor:gray146 forState:UIControlStateNormal];
        roomNuberBtn.titleLabel.font = FONT14;
        roomNuberBtn.tag = 1006;
        
        
        countNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:countNumberBtn];
        [countNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(roomNuberBtn.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(60);
        }];
        [countNumberBtn setTitle:@"数量" forState:UIControlStateNormal];
        [countNumberBtn setTitleColor:gray146 forState:UIControlStateNormal];
        countNumberBtn.titleLabel.font = FONT14;
        countNumberBtn.tag = 1007;
        
        
        moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:moneyBtn];
        [moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(countNumberBtn.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(80);
        }];
        [moneyBtn setTitle:@"金额" forState:UIControlStateNormal];
        [moneyBtn setTitleColor:gray146 forState:UIControlStateNormal];
        moneyBtn.titleLabel.font = FONT14;
        moneyBtn.tag = 1008;
        
        
        projectStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:projectStatusBtn];
        [projectStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moneyBtn.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(80);
        }];
        [projectStatusBtn setTitle:@"项目状态" forState:UIControlStateNormal];
        [projectStatusBtn setTitleColor:gray146 forState:UIControlStateNormal];
        projectStatusBtn.titleLabel.font = FONT14;
        projectStatusBtn.tag = 1009;
        projectStatusBtn.clipsToBounds = YES;
        
        serviceStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:serviceStatusBtn];
        [serviceStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(projectStatusBtn.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(isConsumption ? 80 : 0);
        }];
        serviceStatusBtn.clipsToBounds = YES;
        [serviceStatusBtn setTitle:@"服务状态" forState:UIControlStateNormal];
        [serviceStatusBtn setTitleColor:gray146 forState:UIControlStateNormal];
        serviceStatusBtn.titleLabel.font = FONT14;
        serviceStatusBtn.tag = 1012;
        serviceStatusBtn.clipsToBounds = YES;
        
        accountStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:accountStatusBtn];
        [accountStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(serviceStatusBtn.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(isConsumption ? 80 : 0);
        }];
        [accountStatusBtn setTitle:@"结算状态" forState:UIControlStateNormal];
        [accountStatusBtn setTitleColor:gray146 forState:UIControlStateNormal];
        accountStatusBtn.titleLabel.font = FONT14;
        accountStatusBtn.tag = 1010;
        accountStatusBtn.clipsToBounds = YES;
        
        
        salesmanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:salesmanBtn];
        [salesmanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(accountStatusBtn.mas_right);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(80);
        }];
        [salesmanBtn setTitle:@"推销员" forState:UIControlStateNormal];
        [salesmanBtn setTitleColor:gray146 forState:UIControlStateNormal];
        salesmanBtn.titleLabel.font = FONT14;
        salesmanBtn.tag = 1011;
        
    }
    
    return self;
}


- (void) buttonClick:(UIButton *) sender {
    if ([self.delegate respondsToSelector:@selector(selectedAll:)]) {
        [self.delegate selectedAll:sender];
    }
}


@end
