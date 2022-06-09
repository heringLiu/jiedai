//
//  CustomTabBarButton.m
//  LianjunApp
//
//  Created by qm on 15/4/23.
//  Copyright (c) 2015年 qm. All rights reserved.
//

#import "CustomTabBarButton.h"
@implementation CustomTabBarButton

@synthesize myImageView,nameLabel;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
//        float height =  frame.size.height;

//        myImageView = [UIImageView new];
//        [myImageView setBackgroundColor:[UIColor clearColor]];
//        [self addSubview:myImageView];
//
//        [myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.equalTo(self);
//            make.width.mas_equalTo(height/2);
//            make.height.mas_equalTo(height/2);
//        }];
        
        nameLabel = [UILabel new];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
//        [titleLabel setTextColor:kgreenColor];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [self addSubview:nameLabel];
        nameLabel.backgroundColor = gray238;
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
    }
    
    return  self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
