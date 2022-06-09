//
//  CustomTabBarView.h
//  LianjunApp
//
//  Created by qm on 15/4/23.
//  Copyright (c) 2015年 qm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTabBarDelegate <NSObject>

- (void)tabBarItemSelectedWithIndex:(int)index;

@end

@interface CustomTabBarView : UIView

@property (nonatomic,assign)id<CustomTabBarDelegate> delegate;

- (void) selectIndex:(NSInteger)index;

@end
