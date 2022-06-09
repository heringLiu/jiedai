//
//  LJReceptionDetailModel.m
//  huaxiajiedai
//
//  Created by qm on 16/4/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJReceptionDetailModel.h"

@implementation LJReceptionDetailModel

- (instancetype)init {
    if (self = [super init]) {
        
        self.projectNum = @"1";
        self.sex = @"";
        self.roomCd = @"";
        self.price = @"";
        self.projectCd = @"";
        self.projectName = @"";
        self.projectStatus = @"";
        self.customerCd = @"";
        self.customerTurnCd = @"";
        self.orderCd = @"";
        self.detailNo = @"";
        self.artificer1Cd = @"";
        self.artificer1SelectType = @"";
        self.artificer2Cd = @"";
        self.artificer2SelectType = @"";
        self.artificer3Cd = @"";
        self.artificer3SelectType = @"";
        self.artificer4Cd = @"";
        self.artificer4SelectType = @"";
        self.sofaNo = @"";
        self.serviceHeadcount = @"1";
        self.qtyUpdateFlg = NO;
    }
    
    return self;
}


- (void)setSofaNo:(NSString *)sofaNo {
    _sofaNo = sofaNo;
    if (_sofaNo1.length == 0 && _sofaNo.length > 0) {
        _sofaNo1 = _sofaNo;
    }
}

@end
