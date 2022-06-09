//
//  LJReceptionListTableViewCell.m
//  huaxiajiedai
//
//  Created by qm on 16/4/18.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJReceptionListTableViewCell.h"

@implementation LJReceptionListTableViewCell
@synthesize selectBtn, clientNumberLabel, sexBtn, sofaBtn, itemNameBtn, technicianBtn, roomBtn, countBtn, moneyBtn, itemStateBtn, jiesuanBtn, salesmanBtn;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void) setCellWithData:(NSDictionary *) data {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jd_jb1"]];
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.backgroundColor = gray238;
    UIView *view = [UIView new];
    [selectBtn addSubview:view];
    view.backgroundColor = NavBackColor;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectBtn);
        make.top.equalTo(selectBtn);
        make.bottom.equalTo(selectBtn);
        make.width.mas_equalTo(3);
    }];
    [selectBtn setImage:[UIImage imageNamed:@"jd_btn_unchecked"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"jd_btn_checked"] forState:UIControlStateSelected];
    [self addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(50);
    }];
    
    clientNumberLabel = [UILabel new];
    [self addSubview:clientNumberLabel];
    [clientNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectBtn.mas_right);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(50);
    }];
    clientNumberLabel.text = @"X00001";
    
    sexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:sexBtn];
    [sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(clientNumberLabel.mas_right);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(50);
    }];
    [sexBtn setTitle:@"男" forState:UIControlStateNormal];
    [sexBtn setTitleColor:gray104 forState:UIControlStateNormal];
    [sexBtn addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView.superview.mas_right);
        make.bottom.equalTo(imageView.superview.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    
    
    
    
}

@end
