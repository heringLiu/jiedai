//
//  LJHLGridViewCollectionViewCell.h
//  huaxiajiedai
//
//  Created by qm on 16/4/18.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJHLGridViewCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *cornerImage;

@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, assign) BOOL isConsumption;

- (void) setCellWithTitle:(NSString *) title;

- (void) isShowButton:(BOOL) isShow;

- (void) setCornerMark;

@end
