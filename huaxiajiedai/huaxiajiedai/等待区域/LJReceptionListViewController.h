//
//  LJReceptionListViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/4/18.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJReceptionListRowView.h"
#import "TSTableView.h"
#import "TSTableViewModel.h"
#import "LJReceptionListTableViewCell.h"
#import "LJMenuView.h"
#import "LJConsumptionHeaderModel.h"
#import "LJSelectRoomViewController.h"
#import "LJRoomModel.h"
#import "LJPickerView.h"
#import "LJHLGridView.h"

@interface LJReceptionListViewController : UIViewController <CustomTopNavigationViewDelegate, UIScrollViewDelegate, TSTableViewDelegate,MenuViewDelegate,UIAlertViewDelegate, PickViewDelegate>

@property (nonatomic, strong) CustomTopNavigationView *topView;

//@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) LJPickerView *pickView;


@property (nonatomic, strong) LJMenuView *rightMenuView;

@property (nonatomic ,strong ) NSMutableArray *dataList;

@property (nonatomic, strong) NSString *orderCd;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) LJConsumptionHeaderModel *headerEntity;

@property (nonatomic, strong) NSMutableArray *pendingList;

@property (nonatomic, strong) NSMutableArray *orderDetailParamList;

@property (nonatomic, strong) NSString *roomCd;

@property (nonatomic, strong) UIControl *myControl;

@property (nonatomic, assign) BOOL isZhuan;


- (void) loadData;

@end
