//
//  LJCollectViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/9/27.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopScrollViewMenuView.h"
#import "LJPickerView.h"
#import "LJNornalView.h"
#import "LJAllJieDaiListViewController.h"

@interface LJCollectViewController : UIViewController <CustomTopNavigationViewDelegate, UITableViewDelegate, UITableViewDataSource,PickViewDelegate, TapViewDelegate>

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (strong,nonatomic) NSMutableArray  *dataList;

@property (strong,nonatomic) UITableView  *tableView;

@property (nonatomic, strong) UIControl *myControl;

@property (nonatomic, strong) LJPickerView *pickView;

@end
