//
//  HLWorksTableViewCell.m
//  huaxiajishi
//
//  Created by gjhgj on 2017/9/17.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "HLWorksTableViewCell.h"

@implementation HLWorksTableViewCell
//@synthesize backView,dateLabel,workAmtLabel,workQtyLabel,selQtyLabel,projectNameLabel,projectTypeNameLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithData:(HLWorksListModel *)entity {
    
    NSInteger labelCount = 2;
    
    if ([entity.type isEqualToString:@"card"]) {
        labelCount = 2;
    } else if ([entity.type isEqualToString:@"ticket"]) {
        labelCount = 4;
    } else if ([entity.type isEqualToString:@"box"]) {
        labelCount = 4;
    }
    
    self.backgroundColor = gray238;
    self.backView = [UIView new];
    [self addSubview:self.backView];
    self.backView.backgroundColor = gray238;
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-1);
    }];
//    backView.layer.masksToBounds = YES;
//    backView.layer.cornerRadius = 10;
    //
    self.leftLabel = [UILabel new];
    [self.backView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView);
        make.left.equalTo(self.backView);
        make.bottom.equalTo(self.backView);
        make.width.mas_equalTo(kMainScreenWidth/labelCount);
    }];
    
    
    self.leftLabel.text = entity.leftName;
    
//
    self.middleLabel = [[UILabel alloc] init];
    [self.backView addSubview:self.middleLabel];
    if ([entity.type isEqualToString:@"card"]) {
        [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView);
            make.left.equalTo(self.leftLabel.mas_right).offset(0);
            make.bottom.equalTo(self.backView);
            make.width.mas_equalTo(0);
        }];
    } else {
        [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView);
            make.left.equalTo(self.leftLabel.mas_right).offset(1);
            make.bottom.equalTo(self.backView);
            make.width.mas_equalTo(kMainScreenWidth/4);
        }];
    }
    
    self.middleLabel.text = entity.middleName;
    
    
    
    //
    self.workQtyLabel = [UILabel new];
    [self.backView  addSubview:self.workQtyLabel];
    [self.workQtyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView);
        if ([entity.type isEqualToString:@"card"]) {
            make.left.equalTo(self.middleLabel.mas_right).offset(0);
            make.width.mas_equalTo(0);
        } else {
            make.left.equalTo(self.middleLabel.mas_right).offset(1);
            make.width.mas_equalTo(kMainScreenWidth/labelCount);
        }
        
        make.bottom.equalTo(self.backView);
    }];
    self.workQtyLabel.text = entity.workQty;
    
//
//
//    
//    date
    self.rightLabel = [UILabel new];
    [self.backView  addSubview:self.rightLabel];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView);
        make.left.equalTo(self.workQtyLabel.mas_right).offset(1);
        make.right.equalTo(self.backView);
        make.bottom.equalTo(self.backView);
    }];
    self.rightLabel.text = entity.rightName;
//
//    self.workAmtLabel = [UILabel new];
//    [self.backView  addSubview:self.workAmtLabel];
//    [self.workAmtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.projectTypeNameLabel.mas_bottom).offset(5);
//        make.height.mas_equalTo(20);
//        make.left.equalTo(self.backView).offset(10);
//    }];
//    
//    self.workAmtLabel.text = @"workAtm:1";
//    
//    self.selQtyLabel = [UILabel new];
//    [self.backView  addSubview:self.selQtyLabel];
//    [self.selQtyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.workAmtLabel);
//        make.height.mas_equalTo(20);
//        make.right.equalTo(self.backView.mas_right).offset(-10);
//    }];
//    
//    self.selQtyLabel.text = @"selQty:1";
    
    
//    self.projectNameLabel.textColor = gray104;
//    self.projectTypeNameLabel.textColor = [UIColor blackColor];
//    self.workAmtLabel.textColor = gray104;
//    self.workQtyLabel.textColor = gray104;
//    self.dateLabel.textColor = gray104;
//    self.selQtyLabel.textColor = gray104;
    
    
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    self.middleLabel.textAlignment = NSTextAlignmentCenter;
    self.workQtyLabel.textAlignment = NSTextAlignmentCenter;
    
    self.leftLabel.backgroundColor = WhiteColor;
    self.middleLabel.backgroundColor = WhiteColor;
    self.rightLabel.backgroundColor = WhiteColor;
    self.workQtyLabel.backgroundColor = WhiteColor;
    
    self.leftLabel.textColor = gray104;
    self.middleLabel.textColor = gray104;
    self.rightLabel.textColor = gray104;
    self.workQtyLabel.textColor = gray104;
    
    self.leftLabel.font = FONT14;
    self.middleLabel.font = FONT14;
    self.rightLabel.font = FONT14;
    self.workQtyLabel.font = FONT14;
    
    if (entity.isTop) {
        
        self.leftLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        self.middleLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        self.rightLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        self.workQtyLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        
        self.leftLabel.textColor = WhiteColor;
        self.middleLabel.textColor = WhiteColor;
        self.rightLabel.textColor = WhiteColor;
        self.workQtyLabel.textColor = WhiteColor;
    }
    
}



@end
