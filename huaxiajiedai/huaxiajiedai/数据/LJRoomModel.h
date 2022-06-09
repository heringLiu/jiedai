//
//  LJRoomModel.h
//  huaxiajiedai
//
//  Created by qm on 16/4/27.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJRootModel.h"

@interface LJRoomModel : LJRootModel
/*
 roomCd": "001",
 "roomName": "馋嘴鸭",
 "roomState": "1",
 "sofaQty": "2",
 "sofaFreeQty": "1",
 "floor": "1",
 "manNum": "1",
 "womanNum": "0"
 */

@property (nonatomic, strong) NSString *roomCd;

@property (nonatomic, strong) NSString *roomName;

@property (nonatomic, strong) NSString *roomState;

@property (nonatomic, strong) NSString *sofaQty;

@property (nonatomic, strong) NSString *sofaFreeQty;

@property (nonatomic, strong) NSString *floor;

@property (nonatomic, strong) NSString *manNum;

@property (nonatomic, strong) NSString *womanNum;

@property (nonatomic, strong) NSString *reserveTime;

@property (nonatomic, strong) NSString *consumeEndTime;

@property (nonatomic, strong) NSString *roomEname;

@end
