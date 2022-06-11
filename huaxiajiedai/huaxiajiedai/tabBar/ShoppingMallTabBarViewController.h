//
//  ShoppingMallViewController.h
//  LianjunApp
//
//  Created by qm on 15/4/23.
//  Copyright (c) 2015年 qm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarView.h"
#import "LJRoomStateViewController.h"
#import "LJWaitingAreaViewController.h"
#import "LJTechnicianViewController.h"
#import "LJCollectViewController.h"
#import "HLTotalViewController.h"
#import "HLShouPaiViewController.h"

@interface ShoppingMallTabBarViewController : UITabBarController <UIActionSheetDelegate>
@property (nonatomic,strong)CustomTabBarView *bottomTabBarView;
@property (nonatomic,strong)UIButton *homeButton;
- (void)hideTabBar:(BOOL)boo;
@end
