//
//  LJAllJieDaiListViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/10/8.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTopNavigationView.h"
#import "LJAllJieDaiModel.h"

@interface LJAllJieDaiListViewController : UIViewController<CustomTopNavigationViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (strong,nonatomic) NSMutableArray  *dataList;

@property (strong,nonatomic) UITableView  *tableView;

@end
