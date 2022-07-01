//
//  LJWaitingAreaViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/4/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopScrollViewMenuView.h"
#import "SWTableViewCell.h"
#import "ljroommodel.h"
#import "LJConsumptionListModel.h"

@interface LJWaitingAreaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, topScrollViewMenuDelegate, CustomTopNavigationViewDelegate, SWTableViewCellDelegate, UISearchBarDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (strong,nonatomic) NSMutableArray *dataList;

@property (strong,nonatomic) UITableView *myTableView;

@property (nonatomic, assign) BOOL isConsumption;
@property (nonatomic, strong) UIButton *tuanButton;

@property (nonatomic, strong) UIButton *AddConsumptionButton;

@property (nonatomic, strong) UISearchBar *mySearchBar;

@property (nonatomic, strong) LJRoomModel *roomModel;

@property (nonatomic, strong) NSString *keyWords;

@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, strong) NSString *roomCd;

@property (nonatomic, strong) NSMutableArray *searchData;

@property (nonatomic, assign) BOOL comeBack;

@property (nonatomic, assign) BOOL isPushed;

@end
