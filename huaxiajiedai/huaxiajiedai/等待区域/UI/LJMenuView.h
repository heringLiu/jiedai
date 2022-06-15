//
//  LJMenuView.h
//  huaxiajiedai
//
//  Created by qm on 16/4/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJMenuButton.h"

@protocol MenuViewDelegate <NSObject>

- (void) sendSelectedTag:(NSInteger) buttonTag;

@end

@interface LJMenuView : UIView


@property (nonatomic, assign) id<MenuViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame isConsumption:(BOOL)isConsumption isHandCd:(BOOL) isHandCd;
@end
