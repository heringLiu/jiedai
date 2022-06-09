//
//  LJProjectListViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/5/9.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJReceptionDetailModel.h"
#import "LJPListTableViewCell.h"
#import "LJPListTModel.h"


@interface LJProjectListViewController : UIViewController <CustomTopNavigationViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (nonatomic, strong) LJReceptionDetailModel *entity;

@property (nonatomic, strong) UITableView *myTableView;


@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *cusDatas;

@property (nonatomic, strong) NSMutableArray *thDatas;


@end
