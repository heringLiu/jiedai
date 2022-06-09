//
//  HLWorksViewController.m
//  huaxiajishi
//
//  Created by gjhgj on 2017/9/17.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "HLWorksViewController.h"

@interface HLWorksViewController (){
    NSMutableArray *dataList;
    
    NSString *allStr;
    
    CGFloat totalMoney;
    CGFloat totalQty;
    
    UILabel *totalQtyLabel;
    UILabel *totalMoneyLabel;
    
}
@end


@implementation HLWorksViewController
@synthesize myTableView, topView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.totalSel = 0;
    self.totalWork = 0;
    totalQty = 0;
    totalMoney = 0;
    
    self.view.backgroundColor = gray238;
    self.automaticallyAdjustsScrollViewInsets = NO;
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    topView.delegate = self;
    [self.view addSubview:topView];
    if ([self.type isEqualToString:@"work"]) {
        topView.titleLabel.text = @"做活明细表";
    } else if ([self.type isEqualToString:@"select"]) {
        topView.titleLabel.text = @"点钟明细表";
    } else if ([self.type isEqualToString:@"card"]) {
        topView.titleLabel.text = @"售卡明细表";
    } else if ([self.type isEqualToString:@"box"]) {
        topView.titleLabel.text = @"售盒明细表";
    } else if ([self.type isEqualToString:@"ticket"]) {
        topView.titleLabel.text = @"售票明细表";
    }
    topView.titleLabel.text = [NSString stringWithFormat:@"%@%@", self.frontTitle, topView.titleLabel.text];
    topView.backgroundColor = navLightBrownColor ;
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    topView.leftButton.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    //    topView.rightButton.hidden = YES;
//    [topView.rightButton setImage:[UIImage imageNamed:@"icon_Search_bg color"] forState:UIControlStateNormal];
//    topView.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
//    topView.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
//    [topView.leftButton setTitle:@"汇总" forState:UIControlStateNormal];
//    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, kMainScreenWidth, 50)];
//    [self.view addSubview:totalView];
//    totalView.backgroundColor = [UIColor whiteColor];
//    
//    self.totalLabel = [[UILabel alloc] init];
//    [totalView addSubview:self.totalLabel];
//    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(totalView).offset(20);
//        make.right.equalTo(totalView);
//        make.top.equalTo(totalView);
//        make.bottom.equalTo(totalView);
//    }];
//    
//    self.totalLabel.text = @"汇总：做活 0 次 点钟 0 次";
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kMainScreenWidth, kMainScreenHeight - kTopScreenWidth - 40)];
    [self.view addSubview:myTableView];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [myTableView registerClass:[HLWorksTableViewCell class] forCellReuseIdentifier:@"Cell"];
    myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNew];
    }];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView.mj_header beginRefreshing];
    
    
    [self setTotalView];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, 40)];
    view.backgroundColor = WhiteColor;
//    view.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
    if ([self.type isEqualToString:@"card"]) {
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth/2, 40)];
        [view addSubview:leftLabel];
        leftLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        leftLabel.font = FONT14;
        leftLabel.textColor = WhiteColor;
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text = @"营业日期";
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(kappScreenWidth/2+1, 0, kappScreenWidth/2, 40)];
        [view addSubview:rightLabel];
        rightLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        rightLabel.font = FONT14;
        rightLabel.textColor = WhiteColor;
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.text = @"金额";
    } else if ([self.type isEqualToString:@"ticket"]) {
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth/4, 40)];
        [view addSubview:leftLabel];
        leftLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        leftLabel.font = FONT14;
        leftLabel.textColor = WhiteColor;
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text = @"营业日期";
        
        UILabel *leftLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kappScreenWidth/4 + 1, 0, kappScreenWidth/4, 40)];
        [view addSubview:leftLabel2];
        leftLabel2.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        leftLabel2.font = FONT14;
        leftLabel2.textColor = WhiteColor;
        leftLabel2.textAlignment = NSTextAlignmentCenter;
        leftLabel2.text = @"项目名称";
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(kappScreenWidth/4*2 + 2, 0, kappScreenWidth/4, 40)];
        [view addSubview:rightLabel];
        rightLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        rightLabel.font = FONT14;
        rightLabel.textColor = WhiteColor;
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.text = @"套票数量";
        
        UILabel *rightLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kappScreenWidth/4*3 + 3, 0, kappScreenWidth/4, 40)];
        [view addSubview:rightLabel2];
        rightLabel2.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        rightLabel2.font = FONT14;
        rightLabel2.textColor = WhiteColor;
        rightLabel2.textAlignment = NSTextAlignmentCenter;
        rightLabel2.text = @"金额";

    } else if ([self.type isEqualToString:@"box"]) {
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth/4, 40)];
        [view addSubview:leftLabel];
        leftLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        leftLabel.font = FONT14;
        leftLabel.textColor = WhiteColor;
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text = @"营业日期";
        
        UILabel *leftLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kappScreenWidth/4 + 1, 0, kappScreenWidth/4, 40)];
        [view addSubview:leftLabel2];
        leftLabel2.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        leftLabel2.font = FONT14;
        leftLabel2.textColor = WhiteColor;
        leftLabel2.textAlignment = NSTextAlignmentCenter;
        leftLabel2.text = @"项目名称";
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(kappScreenWidth/4*2 + 2, 0, kappScreenWidth/4, 40)];
        [view addSubview:rightLabel];
        rightLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        rightLabel.font = FONT14;
        rightLabel.textColor = WhiteColor;
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.text = @"套盒数量";
        
        UILabel *rightLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kappScreenWidth/4*3 + 3, 0, kappScreenWidth/4, 40)];
        [view addSubview:rightLabel2];
        rightLabel2.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        rightLabel2.font = FONT14;
        rightLabel2.textColor = WhiteColor;
        rightLabel2.textAlignment = NSTextAlignmentCenter;
        rightLabel2.text = @"金额";
    }
    
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLWorksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    for (UIView *sub in cell.subviews) {
        [sub removeFromSuperview];
    }
    HLWorksListModel *entity = [dataList objectAtIndex:indexPath.row];
    
    [cell setCellWithData:entity];
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    LJDetailViewController *next = [[LJDetailViewController alloc] init];
//    next.delegate = self;
//    next.listEntity = [dataList objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:next animated:YES];
}

