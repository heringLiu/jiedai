//
//  LJRoomListCollectionViewCell.h
//  huaxiajiedai
//
//  Created by qm on 16/4/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJRoomModel.h"


@interface LJRoomListCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UILabel *maleCountLabel;
@property (nonatomic, strong) UILabel *femaleCountLabel;
@property (nonatomic, strong) UILabel *sofaCountLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *fullLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong)UIView *backView;



@property (nonatomic, strong) UIImageView *statesImageView;


- (void) setCellWitdData:(LJRoomModel *)entity;

@end
