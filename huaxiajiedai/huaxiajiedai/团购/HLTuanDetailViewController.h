//
//  HLTuanDetailViewController.h
//  huaxiajiedai
//
//  Created by 刘慧林 on 2022/6/26.
//  Copyright © 2022 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQCodeScanner.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLTuanDetailViewController : UIViewController <CustomTopNavigationViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CustomTopNavigationView *topView;
@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) UIView *topInfoView;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, strong) NSString *roomCd;
@property (nonatomic, strong) NSString *orderCd;


//电话
@property (nonatomic, strong) UILabel *telNo;
    //客户名称
@property (nonatomic, strong) UILabel *customerNameLabel;
    //项目名称
@property (nonatomic, strong) UILabel *projectNamesLabel;
    //团购码
@property (nonatomic, strong) UILabel *verifCodeLabel;
    //订单编号
@property (nonatomic, strong) UILabel *orderNoLabel;
    //客户数量
@property (nonatomic, strong) UILabel * customerQtyLabel;
    // 团购类型
@property (nonatomic, strong) UILabel * groupTypeLabel;
    //团购名称
@property (nonatomic, strong) UILabel *groupNameLabel;
    // 团购金额
@property (nonatomic, assign) UILabel * groupBuyingAmtLabel;
    // 实收金额
@property (nonatomic, strong) UILabel * receiveAmtLabel;
    // 状态
@property (nonatomic, strong) UILabel *statusLabel;
    // 状态
@property (nonatomic, strong) UILabel *statusCdLabel;
    // 转消费单按钮 是否可用
@property (nonatomic, strong) UILabel * consumpFlgLabel;
    // 团购项目明细
@property (nonatomic, strong) NSMutableArray *projectList;

@end

NS_ASSUME_NONNULL_END
