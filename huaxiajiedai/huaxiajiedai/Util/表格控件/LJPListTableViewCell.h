//
//  LJPListTableViewCell.h
//  huaxiajiedai
//
//  Created by qm on 16/5/9.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJPListTModel.h"
#import "LJReceptionDetailModel.h"

@interface LJPListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UILabel *customerCDLabel;

@property (nonatomic, strong) UILabel *roomCdLabel;

@property (nonatomic, strong) UILabel *roomLabel;

@property (nonatomic, strong) UILabel *serverStatusLabel;

@property (nonatomic, strong) UILabel *bottomLabel1;

@property (nonatomic, strong) UILabel *bottomLabel2;

@property (nonatomic, strong) UILabel *bottomLabel3;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *backView;


- (void) setDataWithT:(LJPListTModel *) entity;

- (void) setDataWithC:(LJReceptionDetailModel *) entity;

@end
