//
//  LJPListTModel.h
//  huaxiajiedai
//
//  Created by qm on 16/5/9.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJRootModel.h"

@interface LJPListTModel : LJRootModel

//"customerCd": "20160422150605001",
//"artificer1Cd": "001",
//"timeRemaining": "193",
//"starTime": "2016-05-06 10:02:56"


// 技师1编号
@property (nonatomic, strong) NSString *artificer1Cd;


// 技师2编号
@property (nonatomic, strong) NSString *artificer2Cd;

@property (nonatomic, strong) NSString *customerCd;

@property (nonatomic, strong) NSString *roomCd;

@property (nonatomic, strong) NSString *timeRemaining;


@property (nonatomic, strong) NSString *distanceTime;

@property (nonatomic, strong) NSString *serve_status;

@property (nonatomic, strong) NSString *waitNum;

@property (nonatomic, strong) NSString *artificer1SelectType;

@property (nonatomic, strong) NSString *artificer2SelectType;

@end
