//
//  LJArtModel.h
//  huaxiajiedai
//
//  Created by qm on 16/5/10.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJRootModel.h"

@interface LJArtModel : LJRootModel

//"artificerName" : "刘技师",
//"artificerCd" : "001",
//"curState" : "free"

@property (nonatomic, strong) NSString *artificerName;
@property (nonatomic, strong) NSString *artificerCd;
@property (nonatomic, strong) NSString *curState;
@property (nonatomic, strong) NSString *fastCode;
@property (nonatomic, strong) NSString *sex;

@end
