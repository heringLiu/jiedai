//
//  LJRoomListCollectionViewCell.m
//  huaxiajiedai
//
//  Created by qm on 16/4/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJRoomListCollectionViewCell.h"

@implementation LJRoomListCollectionViewCell {
    UILabel *markLabel;
    UILabel *roomCdLabel;
}
@synthesize roomNameLabel, femaleCountLabel, maleCountLabel, sofaCountLabel, lineView, statesImageView, fullLabel, backView;

- (void)setCellWitdData:(LJRoomModel *)entity {
    

    CGFloat smallFont = 10.0f;
    CGFloat bigFont = 11.0f;
    
    smallFont = 14 * kappScreenWidth / 320.0f;
    bigFont = 15  * kappScreenWidth / 320.0f;
    
    if (!backView) {
        backView = [UIView new];
        [self addSubview:backView];
    }
    
    backView.backgroundColor = entity.isChoosed ? NavBackColor : gray238;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(2);
        make.right.equalTo(self).offset(-2);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
    }];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 8;
    
    if (!roomNameLabel) {
        roomNameLabel = [UILabel new];
        [backView addSubview:roomNameLabel];
    }
    
    [roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(10);
        make.top.equalTo(backView).offset(10);
        make.height.mas_equalTo(FONTBOLD(bigFont).lineHeight);
    }];
    roomNameLabel.text = entity.roomName;
    roomNameLabel.font = FONTBOLD(bigFont);
    
    // 标签长度  需要根据字数确定
//    free:空闲 appoint:预约 appointLock：预约锁定 full：占用 downLockAll：全部落种 stayEmpty：待清台
    
    NSString *markString = @"空闲";
    NSString *imageString = @"bg_bq_kongxian";
    
    if ([entity.roomState isEqualToString:@"appoint"]) {
        markString = @"预约";
        imageString = @"bg_bq_yuyue";
    } else if ([entity.roomState isEqualToString:@"appointLock"]) {
        markString = @"预约锁定";
        imageString = @"bg_bq_yuyuesuoding";
    } else if ([entity.roomState isEqualToString:@"full"]) {
        markString = @"占用";
        imageString = @"bg_bq_zhanyong";
    } else if ([entity.roomState isEqualToString:@"downLockAll"]) {
        markString = @"全部落钟";
        imageString = @"bg_bq_luozhong";
    } else if ([entity.roomState isEqualToString:@"stayEmpty"]) {
        markString = @"待清台";
        imageString = @"bg_bq_daiqingtai";
    }
    UIImage *image = [UIImage imageNamed:imageString];
    
//    CGFloat markLength = markString.length * 10 + 10;
    if (statesImageView == nil) {
        statesImageView = [[UIImageView alloc] init];
        
        [backView addSubview:statesImageView];
    }
    statesImageView.contentMode = UIViewContentModeScaleAspectFill;
    statesImageView.image = image;
    
    if (markLabel == nil) {
        markLabel = [[UILabel alloc] init];
        [statesImageView addSubview:markLabel];
    }
    
    markLabel.text = markString;
    markLabel.font = FONT(smallFont);
    markLabel.textColor = WhiteColor;
    markLabel.textAlignment = NSTextAlignmentRight;
    
    [markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-10);
        make.bottom.equalTo(backView.mas_bottom).offset(-8);
        make.height.mas_equalTo(FONT(smallFont).lineHeight);
    }];
    
    [statesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-0);
        make.bottom.equalTo(backView.mas_bottom).offset(-8);
        make.height.mas_equalTo(FONT(smallFont).lineHeight);
        make.left.equalTo(markLabel.mas_left).offset(-15);
    }];
    
    if (roomCdLabel == nil) {
        roomCdLabel = [UILabel new];
        [backView addSubview:roomCdLabel];
    }
    [roomCdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-10);
        make.centerY.equalTo(roomNameLabel.mas_centerY);
        make.height.mas_equalTo(FONT(bigFont).lineHeight);
    }];
    roomCdLabel.font = FONT(bigFont);
    roomCdLabel.textAlignment = NSTextAlignmentRight;
    roomCdLabel.text = entity.roomCd;
    
    
    if (lineView == nil) {
        lineView = [UIView new];
        [backView addSubview:lineView];
    }
    lineView.backgroundColor = [entity.roomState isEqualToString:@"full"] ? WhiteColor : gray191;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(5);
        make.right.equalTo(backView).offset(-5);
        make.top.equalTo(roomNameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(1);
    }];
    
    
    if (!maleCountLabel) {
        maleCountLabel = [UILabel new];
        [backView addSubview:maleCountLabel];
    }
    [maleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(10);
        make.top.equalTo(lineView.mas_bottom).offset(5);
        make.height.mas_equalTo(FONT(smallFont).lineHeight);
    }];
    maleCountLabel.text =  [NSString stringWithFormat:@"男客:%@", entity.manNum];
    maleCountLabel.font = FONT(smallFont);
    
    
    if (femaleCountLabel == nil) {
        femaleCountLabel = [UILabel new];
        [backView addSubview:femaleCountLabel];
    }
    [femaleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-10);
        make.top.equalTo(lineView.mas_bottom).offset(5);
        make.height.mas_equalTo(FONT(smallFont).lineHeight);
    }];
    femaleCountLabel.text =[NSString stringWithFormat:@"女客:%@", entity.womanNum];
    femaleCountLabel.textAlignment = NSTextAlignmentRight;
    femaleCountLabel.font = FONT(smallFont);
    
    
    if (!sofaCountLabel) {
        sofaCountLabel = [UILabel new];
        [backView addSubview:sofaCountLabel];
    }
    [sofaCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(10);
        make.top.equalTo(maleCountLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(FONT(smallFont).lineHeight);
    }];
    sofaCountLabel.text = [NSString stringWithFormat:@"沙发:%@/%@", entity.sofaFreeQty, entity.sofaQty];
    sofaCountLabel.font = FONT(smallFont);
    
    
    if (self.timeLabel == nil) {
        self.timeLabel = [[UILabel alloc] init];
        [self addSubview:self.timeLabel];
    }
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(10);
        make.top.equalTo(sofaCountLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(FONT(smallFont).lineHeight);
    }];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = FONT(smallFont);
    if (!entity.consumeEndTime.length && !entity.reserveTime.length) {
        self.timeLabel.text = @"";
    } else if (entity.consumeEndTime.length) {
        if ([entity.roomState isEqualToString:@"full"]) {
            self.timeLabel.text = [NSString stringWithFormat:@"剩余%@分", entity.consumeEndTime];
        } else {
            self.timeLabel.text = @"";
        }
        
    } else {
        self.timeLabel.text = [entity.reserveTime substringWithRange:NSMakeRange(5, 11)];
    }
    
    if ([entity.manNum integerValue] + [entity.womanNum integerValue] == [entity.sofaQty integerValue]) {
        backView.backgroundColor = [UIColor colorWithRed:253/255.0f green:159/255.0f blue:142/255.0f alpha:1];
        roomNameLabel.textColor = WhiteColor;
        roomCdLabel.textColor = WhiteColor;
        maleCountLabel.textColor = WhiteColor;
        femaleCountLabel.textColor = WhiteColor;
        sofaCountLabel.textColor = WhiteColor;
    } else {
        roomNameLabel.textColor = [UIColor blackColor];
        roomCdLabel.textColor = [UIColor blackColor];
        maleCountLabel.textColor = [UIColor blackColor];
        femaleCountLabel.textColor = [UIColor blackColor];
        sofaCountLabel.textColor = [UIColor blackColor];
    }
    
}

@end
