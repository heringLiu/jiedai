//
//  LJConsumptionHeaderModel.h
//  huaxiajiedai
//
//  Created by qm on 16/4/29.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJRootModel.h"

@interface LJConsumptionHeaderModel : LJRootModel

// 接待员
@property (nonatomic, strong) NSString *salemanName;
//接待员编号
@property (nonatomic, strong) NSString *salemanCd;
//接待员职务
@property (nonatomic, strong) NSString *salemanPosition;
//接待时间
@property (nonatomic, strong) NSString *saleDate;

// 录入员
@property (nonatomic, strong) NSString *createUserName;
//录入员编号
@property (nonatomic, strong) NSString *createUser;
//录入员职务
@property (nonatomic, strong) NSString *createUserPosition;
//录入时间
@property (nonatomic, strong) NSString *createDate;


// 变更员
@property (nonatomic, strong) NSString *updateUser;
//变更员编号
@property (nonatomic, strong) NSString *updateUserName;
//变更员职务
@property (nonatomic, strong) NSString *updateUserPosition;
//变更时间
@property (nonatomic, strong) NSString *updateDate;

// 波次
@property (nonatomic, strong) NSString *customerTurnCd;
// 人数
@property (nonatomic, strong) NSString *customerQty;

@property (nonatomic, strong) NSString *customerType;

// 单号
@property (nonatomic, strong) NSString *orderCd;

@end
