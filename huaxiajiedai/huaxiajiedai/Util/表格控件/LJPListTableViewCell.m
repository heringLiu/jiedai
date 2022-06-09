//
//  LJPListTableViewCell.m
//  huaxiajiedai
//
//  Created by qm on 16/5/9.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJPListTableViewCell.h"

@implementation LJPListTableViewCell
@synthesize bottomLabel1, bottomLabel2, bottomLabel3, bottomView, customerCDLabel, roomCdLabel, roomLabel, serverStatusLabel, leftImageView, backView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (void) setDataWithT:(LJPListTModel *) entity {
//    技师
    [self createUI];
    bottomView.backgroundColor = [UIColor colorWithRed:151/255.0f green:185/255.0f blue:228/255.0f alpha:1];
    serverStatusLabel.hidden = NO;

    customerCDLabel.text = [NSString stringWithFormat:@"技师编号:%@", entity.artificer1Cd.length ? entity.artificer1Cd : entity.artificer2Cd];
    roomCdLabel.text = entity.roomCd;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"HH:mm";
    NSDate *time = [NSDate dateWithTimeIntervalSinceNow:[entity.distanceTime longLongValue]];
    bottomLabel1.text = [NSString stringWithFormat:@"下钟时间:%@", [df stringFromDate:time]];
    
    bottomLabel2.text = [NSString stringWithFormat:@"距下钟时间:%lld", [entity.distanceTime longLongValue]/60 ];
    bottomLabel3.text = [NSString stringWithFormat:@"等待服务:%@", entity.waitNum];
    serverStatusLabel.text = @"上钟";
    
}

- (void) setDataWithC:(LJReceptionDetailModel *) entity {
// 等待客户
    
    [self createUI];
    bottomView.backgroundColor = [UIColor colorWithRed:114/255.0f green:206/255.0f blue:183/255.0f alpha:1];
    serverStatusLabel.hidden = YES;
    
    customerCDLabel.text = [NSString stringWithFormat:@"客户编号:%@", entity.customerCd];
    roomCdLabel.text = entity.roomCd;
    NSString *teCd = @"技师编号:";
    if (entity.artificer1Cd.length) {
        teCd = [NSString stringWithFormat:@"%@%@", teCd, entity.artificer1Cd];
    }
    if (entity.artificer2Cd.length) {
        teCd = [NSString stringWithFormat:@"%@、%@", teCd, entity.artificer2Cd];
    }
    bottomLabel1.text = teCd;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *time = [df dateFromString:entity.starTime];
    df.dateFormat = @"HH:mm:ss";
    
    bottomLabel2.text = [NSString stringWithFormat:@"点钟时间:%@", [df stringFromDate:time]];
    NSString *str = @"";
    if (entity.artificer1Cd.length) {
        if ([entity.artificer1SelectType isEqualToString:@"wheelTime"]) {
            str = @"轮钟";
        } else if ([entity.artificer1SelectType isEqualToString:@"callTime"]) {
            str = @"点钟";
        }
    } else if (entity.artificer2Cd.length) {
        if ([entity.artificer2SelectType isEqualToString:@"wheelTime"]) {
            str = [NSString stringWithFormat:@"%@、轮钟", str];
        } else if ([entity.artificer2SelectType isEqualToString:@"callTime"]) {
            str = [NSString stringWithFormat:@"%@、点钟", str];
        }
    }
    bottomLabel3.text = [NSString stringWithFormat:@"选择方式:%@", str];
    serverStatusLabel.text = @"";
}


