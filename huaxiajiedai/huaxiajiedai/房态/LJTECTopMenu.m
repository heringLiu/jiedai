//
//  LJTECTopMenu.m
//  huaxiajiedai
//
//  Created by qm on 16/5/27.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJTECTopMenu.h"

#define btnWidth kappScreenWidth/4

@implementation LJTECTopMenu
@synthesize datas, mainScrollView, bottomView;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)setMenuListWithData:(NSMutableArray *)array {
    self.selectedIndex = 0;
    datas = [NSMutableArray arrayWithArray:array];
    self.backgroundColor = WhiteColor;
    
    if (mainScrollView == nil) {
        mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:mainScrollView];
        
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 5, btnWidth - 20, 5)];
        [self.mainScrollView addSubview:bottomView];
        bottomView.backgroundColor = LightBrownColor;
        
        for (int i = 0; i < datas.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [mainScrollView addSubview:btn];
            
            btn.frame = CGRectMake(btnWidth * i, 0, btnWidth, self.frame.size.height);
            
            [btn setTitle:[datas objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = FONT17;
            if (i == 0) {
                [btn setTitleColor:gray90 forState:UIControlStateNormal];
            } else if (i == 1) {
                [btn setTitleColor:[UIColor colorWithRed:249/255.0f green:167/255.0f blue:167/255.0f alpha:1] forState:UIControlStateNormal];
            } else if (i == 2) {
                [btn setTitleColor:[UIColor colorWithRed:153/255.0f green:228/255.0f blue:153/255.0f alpha:1] forState:UIControlStateNormal];
            } else if (i == 3) {
                [btn setTitleColor:[UIColor colorWithRed:242/255.0f green:219/255.0f blue:157/255.0f alpha:1] forState:UIControlStateNormal];
            }
            
            if (i == 0) {
                [btn setTitleColor:gray80 forState:UIControlStateSelected];
            } else if (i == 1) {
                [btn setTitleColor:[UIColor colorWithRed:249/255.0f green:167/255.0f blue:167/255.0f alpha:1] forState:UIControlStateSelected];
            } else if (i == 2) {
                [btn setTitleColor:[UIColor colorWithRed:153/255.0f green:228/255.0f blue:153/255.0f alpha:1] forState:UIControlStateSelected];
            } else if (i == 3) {
                [btn setTitleColor:[UIColor colorWithRed:242/255.0f green:219/255.0f blue:157/255.0f alpha:1] forState:UIControlStateSelected];
            }
            
            [btn setSelected:!i];
            btn.tag = 1000 + i;
            [btn addTarget:self action:@selector(changeCategory:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        mainScrollView.contentSize = CGSizeMake(btnWidth * datas.count, self.frame.size.height);
        mainScrollView.bounces = NO;
        mainScrollView.showsHorizontalScrollIndicator = NO;
        mainScrollView.showsVerticalScrollIndicator = NO;
        
        UIView *lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        lineView.backgroundColor = gray238;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.bottom.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(1);
        }];
        
    } else {
        
        for (UIView *sub in mainScrollView.subviews) {
            if ([sub isKindOfClass:[UIButton class]]) {
                [sub removeFromSuperview];
            }
        }
        
        for (int i = 0; i < datas.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [mainScrollView addSubview:btn];
            
            btn.frame = CGRectMake(btnWidth * i, 0, btnWidth, self.frame.size.height);
            
            [btn setTitle:[datas objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = FONT17;
            [btn setTitleColor:gray104 forState:UIControlStateNormal];
            
            if (i == 0) {
                [btn setTitleColor:gray90 forState:UIControlStateSelected];
            } else if (i == 1) {
                [btn setTitleColor:[UIColor colorWithRed:249/255.0f green:167/255.0f blue:167/255.0f alpha:1] forState:UIControlStateSelected];
            } else if (i == 2) {
                [btn setTitleColor:[UIColor colorWithRed:153/255.0f green:228/255.0f blue:153/255.0f alpha:1] forState:UIControlStateSelected];
            } else if (i == 3) {
                [btn setTitleColor:[UIColor colorWithRed:242/255.0f green:219/255.0f blue:157/255.0f alpha:1] forState:UIControlStateSelected];
            }
            
            [btn setSelected:!i];
            btn.tag = 1000 + i;
            [btn addTarget:self action:@selector(changeCategory:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    
    
}

- (void) changeCategory:(UIButton *)sender {
    
    self.selectedIndex = sender.tag - 1000;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if ([self.delegate respondsToSelector:@selector(selectedMenu:)]) {
        [self.delegate selectedMenu:selectedIndex];
    }
    
    for (int i = 0; i < datas.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:1000 + i];
        [button setSelected:NO];
    }
    
    _selectedIndex = selectedIndex;
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = CGRectMake(selectedIndex * btnWidth + 10, self.frame.size.height - 5, btnWidth - 20, 5);
    }];
    UIButton *btn = (UIButton *)[self viewWithTag:1000 + selectedIndex];
    [btn setSelected:YES];
    if (btn.center.x > kappScreenWidth/2 && (btn.center.x + kappScreenWidth/2) < mainScrollView.contentSize.width) {
        [UIView animateWithDuration:0.3 animations:^{
            mainScrollView.contentOffset = CGPointMake(btn.center.x - kappScreenWidth/2, 0);
        }];
    } else {
        if (btn.center.x < mainScrollView.contentSize.width / 2) {
            [UIView animateWithDuration:0.3 animations:^{
                mainScrollView.contentOffset = CGPointMake(0, 0);
            }];
            
        } else if (datas.count * btnWidth > kappScreenWidth) {
            [UIView animateWithDuration:0.3 animations:^{
                mainScrollView.contentOffset = CGPointMake(mainScrollView.contentSize.width - kappScreenWidth, 0);
            }];
            
        }
    }
    
}

@end
