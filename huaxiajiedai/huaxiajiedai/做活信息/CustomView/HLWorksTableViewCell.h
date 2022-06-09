//
//  HLWorksTableViewCell.h
//  huaxiajishi
//
//  Created by gjhgj on 2017/9/17.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLWorksListModel.h"

@interface HLWorksTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *workQtyLabel;
@property (nonatomic, strong) UILabel *rightLabel;


//@property (nonatomic, strong) UILabel *projectTypeNameLabel;
//@property (nonatomic, strong) UILabel *projectNameLabel;
//@property (nonatomic, strong) UILabel *dateLabel;

//@property (nonatomic, strong) UILabel *workQtyLabel;
//@property (nonatomic, strong) UILabel *selQtyLabel;
//@property (nonatomic, strong) UILabel *workAmtLabel;

- (void) setCellWithData:(HLWorksListModel *)entity;

@end
