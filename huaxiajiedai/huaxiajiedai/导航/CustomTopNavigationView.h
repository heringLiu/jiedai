//
//  CustomTopView.h
//  LianjunApp
//
//  Created by qm on 15/4/29.
//  Copyright (c) 2015年 qm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTopNavigationViewDelegate <NSObject>

@optional
- (void)leftButtonPressed;
- (void)rightButtonPressed;
- (void)rightButton2Pressed;

@end

@interface CustomTopNavigationView : UIView

@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UIButton *rightButton;
@property (nonatomic, strong) UIButton *rightButton2;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *titleButton;
@property (nonatomic,assign)id<CustomTopNavigationViewDelegate> delegate;
@end
