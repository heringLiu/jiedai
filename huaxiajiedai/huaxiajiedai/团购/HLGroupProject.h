//
//  HLGroupProject.h
//  huaxiajiedai
//
//  Created by 刘慧林 on 2022/6/27.
//  Copyright © 2022 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLGroupProject : NSObject

@property (nonatomic, strong) NSString * id;
   /**
    * 租户ID
    */
   @property (nonatomic, strong) NSString * tenantId;
   /**
    * 团购Id
    */
   @property (nonatomic, strong) NSString * groupId;
   /**
    * 第几人
    */
@property (nonatomic, assign) int groupNum;
   /**
    * 团购项目编号
    */
   @property (nonatomic, strong) NSString * groupProjectCd;
   /**
    * 项目编号
    */
   @property (nonatomic, strong) NSString * projectCd;
   /**
    * 团购项目名称
    */
   @property (nonatomic, strong) NSString * groupProjectName;
   /**
    * 项目名称
    */
   @property (nonatomic, strong) NSString * projectName;
   /**
    * 团购项目价格
    */
@property (nonatomic, assign) double groupProjectPrice;
   /**
    * 项目价格
    */
@property (nonatomic, assign) double projectPrice;
   /**
    * 实收占比
    */
@property (nonatomic, assign) double receiptRate;
   /**
    * 实收金额
    */
@property (nonatomic, assign) double receiptAmt;

@end

NS_ASSUME_NONNULL_END
