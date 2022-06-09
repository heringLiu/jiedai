//
//  LJReceptionListTableViewCell.h
//  huaxiajiedai
//
//  Created by qm on 16/4/18.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJReceptionListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *clientNumberLabel;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UIButton *sexBtn;

@property (nonatomic, strong) UIButton *sofaBtn;

//@property (nonatomic, strong) UIButton *itemNumberBtn;

@property (nonatomic, strong) UIButton *itemNameBtn;

@property (nonatomic, strong) UIButton *technicianBtn;

@property (nonatomic, strong) UIButton *roomBtn;

@property (nonatomic, strong) UIButton *countBtn;

@property (nonatomic, strong) UIButton *moneyBtn;

@property (nonatomic, strong) UIButton *itemStateBtn;

@property (nonatomic, strong) UIButton *jiesuanBtn;

@property (nonatomic, strong) UIButton *salesmanBtn;


-(void) setCellWithData:(NSDictionary *) data;


@end
