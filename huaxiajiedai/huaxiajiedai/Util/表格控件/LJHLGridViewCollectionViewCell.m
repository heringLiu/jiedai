//
//  LJHLGridViewCollectionViewCell.m
//  huaxiajiedai
//
//  Created by qm on 16/4/18.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJHLGridViewCollectionViewCell.h"

@implementation LJHLGridViewCollectionViewCell
@synthesize selectedBtn, cornerImage, leftView;
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        if (self.titleLabel == nil) {
            self.titleLabel = [[UILabel alloc] init];
            [self addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.right.equalTo(self);
                make.top.equalTo(self);
                make.bottom.equalTo(self);
            }];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
        self.titleLabel.numberOfLines = 0;
        
        selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedBtn.backgroundColor = gray250;
        [selectedBtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectedBtn];
        [selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];

        leftView = [UIView new];
        leftView.tag = 1000;
        [selectedBtn addSubview:leftView];
        leftView.backgroundColor = NavBackColor;
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selectedBtn);
            make.top.equalTo(selectedBtn);
            make.bottom.equalTo(selectedBtn);
            make.width.mas_equalTo(5);
        }];
        selectedBtn.userInteractionEnabled = NO;
        
        cornerImage = [[UIImageView alloc] init];
        cornerImage.tag = 1000;
        [self addSubview:cornerImage];
        [cornerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cornerImage.superview.mas_right);
            make.bottom.equalTo(cornerImage.superview.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.tag = 1111;
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.bottom.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(1);
        }];
        self.lineView.backgroundColor = gray238;
    }
    
    return self;
}

- (void)setIsConsumption:(BOOL)isConsumption {
    _isConsumption = isConsumption;
    [selectedBtn setImage:isConsumption ? [UIImage imageNamed:@"xf_btn_unchecked"] : [UIImage imageNamed:@"jd_btn_unchecked"] forState:UIControlStateNormal];
    [selectedBtn setImage:isConsumption ? [UIImage imageNamed:@"xf_btn_checked"] : [UIImage imageNamed:@"jd_btn_checked"] forState:UIControlStateSelected];
    cornerImage.image = isConsumption ? [UIImage imageNamed:@"xf_jb1"] : [UIImage imageNamed:@"jd_jb1"];
}


- (void)isShowButton:(BOOL)isShow {
    if (isShow) {
        selectedBtn.hidden = NO;
        self.titleLabel.hidden = YES;
    }
}

- (void) ButtonClick:(UIButton *) sender {
    [sender setSelected:!sender.isSelected];
    
}

- (void) setCellWithTitle:(NSString *) title {
    self.titleLabel.hidden = NO;
    selectedBtn.hidden = YES;
    self.titleLabel.text = title;
    if (![title isEqualToString:@"全选"]) {
        self.titleLabel.font = FONT15;
        self.titleLabel.textColor = gray146;
    } else {
        self.titleLabel.font = FONT17;
        self.titleLabel.textColor = gray104;
    }
}


@end
