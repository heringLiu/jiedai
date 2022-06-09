//
//  LJNornalView.m
//  huaxiajiedai
//
//  Created by qm on 16/4/15.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJNornalView.h"

@implementation LJNornalView
@synthesize bottomLine, titleLabel;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithTitleName:(NSString *)titleString {
    self.backgroundColor = WhiteColor;
    if (self = [super init]) {
        self.backgroundColor = WhiteColor;
        self.titleLabel = [UILabel new];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.bottom.equalTo(self);
            make.top.equalTo(self);
        }];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = FONT15;
        self.titleLabel.textColor = gray104;
        self.titleLabel.text = titleString;
        
        
        bottomLine = [UIView new];
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self);
        }];
        bottomLine.backgroundColor = gray238;
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
        [self addGestureRecognizer:tapGesture];
    }

    return self;
}

- (void) Actiondo:(UITapGestureRecognizer *)tap {
    if ([self.delegaete respondsToSelector:@selector(tapView:)]) {
        [self.delegaete tapView:tap.view];
    }
}

@end
