//
//  LJSofaCollectionViewCell.h
//  huaxia
//
//  Created by qm on 16/4/11.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SofaModel.h"

@interface LJSofaCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UILabel *cornerLabel;


- (void) setCellWithData:(SofaModel *)entity;

@end
