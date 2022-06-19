//
//  LJConsumptionViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/4/22.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJReceptionListRowView.h"
#import "TSTableView.h"
#import "TSTableViewModel.h"
#import "LJReceptionListTableViewCell.h"
#import "LJMenuView.h"
#import "LJConsumptionHeaderModel.h"
#import "LJPickerView.h"
#import "LJHLGridView.h"
#import "HLSelectedProjectViewController.h"


@interface HLShouPaiDetailViewController : UIViewController <CustomTopNavigationViewDelegate, UIScrollViewDelegate, TSTableViewDelegate, MenuViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) CustomTopNavigationView *topView;

//@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) LJPickerView *pickView;

@property (nonatomic, strong) LJMenuView *rightMenuView;

@property (nonatomic ,strong ) NSMutableArray *dataList;

@property (nonatomic, strong) NSString *orderCd;

@property (nonatomic, strong) NSString *roomCd;

@property (nonatomic, strong) NSString *deleReason;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) LJConsumptionHeaderModel *headerEntity;

@property (nonatomic, strong) NSMutableArray *pendingList;

@property (nonatomic, strong) NSMutableArray *orderDetailParamList;

@property (nonatomic, strong) UIControl *myControl;

@property (nonatomic, strong) NSString *handCd;

@property (nonatomic, strong) NSString *sex;

- (void) loadData;
- (void) saveData;

@end
