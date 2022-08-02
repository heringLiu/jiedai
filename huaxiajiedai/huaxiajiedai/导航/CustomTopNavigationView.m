//
//  CustomTopView.m
//  LianjunApp
//
//  Created by qm on 15/4/29.
//  Copyright (c) 2015年 qm. All rights reserved.
//

#import "CustomTopNavigationView.h"
@implementation CustomTopNavigationView
@synthesize leftButton,rightButton,titleLabel,delegate,titleButton, rightButton2, leftButton2;
- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:navLightBrownColor];
        UIView *safeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kSafeHeight)];
        [self addSubview:safeView];
        [safeView setBackgroundColor:[UIColor clearColor]];
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
        [leftButton setTag:100];
        [leftButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"left_white@3x.png"] forState:UIControlStateNormal];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(safeView.mas_bottom);
            make.bottom.equalTo(self);
            make.left.equalTo(self).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        self.leftButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton2.titleLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
        [leftButton2 setTag:103];
        [leftButton2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton2];
        [leftButton2 setBackgroundImage:[UIImage imageNamed:@"left_white@3x.png"] forState:UIControlStateNormal];
        [leftButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(safeView.mas_bottom);
            make.bottom.equalTo(self);
            make.left.mas_equalTo(self.leftButton.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        self.titleLabel = [UILabel new];
//        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(safeView.mas_bottom);
            make.bottom.equalTo(self);
            make.left.equalTo(self).with.offset(50);
            make.right.equalTo(self).with.offset(-50);
        }];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        
        self.titleButton = [UIButton new];
        [self.titleButton setTitleColor:WhiteColor forState:UIControlStateNormal];
        [self addSubview:titleButton];
        
        [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(safeView.mas_bottom);
            make.bottom.equalTo(self);
            make.left.equalTo(self).with.offset(60);
            make.right.equalTo(self).with.offset(-60);
        }];
        [titleButton setHidden:YES];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.tag = 101;
        [rightButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
        [rightButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(safeView.mas_bottom);
            make.bottom.equalTo(self);
            make.right.equalTo(self).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(60, 44));
        }];
        
        self.rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton2.tag = 102;
        [rightButton2.titleLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
        rightButton2.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        rightButton2.contentMode = UIViewContentModeScaleAspectFill;
        [rightButton2.titleLabel setTextAlignment:NSTextAlignmentRight];
        [rightButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton2];
        [rightButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(safeView.mas_bottom);
            make.bottom.equalTo(self);
            make.right.equalTo(self.rightButton.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
//        rightButton2.backgroundColor = kredColor;
        [self.rightButton2 setHidden:YES];
    }
    
    return self;
    
}

- (void)buttonPressed:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag==100) {
        if ([delegate respondsToSelector:@selector(leftButtonPressed)]) {
            [delegate leftButtonPressed];
        }
        
    }else if (btn.tag == 101){
        if ([delegate respondsToSelector:@selector(rightButtonPressed)]) {
            [delegate rightButtonPressed];
        }
    } else if (btn.tag == 102){
        if ([delegate respondsToSelector:@selector(rightButton2Pressed)]) {
            [delegate rightButton2Pressed];
        }
    }else if (btn.tag == 103){
        if ([delegate respondsToSelector:@selector(leftButton2Pressed)]) {
            [delegate leftButton2Pressed];
        }
    }
    
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
 
    if ([backgroundColor isEqual:LightBrownColor]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    } else if ([backgroundColor isEqual:[UIColor magentaColor]]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
