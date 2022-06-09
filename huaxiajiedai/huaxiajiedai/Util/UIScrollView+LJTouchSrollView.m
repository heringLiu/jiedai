//
//  UIScrollView+LJTouchSrollView.m
//  huaxiajiedai
//
//  Created by qm on 16/4/14.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "UIScrollView+LJTouchSrollView.h"

@implementation UIScrollView (LJTouchSrollView)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}


@end
