//
//  LJTECTopMenu.h
//  huaxiajiedai
//
//  Created by qm on 16/5/27.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TecTopScrollViewMenuDelegate <NSObject>

- (void) selectedMenu:(NSInteger)page;

@end

@interface LJTECTopMenu : UIView

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, assign) id<TecTopScrollViewMenuDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *datas;

// 底部绿色条形
@property (nonatomic, strong) UIView *bottomView;
// 选中的索引
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIColor *TinColor;

- (void) setMenuListWithData:(NSMutableArray *)array;

@end
