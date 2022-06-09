//
//  TopScrollViewMenuView.h
//  LianjunApp
//
//  Created by qm on 15/12/2.
//  Copyright © 2015年 qm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol topScrollViewMenuDelegate <NSObject>

- (void) selectedMenu:(NSInteger)page;

@end

@interface TopScrollViewMenuView : UIView

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, assign) id<topScrollViewMenuDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *datas;

// 底部绿色条形
@property (nonatomic, strong) UIView *bottomView;
// 选中的索引
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIColor *TinColor;

- (void) setMenuListWithData:(NSMutableArray *)array;

@end
