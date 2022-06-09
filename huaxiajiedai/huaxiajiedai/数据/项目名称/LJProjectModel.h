//
//  LJProjectModel.h
//  huaxiajiedai
//
//  Created by qm on 16/5/3.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJRootModel.h"

@interface LJProjectModel : LJRootModel
//"unitCd" : "001",
//"projectName" : "捏腿",
//"projectCd" : "001",
//"fastCode" : "",
//"typeCd" : "2",
//"qtyUpdateFlg" : false

@property (nonatomic, strong) NSString *unitCd;

@property (nonatomic, strong) NSString *projectName;

@property (nonatomic, strong) NSString *projectCd;

@property (nonatomic, strong) NSString *fastCode;

@property (nonatomic, strong) NSString *typeCd;

@property (nonatomic, strong) NSString *price;

@property (nonatomic, assign) BOOL qtyUpdateFlg;

@property (nonatomic, strong) NSString *serviceHeadcount;

@end