- (void) sendRestTime:(NSDictionary *)restData {
    // 接收剩余时间
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataList.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonPressed {
    HLSearchViewController *searchViewController = [[HLSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)rightButton2Pressed {
    
}




- (void) loadNew {
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic setObject:self.endDate forKey:@"endTime"];
    [mutableDic setObject:self.startDate forKey:@"startTime"];
    [mutableDic setObject:[userDefaults objectForKey:USERID] forKey:@"artificerCd"];
//    [mutableDic setObject:[userDefaults objectForKey:STORECD] forKey:@"StoreCd"];
//    [mutableDic setObject:@"2017-08-01" forKey:@"StartDate"];
//    [mutableDic setObject:@"2017-08-01" forKey:@"EndDate"];
//    NSDictionary *dic = @{@"StartDate":@"2017-07-01",@"EndDate":@"2017-08-01",@"EmployeeCd":@"160320002",@"StoreCd":@"103003001"};
    
    NSString *url = @"";
    if ([self.type isEqualToString:@"work"]) {
        url = WORKSDETAILLIST;
    } else if ([self.type isEqualToString:@"select"]) {
        url = SELECTEDDETAILLIST;
    } else if ([self.type isEqualToString:@"card"]) {
        url = CARDDETAILLIST;
    } else if ([self.type isEqualToString:@"ticket"]) {
        url = TICKETDETAILLIST;
    } else if ([self.type isEqualToString:@"box"]) {
        url = BOXDETAILLIST;
    }
    
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:url parameters:mutableDic success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        self.totalWork = 0 ;
        self.totalSel = 0;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", jsonString);
        
        if (ISSUCCESS) {
            if (!dataList) {
                dataList = [NSMutableArray array];
            }
            [dataList removeAllObjects];
//            HLWorksListModel *aModel = [[HLWorksListModel alloc] init];
//            aModel.type = self.type;
//            if ([self.type isEqualToString:@"work"]) {
//                aModel.leftName = @"营业日期";
//                aModel.middleName = @"项目名称";
//                aModel.rightName = @"做活数量";
//                aModel.isTop = YES;
//                [dataList addObject:aModel];
//            } else if ([self.type isEqualToString:@"select"]) {
//                aModel.leftName = @"营业日期";
//                aModel.middleName = @"项目名称";
//                aModel.rightName = @"点钟数量";
//                aModel.isTop = YES;
//                [dataList addObject:aModel];
//            } else if ([self.type isEqualToString:@"card"]) {
//                aModel.leftName = @"营业日期";
//                aModel.middleName = @"销售类型";
//                aModel.rightName = @"金额";
//                aModel.isTop = YES;
//                [dataList addObject:aModel];
//            } else if ([self.type isEqualToString:@"ticket"]) {
//                aModel.leftName = @"营业日期";
//                aModel.middleName = @"项目名称";
//                aModel.workQty = @"套票数量";
//                aModel.rightName = @"金额";
//                aModel.isTop = YES;
//                [dataList addObject:aModel];
//            } else if ([self.type isEqualToString:@"box"]) {
//                aModel.leftName = @"营业日期";
//                aModel.middleName = @"项目名称";
//                aModel.workQty = @"套盒数量";
//                aModel.rightName = @"金额";
//                aModel.isTop = YES;
//                [dataList addObject:aModel];
//            }
            
            for (NSDictionary *dic in CONTENTOBJ) {
                HLWorksListModel *entiy = [[HLWorksListModel alloc] init];
                [entiy setValuesForKeysWithDictionary:dic];
                
                entiy.type = self.type;
                
                [dataList addObject:entiy];
                if ([self.type isEqualToString:@"work"]) {
                    entiy.leftName = entiy.businessDate;
                    entiy.middleName = entiy.projectName;
                    entiy.rightName = entiy.workQty;
                } else if ([self.type isEqualToString:@"select"]) {
                    entiy.leftName = entiy.businessDate;
                    entiy.middleName = entiy.projectName;
                    entiy.rightName = entiy.selectQty;
                } else if ([self.type isEqualToString:@"card"]) {
                    entiy.leftName = entiy.businessDate;
                    entiy.middleName = entiy.amtCategory;
                    entiy.rightName = entiy.amt;
                } else if ([self.type isEqualToString:@"ticket"]) {
                    entiy.leftName = entiy.businessDate;
                    entiy.middleName = entiy.amtTypeName;
                    entiy.workQty = entiy.qty;
                    entiy.rightName = entiy.amt;
                    
                    totalQty += [entiy.qty doubleValue];
                    
                } else if ([self.type isEqualToString:@"box"]) {
                    entiy.leftName = entiy.businessDate;
                    entiy.middleName = entiy.amtTypeName;
                    entiy.workQty = entiy.qty;
                    entiy.rightName = entiy.amt;
                    totalQty += [entiy.qty doubleValue];
                }
                
                totalMoney += [entiy.amt doubleValue];
            }
            if (totalQtyLabel) {
                totalQtyLabel.text = [NSString stringWithFormat:@"%.0f", totalQty];
            }
            totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f", totalMoney];
//            if ([self.type isEqualToString:@"card"]) {
//                HLWorksListModel *entiy = [[HLWorksListModel alloc] init];
//                entiy.type = self.type;
//                entiy.leftName = @"合计：";
//                entiy.middleName = @"开卡、充值";
//                entiy.rightName = [NSString stringWithFormat:@"%.2f", totalMoney];
//                
//                [dataList addObject:entiy];
//            } else if ([self.type isEqualToString:@"ticket"]) {
//                HLWorksListModel *entiy = [[HLWorksListModel alloc] init];
//                entiy.leftName = @"合计：";
//                entiy.middleName = @"";
//                entiy.rightName = [NSString stringWithFormat:@"%.2f", totalMoney];
//                
//                [dataList addObject:entiy];
//            } else if ([self.type isEqualToString:@"box"]) {
//                HLWorksListModel *entiy = [[HLWorksListModel alloc] init];
//                entiy.leftName = @"合计：";
//                entiy.middleName = @"";
//                entiy.rightName = [NSString stringWithFormat:@"%.2f", totalMoney];
//                
//                [dataList addObject:entiy];
//            }
        }
        
        [myTableView reloadData];
        
        [myTableView.mj_header endRefreshing];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DISMISS
        [myTableView.mj_header endRefreshing];
        
        
    }];
    
    
}
- (NSDate *)zeroOfDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:ts];
}

