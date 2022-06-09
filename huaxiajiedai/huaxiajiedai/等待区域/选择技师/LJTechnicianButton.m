//
//  LJTechnicianButton.m
//  huaxiajiedai
//
//  Created by qm on 16/5/10.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJTechnicianButton.h"

@implementation LJTechnicianButton
@synthesize closeBtn;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    [self setTitle:titleName forState:UIControlStateNormal];
    [self setTitle:titleName forState:UIControlStateSelected];
}


- (void) showButton {
    if (!closeBtn) {
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.superview addSubview:closeBtn];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(10);
            make.top.equalTo(self.mas_top).offset(-10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [closeBtn setImage:[UIImage imageNamed:@"close_512px_1175741_easyicon.net"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    closeBtn.hidden = NO;
    CAKeyframeAnimation *frame=[CAKeyframeAnimation animation];
    
    CGFloat left=-M_PI_2*0.05;
    CGFloat right=M_PI_2*0.05;
    
    
    frame.keyPath=@"postion";
    frame.keyPath=@"transform.rotation";
    
    frame.values=@[@(left),@(right),@(left)];
    frame.duration=0.3;
    frame.repeatCount=80;
    
    [self.layer addAnimation:frame forKey:nil];
    [self.layer removeAnimationForKey:@"transform.rotation"];
}

- (void)closeButton {
    [self.layer removeAllAnimations];
    
    closeBtn.hidden = YES;
//    [closeBtn removeFromSuperview];
}

- (void) closeButtonClick {
    
    self.technician = nil;
    self.titleName = @"空";
    
    [self closeButton];
    
    if ([self.delegate respondsToSelector:@selector(sendTButton:)]) {
        [self.delegate sendTButton:self];
    }
}

@end
