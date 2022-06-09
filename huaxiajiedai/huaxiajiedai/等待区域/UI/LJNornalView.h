//
//  LJNornalView.h
//  huaxiajiedai
//
//  Created by qm on 16/4/15.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapViewDelegate <NSObject>

- (void) tapView:(UIView *)tapView;

@end

@interface LJNornalView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, assign) id<TapViewDelegate> delegaete;

//- (instancetype)initWithFrame:(CGRect)frame TitleName:(NSString *) titleString;
- (instancetype)initWithTitleName:(NSString *) titleString;
@end
