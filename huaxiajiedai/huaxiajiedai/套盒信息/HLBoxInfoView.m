//
//  HLBoxInfoView.m
//  huaxiajishi
//
//  Created by gjhgj on 2017/11/1.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "HLBoxInfoView.h"

@implementation HLBoxInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = WhiteColor;
        self.nameLabel = [[UILabel alloc] init];
        [self addSubview:self.nameLabel];
        
        self.nameLabel.frame = CGRectMake(20, 15, 80, 20);
        self.valueLabel = [[UILabel alloc] init];
        [self addSubview:self.valueLabel];
        self.valueLabel.frame = CGRectMake(100, 15, 200, 20);
        
        self.nameLabel.font = FONT14;
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = gray81;
        self.valueLabel.font = FONT14;
        self.valueLabel.textAlignment = NSTextAlignmentLeft;
        self.valueLabel.textColor = gray81;
    }
    
    return self;
}

@end
