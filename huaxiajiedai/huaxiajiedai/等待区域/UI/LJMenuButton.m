//
//  LJMenuButton.m
//  huaxiajiedai
//
//  Created by qm on 16/4/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJMenuButton.h"

@implementation LJMenuButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        self.layer.cornerRadius = 5;
        self.titleLabel.textColor = gray104;
        self.titleLabel.font = FONT15;
    }
    
    return self;
}

@end
