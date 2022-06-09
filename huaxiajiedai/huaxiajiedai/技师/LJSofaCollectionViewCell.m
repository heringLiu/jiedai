//
//  LJSofaCollectionViewCell.m
//  huaxia
//
//  Created by qm on 16/4/11.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJSofaCollectionViewCell.h"

@implementation LJSofaCollectionViewCell
@synthesize bgButton, cornerLabel;


- (void) setCellWithData:(SofaModel *)entity {
    bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.userInteractionEnabled = NO;
    [self addSubview:bgButton];
    [bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.bottom.equalTo(self);
        make.top.equalTo(self).offset(11);
        make.right.equalTo(self).offset(-8);
    }];
    bgButton.titleLabel.numberOfLines = 0;
    bgButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    bgButton.titleLabel.font = FONT15;
    [bgButton setTitle:entity.sofaNo forState:UIControlStateNormal];
    
    if (entity.isChoosed) {
        [bgButton setBackgroundColor:[UIColor brownColor]];
        [bgButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    } else {
        [bgButton setBackgroundColor:gray238];
        [bgButton setTitleColor:gray146 forState:UIControlStateNormal];
    }

    
    bgButton.layer.cornerRadius = 8;
    
    if ([entity.availableFlg isEqualToString:@"disabled"]) {
        cornerLabel = [UILabel new];
        [bgButton addSubview:cornerLabel];
        [cornerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgButton.mas_right).offset(-4);
            make.centerY.equalTo(bgButton.mas_top).offset(4);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        cornerLabel.text = @"占";
        cornerLabel.font  = FONT12;
        cornerLabel.textAlignment = NSTextAlignmentCenter;
        cornerLabel.textColor = WhiteColor;
        cornerLabel.backgroundColor = [UIColor greenColor];
        cornerLabel.layer.masksToBounds = YES;
        cornerLabel.layer.cornerRadius = 11;
    }
    
    
}
@end
