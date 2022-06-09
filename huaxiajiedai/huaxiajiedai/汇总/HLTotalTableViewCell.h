//
//  HLTotalTableViewCell.h
//  huaxiajishi
//
//  Created by gjhgj on 2017/9/23.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLTotalTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *HLLeftImageView;

@property (nonatomic, strong) UIImageView *HLRightImageView;

@property (nonatomic, strong) UILabel *totalLabel;

- (void) setCellWithDic:(NSDictionary *)dic;

@end
