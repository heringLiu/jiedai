//
//  LJJishiVIew.m
//  huaxiajiedai
//
//  Created by 刘慧林 on 2023/2/27.
//  Copyright © 2023 LJ. All rights reserved.
//

#import "LJJishiVIew.h"

@implementation LJJishiVIew

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setCount:(NSArray *)artificerList {
    float width = kappScreenWidth/3;
    for (int i = 0; i < artificerList.count; i++) {
        NSString *artificerName = [[artificerList objectAtIndex:i] objectForKey:@"artificerName"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 2000 + i;
        btn.frame = CGRectMake(i%3  * width, 0 + i / 3 * 50 , kappScreenWidth/3 - 10, 50);
        [self addSubview:btn];
        [btn setBackgroundColor:[UIColor redColor]];
        [btn setTitle:artificerName forState:UIControlStateNormal];
        if (i == artificerList.count -1 ) {
            [btn setBackgroundColor:[UIColor greenColor]];
        }
    }
    
};


@end
