//
//  LJReceptionDetailModel.h
//  huaxiajiedai
//
//  Created by qm on 16/4/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJRootModel.h"

@interface LJReceptionDetailModel : LJRootModel

//套盒编码
@property (nonatomic, strong) NSString *boxCd;
// 技师1编号
@property (nonatomic, strong) NSString *artificer1Cd;

// 技师1选择方式   0：轮钟  1：点钟callTime(1)点钟
//wheelTime(0)轮钟
@property (nonatomic, strong) NSString *artificer1SelectType;

// 技师2编号
@property (nonatomic, strong) NSString *artificer2Cd;

// 技师2选择方式   0：轮钟  1：点钟
@property (nonatomic, strong) NSString *artificer2SelectType;

// 技师3编号
@property (nonatomic, strong) NSString *artificer3Cd;

// 技师3选择方式   0：轮钟  1：点钟
@property (nonatomic, strong) NSString *artificer3SelectType;


// 技师4编号
@property (nonatomic, strong) NSString *artificer4Cd;

// 技师4选择方式   0：轮钟  1：点钟
@property (nonatomic, strong) NSString *artificer4SelectType;

@property (nonatomic, strong) NSString *orderCd;

@property (nonatomic, strong) NSString *createDate;

@property (nonatomic, strong) NSString *customerCd;

@property (nonatomic, strong) NSString *projectCd;

@property (nonatomic, strong) NSString *o_projectCd;

@property (nonatomic, strong) NSString *detailNo;

@property (nonatomic, strong) NSString *sex;

@property (nonatomic, strong) NSString *sofaNo;

@property (nonatomic, strong) NSString *sofaNo1;

@property (nonatomic, strong) NSString *projectName;


@property (nonatomic, strong) NSString *roomCd;
@property (nonatomic, strong) NSString *roomName;

//客户波次
@property (nonatomic, strong) NSString *customerTurnCd;


//@property (nonatomic, strong) NSString *project_num;
@property (nonatomic, strong) NSString *projectNum;

@property (nonatomic, strong) NSString *price;

//@property (nonatomic, strong) NSString *project_status;

@property (nonatomic, strong) NSString *projectStatus;

@property (nonatomic, strong) NSString *serveStatus;

//结算状态
@property (nonatomic, strong) NSString *settlementStatus;


//@property (nonatomic, strong) NSString *settlement_status;

//@property (nonatomic, strong) NSString *saleman_name;

@property (nonatomic, strong) NSString *salemanName;

@property (nonatomic, strong) NSString *salemanCd;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) NSString *consumeAmt;

@property (nonatomic, assign) BOOL qtyUpdateFlg;

@property (nonatomic, strong) NSString *serviceHeadcount;

@property (nonatomic, strong) NSString *projectTime;

@property (nonatomic, strong) NSString *starTime;



@end
