//
//  HLWorksViewController.h
//  huaxiajishi
//
//  Created by gjhgj on 2017/9/17.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTopNavigationView.h"
#import "HLWorksListModel.h"
#import "HLWorksTableViewCell.h"
#import "HLSearchViewController.h"

@interface HLWorksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CustomTopNavigationViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *startDate;

@property (nonatomic, strong) NSString *endDate;

@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, assign) NSInteger totalWork;

@property (nonatomic, assign) NSInteger totalSel;

@property (nonatomic, strong) NSString *frontTitle;

@end