- (void ) setTotalView {
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0, kappScreenHeight - 40, kappScreenWidth, 40)];
    [self.view addSubview:totalView];
    
    totalView.backgroundColor = WhiteColor;
    if ([self.type isEqualToString:@"card"]) {
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth/2, 40)];
        [totalView addSubview:leftLabel];
        leftLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        leftLabel.font = FONT14;
        leftLabel.textColor = WhiteColor;
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text = @"合计：";
        
        totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kappScreenWidth/2+1, 0, kappScreenWidth/2, 40)];
        [totalView addSubview:totalMoneyLabel];
        totalMoneyLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        totalMoneyLabel.font = FONT14;
        totalMoneyLabel.textColor = WhiteColor;
        totalMoneyLabel.textAlignment = NSTextAlignmentCenter;
        totalMoneyLabel.text = @"";
    } else {
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth/2+1, 40)];
        [totalView addSubview:leftLabel];
        leftLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        leftLabel.font = FONT14;
        leftLabel.textColor = WhiteColor;
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text = @"合计：";
        
        totalQtyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kappScreenWidth/2+2, 0, kappScreenWidth/4, 40)];
        [totalView addSubview:totalQtyLabel];
        totalQtyLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        totalQtyLabel.font = FONT14;
        totalQtyLabel.textColor = WhiteColor;
        totalQtyLabel.textAlignment = NSTextAlignmentCenter;
        totalQtyLabel.text = @"";
        
        totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kappScreenWidth/4*3+3, 0, kappScreenWidth/4, 40)];
        [totalView addSubview:totalMoneyLabel];
        totalMoneyLabel.backgroundColor = [UIColor colorWithRed:204/255.0f green:119/255.0f blue:76/255.0f alpha:1];
        totalMoneyLabel.font = FONT14;
        totalMoneyLabel.textColor = WhiteColor;
        totalMoneyLabel.textAlignment = NSTextAlignmentCenter;
        totalMoneyLabel.text = @"";
    }
    

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
