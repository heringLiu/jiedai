//
//  HLTotalViewController.h
//  huaxiajishi
//
//  Created by gjhgj on 2017/9/21.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTopNavigationView.h"
#import "HLTotalTableViewCell.h"
#import "HLSearchViewController.h"
#import "HLSearchView.h"
#import "HLWorksViewController.h"

@interface HLTotalViewController : UIViewController <CustomTopNavigationViewDelegate,UITableViewDelegate, UITableViewDataSource,HLSearchViewDelegate>

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) HLSearchView *searchView;

@property (nonatomic, strong) NSString *startStr;
@property (nonatomic, strong) NSString *endStr;
@property (nonatomic, strong) NSString *frontTitle;

@end
