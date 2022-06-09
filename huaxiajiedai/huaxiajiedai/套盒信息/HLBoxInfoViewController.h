//
//  HLBoxInfoViewController.h
//  huaxiajishi
//
//  Created by gjhgj on 2017/11/1.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTopNavigationView.h"
#import "HLBoxTableViewCell.h"
#import "HLBoxInfoView.h"

@interface HLBoxInfoViewController : UIViewController <CustomTopNavigationViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSString *boxCd;

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (nonatomic, strong) UILabel *boxCdLabel;;


@end
