//
//  LJConsumptionListModel.h
//  huaxiajiedai
//
//  Created by qm on 16/4/27.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJRootModel.h"

@interface LJConsumptionListModel : LJRootModel

/*
 "orderCd": "12016041811364000001",
 "customerQty": "15",
 "salemanName": "???",
 "createDate": "1460944279253"
 */

@property (nonatomic, strong) NSString *orderCd;

@property (nonatomic, strong) NSString *salemanCd;

@property (nonatomic, strong) NSString *customerQty;

@property (nonatomic, strong) NSString *salemanName;

@property (nonatomic, strong) NSString *createDate;

@property (nonatomic, strong) NSString *salesDateTime;

@end
