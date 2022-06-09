//
//  HLTotalTableViewCell.m
//  huaxiajishi
//
//  Created by gjhgj on 2017/9/23.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "HLTotalTableViewCell.h"

@implementation HLTotalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellWithDic:(NSDictionary *)dic {
    self.backgroundColor = gray238;
    self.backView = [[UIView alloc] init];
    [self addSubview:self.backView];
    self.backView.backgroundColor = WhiteColor;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    self.HLLeftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[dic objectForKey:@"listImageName"]]];
    [self.backView addSubview:self.HLLeftImageView];
    [self.HLLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(20);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.totalLabel = [[UILabel alloc] init];
    [self.backView addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.HLLeftImageView.mas_right).offset(20);
        make.centerY.equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    
    self.HLRightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [self.backView addSubview:self.HLRightImageView];
    [self.HLRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-15);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    self.totalLabel.text = [NSString stringWithFormat:@"%@:%@", [dic objectForKey:@"listName"], [dic objectForKey:@"listValue"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