- (void) createUI {
    self.backgroundColor = gray238;
    if (!backView) {
        backView = [[UIView alloc] init];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.bottom.equalTo(self).offset(-10);
        }];
        backView.backgroundColor = WhiteColor;
        backView.layer.cornerRadius = 8;
        backView.layer.masksToBounds = YES;
    }
    if (!leftImageView) {
        leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xf_icon_blue"]];
        [backView addSubview:leftImageView];
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(20);
            make.top.equalTo(backView).offset(20);
            make.size.mas_equalTo(CGSizeMake(9.33, 11.66));
        }];
    }
    
    if (!roomCdLabel) {
        roomCdLabel = [UILabel new];
        [backView addSubview:roomCdLabel];
        [roomCdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView.mas_right).offset(-10);
            make.top.equalTo(backView).offset(20);
            make.height.mas_equalTo(FONT20.lineHeight);
        }];
        roomCdLabel.font = FONT20;
        roomCdLabel.textAlignment = NSTextAlignmentRight;
    }
    if (!roomLabel) {
        roomLabel = [UILabel new];
        [backView addSubview:roomLabel];
        [roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView.mas_right).offset(-10);
            make.top.equalTo(roomCdLabel.mas_bottom).offset(2);
            make.height.mas_equalTo(FONT10.lineHeight);
        }];
        roomLabel.font = FONT10;
        roomLabel.text = @"服务房间";
    }
    
    if (!customerCDLabel) {
        customerCDLabel = [UILabel new];
        [backView addSubview:customerCDLabel];
        [customerCDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImageView.mas_right).offset(4);
            make.centerY.equalTo(leftImageView.mas_centerY);
            make.right.equalTo(roomCdLabel.mas_left);
        }];
        customerCDLabel.font = FONT15;
        customerCDLabel.numberOfLines = 2;
    }
    
    if (!bottomView) {
        bottomView = [UIView new];
        [backView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(roomLabel.mas_bottom).offset(10);
            make.left.equalTo(backView);
            make.right.equalTo(backView);
            make.bottom.equalTo(backView);
        }];
        bottomView.backgroundColor = [UIColor colorWithRed:151/255.0f green:185/255.0f blue:228/255.0f alpha:1];
    }
    if (!bottomLabel1) {
        bottomLabel1 = [UILabel new];
        [backView addSubview:bottomLabel1];
        [bottomLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImageView.mas_left);
            make.top.equalTo(bottomView).offset(10);
            make.height.mas_equalTo(FONT14.lineHeight);
        }];
        bottomLabel1.font = FONT14;
        bottomLabel1.textColor = WhiteColor;
    }
    
    if (!bottomLabel2) {
        bottomLabel2 = [UILabel new];
        [backView addSubview:bottomLabel2];
        [bottomLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            if (kappScreenWidth == 0) {
                make.left.equalTo(bottomLabel1);
                make.top.equalTo(bottomLabel1.mas_bottom).offset(10);
            } else {
                make.right.equalTo(backView).offset(-10);
                make.top.equalTo(bottomView).offset(10);
            }
            
            make.height.mas_equalTo(FONT14.lineHeight);
        }];
        bottomLabel2.font = FONT14;
        bottomLabel2.textColor = WhiteColor;
    }
    
    if (!bottomLabel3) {
        bottomLabel3 = [UILabel new];
        [backView addSubview:bottomLabel3];
        [bottomLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImageView.mas_left);
            make.top.equalTo(bottomLabel2.mas_bottom).offset(10);
            make.height.mas_equalTo(FONT14.lineHeight);
        }];
        bottomLabel3.font = FONT14;
        bottomLabel3.textColor = WhiteColor;
    }
    if (!serverStatusLabel) {
        serverStatusLabel = [UILabel new];
        [backView addSubview:serverStatusLabel];
        [serverStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(customerCDLabel.mas_left);
            make.top.equalTo(customerCDLabel.mas_bottom).offset(3);
            make.bottom.equalTo(bottomView.mas_top).offset(-7);
            make.width.mas_equalTo(FONT15.pointSize*4);
        }];
        serverStatusLabel.font = FONT12;
        serverStatusLabel.textAlignment = NSTextAlignmentCenter;
        serverStatusLabel.textColor = WhiteColor;
        serverStatusLabel.layer.cornerRadius = 5;
        serverStatusLabel.layer.masksToBounds = YES;
        serverStatusLabel.backgroundColor = [UIColor colorWithRed:151/255.0f green:185/255.0f blue:228/255.0f alpha:1];
    }
    
}


@end
