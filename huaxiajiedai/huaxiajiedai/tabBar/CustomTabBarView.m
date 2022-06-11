//
//  CustomTabBarView.m
//  LianjunApp
//
//  Created by qm on 15/4/23.
//  Copyright (c) 2015年 qm. All rights reserved.
//

#import "CustomTabBarView.h"
#import "CustomTabBarButton.h"

@implementation CustomTabBarView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    NSArray *array = [NSArray arrayWithObjects:@"房态",@"预约",@"技师",@"手牌",@"其他", nil];
//    NSArray *SelectImages = [NSArray arrayWithObjects:@"Store_tab_icon_Store_pre",@"Store_tab_icon_fenlei_pre",@"Store_tab_icon_pinlei_pre",@"Store_tab_icon_user_pre", nil];
//    NSArray *imagesArray = [NSArray arrayWithObjects:@"Store_tab_icon_Store",@"Store_tab_icon_fenlei",@"Store_tab_icon_pinlei",@"Store_tab_icon_user", nil];
    
    float width = (frame.size.width)/array.count;
    if (self) {
        for (int i = 0; i < [array count]; i++) {
            
            CustomTabBarButton *btn = [[CustomTabBarButton alloc] initWithFrame:CGRectMake(i * width, 0, width, frame.size.height)];
            if (i == 0) {
//                btn.myImageView.image = [UIImage imageNamed:[SelectImages objectAtIndex:i]];
                btn.nameLabel.textColor = LightBrownColor;
            } else {
//                btn.myImageView.image = [UIImage imageNamed:[imagesArray objectAtIndex:i]];
                btn.nameLabel.textColor = gray104;
            }
            [btn setTag:100+i];
            [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn.nameLabel setText:[array objectAtIndex:i]];
            [self addSubview:btn];
            
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        
        [line setBackgroundColor:[[UIColor alloc] initWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1.0]];
        
        [self addSubview:line];
        
    }
    
    return self;
}
- (void)buttonPressed:(id)sender{
    CustomTabBarButton *btn = (CustomTabBarButton *)sender;
    if (btn.tag == 103) {
        [[NetWorkingModel sharedInstance] POST:GETSYSTEMVALUEBYSETCD parameters:@{@"setCd":@"HAND_FLG"} success:^(AFHTTPRequestOperation *operation, id obj) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
            if (ISSUCCESS) {
                NSString *setValue = [CONTENTOBJ objectForKey:@"SetValue"];
                if (setValue == nil || setValue.length <= 0 || [setValue isEqual:@"0"]) {
                    SHOWTEXTINWINDOW(@"手牌功能未启用", 1.5);
                    return;;
                } else {
                    for (int i = 0; i < 4; i++) {
                        
                        CustomTabBarButton *button = (CustomTabBarButton *)[self viewWithTag:100+i];
                        if (button == btn) {
                            button.nameLabel.textColor = LightBrownColor;
                        } else {
                            button.nameLabel.textColor = gray104;
                        }

                    }
                    [delegate tabBarItemSelectedWithIndex:(int)btn.tag];
                }
            }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                SHOWTEXTINWINDOW(@"获取系统参数异常", 1.5);
                return;
            }];
    } else {
        if (index == 104) {
            [delegate tabBarItemSelectedWithIndex:(int)btn.tag];
            return;
        }
    //    NSArray *SelectImages = [NSArray arrayWithObjects:@"Store_tab_icon_Store_pre",@"Store_tab_icon_fenlei_pre",@"Store_tab_icon_pinlei_pre",@"Store_tab_icon_user_pre", nil];
    //    NSArray *imagesArray = [NSArray arrayWithObjects:@"Store_tab_icon_Store",@"Store_tab_icon_fenlei",@"Store_tab_icon_pinlei",@"Store_tab_icon_user", nil];
        
        for (int i = 0; i < 4; i++) {
            
            CustomTabBarButton *button = (CustomTabBarButton *)[self viewWithTag:100+i];
            if (button == btn) {
    //            button.myImageView.image = [UIImage imageNamed:[SelectImages objectAtIndex:i]];
                button.nameLabel.textColor = LightBrownColor;
            } else {
    //            button.myImageView.image = [UIImage imageNamed:[imagesArray objectAtIndex:i]];
                button.nameLabel.textColor = gray104;
            }

        }
        
        [delegate tabBarItemSelectedWithIndex:(int)btn.tag];
    }
    
   
}

- (void) selectIndex:(NSInteger)index {
    if (index == 103 || index == 104) {
        return;
    }
    CustomTabBarButton *btn = (CustomTabBarButton *)[self viewWithTag:index + 100];
    
    [self buttonPressed:btn];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
