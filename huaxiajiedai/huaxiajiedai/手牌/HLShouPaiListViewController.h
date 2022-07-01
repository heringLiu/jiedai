//
//  HLShouPaiListViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/4/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopScrollViewMenuView.h"
#import "SWTableViewCell.h"
#import "ljroommodel.h"
#import "HLShouPaiDetailViewController.h"
#import "HLSelectedProjectViewController.h"
#import "HLTuanDetailViewController.h"

@interface HLShouPaiListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, topScrollViewMenuDelegate, CustomTopNavigationViewDelegate, SWTableViewCellDelegate, UISearchBarDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (strong,nonatomic) NSMutableArray *dataList;

@property (strong,nonatomic) UITableView *myTableView;

@property (nonatomic, assign) BOOL isConsumption;


@property (nonatomic, strong) UIButton *AddConsumptionButton;
@property (nonatomic, strong) UIButton *tuanButton;


@property (nonatomic, strong) UISearchBar *mySearchBar;

@property (nonatomic, strong) LJRoomModel *roomModel;

@property (nonatomic, strong) NSString *keyWords;

@property (nonatomic, strong) NSString *roomName;

@property (nonatomic, strong) NSMutableArray *searchData;

@property (nonatomic, assign) BOOL comeBack;

@property (nonatomic, assign) BOOL isPushed;

@property (nonatomic, strong) NSString *handCd;

@property (nonatomic, strong) NSString *sex;

@end
