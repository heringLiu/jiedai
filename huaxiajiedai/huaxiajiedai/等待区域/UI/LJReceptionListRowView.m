//
//  LJReceptionListRowView.m
//  huaxiajiedai
//
//  Created by qm on 16/4/18.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJReceptionListRowView.h"

@implementation LJReceptionListRowView
@synthesize nameLabel, numberLabel, dutyLabel, timeLbael, bottomLineView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    CGFloat numberOfFont = 14;
    if (kappScreenWidth == 320) {
        numberOfFont = 12;
    }
    
    if (self = [super init]) {
        self.backgroundColor = WhiteColor;
        nameLabel = [UILabel new];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.bottom.equalTo(self.mas_centerY).offset(-5);
            make.height.mas_equalTo(FONT(numberOfFont).lineHeight);
        }];
        nameLabel.text = @"";
        nameLabel.font = FONT(numberOfFont);
        nameLabel.textColor = gray146;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        
        
        dutyLabel = [UILabel new];
        [self addSubview:dutyLabel];
        [dutyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self.mas_centerY).offset(5);
            make.height.mas_equalTo(FONT(numberOfFont).lineHeight);
        }];
        dutyLabel.text = @"";
        dutyLabel.font = FONT(numberOfFont);
        dutyLabel.textColor = gray146;
        dutyLabel.textAlignment = NSTextAlignmentLeft;
        
        numberLabel = [UILabel new];
        [self addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (kappScreenWidth >= 320) {
                make.left.equalTo(self.mas_centerX).offset(-20);
            } else {
                make.left.equalTo(self.mas_centerX);
            }
            
            make.bottom.equalTo(self.mas_centerY).offset(-5);
            make.height.mas_equalTo(FONT(numberOfFont).lineHeight);
        }];
        numberLabel.text = @"";
        numberLabel.font = FONT(numberOfFont);
        numberLabel.textColor = gray146;
        numberLabel.textAlignment = NSTextAlignmentLeft;
        
        timeLbael = [UILabel new];
        [self addSubview:timeLbael];
        [timeLbael mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (kappScreenWidth >= 320) {
                make.left.equalTo(self.mas_centerX).offset(-20);
            } else {
                make.left.equalTo(self.mas_centerX);
            }
            make.top.equalTo(self.mas_centerY).offset(5);
            make.height.mas_equalTo(FONT(numberOfFont).lineHeight);
        }];
        timeLbael.text = @"1";
        timeLbael.font = FONT(numberOfFont);
        timeLbael.textColor = gray146;
        timeLbael.textAlignment = NSTextAlignmentLeft;
        
        bottomLineView = [UIView new];
        [self addSubview:bottomLineView];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self);
        }];
        bottomLineView.backgroundColor = gray238;

    }
    
    return self;
}

@end
