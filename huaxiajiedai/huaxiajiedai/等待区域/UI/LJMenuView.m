//
//  LJMenuView.m
//  huaxiajiedai
//
//  Created by qm on 16/4/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJMenuView.h"


@implementation LJMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame isConsumption:(BOOL)isConsumption isHandCd:(BOOL)isHandCd{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:10/254.0f green:10/254.0f blue:10/254.0f alpha:0.7];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, ((kappScreenWidth - 80)/3 * 0.6 + 10) * 4 + 60)];
        [self addSubview:backView];
//        backView.backgroundColor = gray238;
        backView.backgroundColor = [UIColor clearColor];
        
        NSArray *array = @[];
        if (isConsumption) {
            if (isHandCd) {
                array = @[@"增加客户", @"删除客户", @"更改房间", @"增加明细", @"删除明细", @"取消点钟", @"打印", @"增加项目"];
            } else {
                array = @[@"增加客户", @"删除客户", @"更改房间", @"增加明细", @"删除明细", @"取消点钟", @"打印", @"并入手牌"];
            }
            
        } else {
            array = @[@"增加客户", @"删除客户", @"", @"增加明细", @"删除明细", @"", @""];
        }
        int k = 0;
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(20 + j * ((kappScreenWidth - 80)/3 + 10), 30 + i * ((kappScreenWidth - 80)/3 * 0.6 + 10), (kappScreenWidth - 80)/3, (kappScreenWidth - 80)/3 * 0.6);
//                LJMenuButton *button = [[LJMenuButton alloc] initWithFrame:];
                [self addSubview:button];
                
                button.tag = k + 1000;
                
                button.titleLabel.font = FONT15;
                [button setTitleColor:gray104 forState:UIControlStateNormal];
                [button setTitleColor:WhiteColor forState:UIControlStateSelected];
                [button setBackgroundColor:gray238];
                button.layer.cornerRadius = 6;
                button.layer.masksToBounds = YES;
                [button setBackgroundImage:[self imageWithColor:gray238] forState:UIControlStateNormal];
                [button setBackgroundImage:[self imageWithColor:NavBackColor] forState:UIControlStateHighlighted];
                [button setTitleColor:WhiteColor forState:UIControlStateHighlighted];
                if (array.count > k) {
                    [button setTitle:[array objectAtIndex:k] forState:UIControlStateNormal];
                    if ([[array objectAtIndex:k] length] == 0) {
                        button.hidden = YES;
                    }
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                } else {
                    button.hidden = YES;
                }
                
                
                k ++;
            }
            
        }
    }
    
    return self;
}

- (void) buttonClick:(UIButton *) sender {
    if ([self.delegate respondsToSelector:@selector(sendSelectedTag:)]) {
        [self.delegate sendSelectedTag:sender.tag];
    }
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
