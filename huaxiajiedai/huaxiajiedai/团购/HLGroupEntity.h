//
//  HLGroupEntity.h
//  huaxiajiedai
//
//  Created by 刘慧林 on 2022/6/27.
//  Copyright © 2022 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLGroupEntity : NSObject

//电话
@property (nonatomic, strong) NSString *telNo;
    //客户名称
@property (nonatomic, strong) NSString *customerName;
    //项目名称
@property (nonatomic, strong) NSString *projectNames;
    //团购码
@property (nonatomic, strong) NSString *verifCode;
    //订单编号
@property (nonatomic, strong) NSString *orderNo;
    //客户数量
@property (nonatomic, assign) int customerQty;
    // 团购类型
@property (nonatomic, assign) int groupType;
    //团购名称
@property (nonatomic, strong) NSString *groupName;
    // 团购金额
@property (nonatomic, assign) double groupBuyingAmt;
    // 实收金额
@property (nonatomic, assign) double receiveAmt;
    // 状态
@property (nonatomic, strong) NSString *status;
    // 状态
@property (nonatomic, strong) NSString *statusCd;
    // 转消费单按钮 是否可用
@property (nonatomic, assign) Boolean consumpFlg;
    // 团购项目明细
@property (nonatomic, strong) NSMutableArray *projectList;

@end

NS_ASSUME_NONNULL_END
