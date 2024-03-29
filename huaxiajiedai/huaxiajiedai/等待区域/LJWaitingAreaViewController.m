//
//  LJWaitingAreaViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/4/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJWaitingAreaViewController.h"
#import "LJAddClientViewController.h"
#import "ShoppingMallTabBarViewController.h"
@interface LJWaitingAreaViewController () <SelectRoomDelegate, UIGestureRecognizerDelegate> {
    NSIndexPath *delIndexPath;
}

@end

@implementation LJWaitingAreaViewController
@synthesize topView, myTableView, isConsumption, AddConsumptionButton, mySearchBar, tuanButton, allButton;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    self.isPushed = NO;
    if (!isConsumption) {
        [self.tabBarController.tabBar removeFromSuperview];
        [(ShoppingMallTabBarViewController *)self.tabBarController hideTabBar:YES];
    }
    
    [myTableView.mj_header beginRefreshing];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    } else {
        return YES;
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.tabBarController.tabBar removeFromSuperview];
    [(ShoppingMallTabBarViewController *)self.tabBarController hideTabBar:YES];
}

- (void) loadData {
    
    if (isConsumption) {
//        消费单
        NSDictionary *dic = @{@"roomCd":self.roomModel.roomCd ? self.roomModel.roomCd : @""};
        [[NetWorkingModel sharedInstance] GET:RECEPTIONGETROOMORDER parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
            if (ISSUCCESS) {
                [self.dataList removeAllObjects];
                for (NSDictionary *dic in CONTENTOBJ) {
                    LJConsumptionListModel *entity = [[LJConsumptionListModel alloc] init];
                    [entity setValuesForKeysWithDictionary:dic];
                    if (self.dataList == nil) {
                        self.dataList = [NSMutableArray array];
                    }
                    
                    [self.dataList addObject:entity];
                }
                
                [myTableView reloadData];
                
                if (!self.comeBack) {
                    self.comeBack = YES;
                    if (self.dataList.count == 1) {
                        LJConsumptionListModel *entity = [self.dataList objectAtIndex:0];
                        LJConsumptionViewController *next = [[LJConsumptionViewController alloc] init];
                        next.roomCd = self.roomModel.roomCd;
                        next.orderCd =entity.orderCd;
                        [self.navigationController pushViewController:next animated:YES];
 
                    } else if (self.dataList.count > 1) {
                        [self allBtnClick];
                    }
                    
                }
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    if (self.searchData == nil) {
                        self.searchData = [NSMutableArray array];
                    } else {
                        [self.searchData removeAllObjects];
                    }
                    self.searchData = [NSMutableArray arrayWithArray:self.dataList];
                });
                
            } else {
                BADREQUEST
            }
            [myTableView.mj_header endRefreshing];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [myTableView.mj_header endRefreshing];
        }];
    } else {
        NSDictionary *dic = @{@"keyWords":self.keyWords.length ? self.keyWords : @"", @"userId":[userDefaults objectForKey:USERID]};
        [[NetWorkingModel sharedInstance] GET:RECEPTIONORDERHEADERLIST parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
            
            if (ISSUCCESS) {
                [self.dataList removeAllObjects];
                for (NSDictionary *dic in CONTENTOBJ) {
                    LJConsumptionListModel *entity = [[LJConsumptionListModel alloc] init];
                    [entity setValuesForKeysWithDictionary:dic];
                    if (self.dataList == nil) {
                        self.dataList = [NSMutableArray array];
                    }
                    
                    [self.dataList addObject:entity];
                }
                
                [myTableView reloadData];
            } else {
                BADREQUEST
            }
            [myTableView.mj_header endRefreshing];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [myTableView.mj_header endRefreshing];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = gray238;
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth )];
    [self.view addSubview:topView];
    topView.delegate = self;
    [topView.rightButton setImage:[UIImage imageNamed:@"icon_Search_bg color"] forState:UIControlStateNormal];
    topView.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    topView.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
    if (isConsumption) {
        topView.backgroundColor = navLightBrownColor;
        topView.titleLabel.text = [NSString stringWithFormat:@"%@_消费订单管理", self.roomName];
        [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
        
    } else {
        topView.backgroundColor = NavBackColor;
        topView.titleLabel.text = @"等待区域";
        [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
        [topView.leftButton2 setHidden:NO];
        [topView.leftButton2 setImage:[UIImage imageNamed:@"icon_order"] forState:UIControlStateNormal];
    }
    
    if (mySearchBar == nil) {
        mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, kSafeHeight ? kSafeHeight + 10 : 20 , kappScreenWidth - 80, 40)];
        //    searchBar.
        [topView addSubview:mySearchBar];
        mySearchBar.delegate = self;
        mySearchBar.placeholder = @"请输入接待部长的编号、姓名或订单号";
        //    searchBar.tintColor = LightBrownColor;
        mySearchBar.showsCancelButton = NO;
        mySearchBar.barTintColor = LightBrownColor;
        [mySearchBar setImage:[UIImage imageNamed:@"icon_Search_bg white"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        mySearchBar.backgroundColor = [UIColor clearColor];
        NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue >= 13.0) {
            mySearchBar.searchTextField.backgroundColor = [UIColor clearColor];
        } else {
            for (UIView *view in mySearchBar.subviews.lastObject.subviews) {
                if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                     [view removeFromSuperview];
    //                view.layer.contents = nil;
                    break;
                }
            }
        }
        mySearchBar.hidden = YES;
    }
    CGFloat barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 29.0f;
    CGFloat tableHeight = kappScreenHeight - kTopScreenWidth - barHeight;
    if (isConsumption) {
        tableHeight = kappScreenHeight - kTopScreenWidth;
    }
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kappScreenWidth, tableHeight) style:UITableViewStylePlain];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [myTableView registerClass:[SWTableViewCell class] forCellReuseIdentifier:@"Cell"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    
    [self.view addSubview:myTableView];
    
    if (isConsumption) {
        AddConsumptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:AddConsumptionButton];
        [AddConsumptionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(50);
            make.bottom.equalTo(self.view).offset(-40);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        AddConsumptionButton.backgroundColor = LightBrownColor;
        [AddConsumptionButton setImage:[UIImage imageNamed:@"icon_order"] forState:UIControlStateNormal];
        AddConsumptionButton.layer.cornerRadius = 30;
        AddConsumptionButton.layer.masksToBounds = YES;
        [AddConsumptionButton addTarget:self action:@selector(addConsumption) forControlEvents:UIControlEventTouchUpInside];
        
        
        tuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:tuanButton];
        [tuanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-40);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        tuanButton.backgroundColor = LightBrownColor;
//        [tuanButton setImage:[UIImage imageNamed:@"icon_order"] forState:UIControlStateNormal];
        [tuanButton setTitle:@"团" forState:UIControlStateNormal];
        [tuanButton.titleLabel setFont:FONT20];
        tuanButton.layer.cornerRadius = 30;
        tuanButton.layer.masksToBounds = YES;
        [tuanButton addTarget:self action:@selector(addTuan) forControlEvents:UIControlEventTouchUpInside];
        
        allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:allButton];
        [allButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).offset(-50);
            make.bottom.equalTo(self.view).offset(-40);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        allButton.backgroundColor = LightBrownColor;
//        [tuanButton setImage:[UIImage imageNamed:@"icon_order"] forState:UIControlStateNormal];
        [allButton setTitle:@"全" forState:UIControlStateNormal];
        [allButton.titleLabel setFont:FONT20];
        allButton.layer.cornerRadius = 30;
        allButton.layer.masksToBounds = YES;
        [allButton addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
     

    }
    
}
- (void) allBtnClick {
    if (isConsumption) {
        LJConsumptionViewController *next = [[LJConsumptionViewController alloc] init];
        next.roomCd = self.roomModel.roomCd;
        next.roomName = self.roomModel.roomName;
        next.isAll = YES;
        self.isPushed = YES;
        [self.navigationController pushViewController:next animated:YES];
        
    } else {

        LJReceptionListViewController *next = [[LJReceptionListViewController alloc] init];
        next.roomCd = self.roomModel.roomCd;
        [self.tabBarController.tabBar removeFromSuperview];
        [(ShoppingMallTabBarViewController *)self.tabBarController hideTabBar:YES];
        self.isPushed = YES;
        [self.navigationController pushViewController:next animated:YES];
    }
}

- (void) addTuan {
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:BUSINESSDATE parameters:@{} success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", jsonString);
        
        if (ISSUCCESS) {
            NSString *dateStr = [CONTENTOBJ objectForKey:@"BusinessDate"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
            df.dateFormat = @"YYYY-MM-dd";
            NSDate *date = [df dateFromString:dateStr];
            date = [self getNowDateFromatAnDate:date];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];

            NSDate *nowDate = [NSDate date];

            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nowDate];
            nowDate = [calendar dateFromComponents:components];
            nowDate = [self getNowDateFromatAnDate:nowDate];
            
            NSLog(@"date = %@, nowdate = %@", date, nowDate);
            NSTimeInterval business = [date timeIntervalSince1970];
            NSTimeInterval now = [nowDate timeIntervalSince1970];
            
            if (business > now) {
                //NSLog(@"Date1  is in the future");
                NSLog(@"大");
            } else if (business < now){
                //NSLog(@"Date1 is in the past");
                NSLog(@"小");
                                NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
                NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
                int hour = (int) [dateComponent hour];
                if (hour >= 7) {
                    SHOWTEXTINWINDOW(@"还未日结，请日结后开单", 1);
                    return ;
                }
            } else  {
                NSLog(@"相等");
            }
            
            HLTuanDetailViewController *next = [[HLTuanDetailViewController alloc] init];
            next.roomCd = self.roomCd;
            [self.navigationController pushViewController:next animated:YES];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DISMISS
        SHOWTEXTINWINDOW(@"获取营业日失败", 1);
        
    }];
}

- (void) addConsumption {
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:BUSINESSDATE parameters:@{} success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", jsonString);
        
        if (ISSUCCESS) {
            NSString *dateStr = [CONTENTOBJ objectForKey:@"BusinessDate"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
            df.dateFormat = @"YYYY-MM-dd";
            NSDate *date = [df dateFromString:dateStr];
            date = [self getNowDateFromatAnDate:date];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];

            NSDate *nowDate = [NSDate date];

            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nowDate];
            nowDate = [calendar dateFromComponents:components];
            nowDate = [self getNowDateFromatAnDate:nowDate];
            
            NSLog(@"date = %@, nowdate = %@", date, nowDate);
            NSTimeInterval business = [date timeIntervalSince1970];
            NSTimeInterval now = [nowDate timeIntervalSince1970];
            
            if (business > now) {
                //NSLog(@"Date1  is in the future");
                NSLog(@"大");
            } else if (business < now){
                //NSLog(@"Date1 is in the past");
                NSLog(@"小");
                                NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
                NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
                int hour = (int) [dateComponent hour];
                if (hour >= 7) {
                    SHOWTEXTINWINDOW(@"还未日结，请日结后开单", 1);
                    return ;
                }
            } else  {
                NSLog(@"相等");
            }
            LJAddClientViewController *addClientViewController = [[LJAddClientViewController alloc] init];
            addClientViewController.roomCd = self.roomModel.roomCd;
            addClientViewController.isConsumption = YES;
            [self.navigationController pushViewController:addClientViewController animated:YES];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DISMISS
        SHOWTEXTINWINDOW(@"获取营业日失败", 1);
        
    }];
   
    
    
}
//把国际时间转换为当前系统时间
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mySearchBar.isHidden ? self.dataList.count : self.searchData.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        CGFloat cellFontNumber = 14.0f;
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.leftUtilityButtons = [self leftButtons];
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        UIView *bottomView = [[UIView alloc] init];
        [cell addSubview:bottomView];
        bottomView.backgroundColor = gray238;
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell);
            make.right.equalTo(cell);
            make.bottom.equalTo(cell);
            make.height.mas_equalTo(10);
        }];
        
        // 接待单号 reception
        UILabel *receptionNumberLabel = [UILabel new];
        [cell.contentView addSubview:receptionNumberLabel];
        [receptionNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(10);
            make.left.equalTo(cell.contentView).offset(15);
            make.height.mas_equalTo(FONT(cellFontNumber).lineHeight);
        }];
        receptionNumberLabel.font = FONT(cellFontNumber);
        receptionNumberLabel.textColor = gray146;
        receptionNumberLabel.tag = 1000;
        
        // 接待部长
        UILabel *receptionMinisterLabel = [UILabel new];
        [cell.contentView addSubview:receptionMinisterLabel];
        [receptionMinisterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(receptionNumberLabel.mas_left);
            make.top.equalTo(receptionNumberLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(FONT(cellFontNumber).lineHeight);
        }];
        receptionMinisterLabel.font = FONT(cellFontNumber);
        receptionMinisterLabel.textColor = gray146;
        receptionMinisterLabel.tag = 1001;
        
        // 人数
        UILabel *personCountLabel = [UILabel new];
        [cell.contentView addSubview:personCountLabel];
        [personCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell.contentView).offset(-15);
            make.centerY.equalTo(receptionMinisterLabel.mas_centerY);
            make.height.mas_equalTo(FONT(cellFontNumber).lineHeight);
        }];
        personCountLabel.font = FONT(cellFontNumber);
        personCountLabel.textColor = gray146;
        personCountLabel.textAlignment = NSTextAlignmentRight;
        personCountLabel.tag = 1002;
        
        UIView *lineView = [UIView new];
        [cell.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
            make.right.equalTo(cell.contentView).offset(-15);
            make.top.equalTo(receptionMinisterLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(1);
        }];
        lineView.backgroundColor = gray238;
        
        // 时间
        UILabel *timeLabel = [UILabel new];
        [cell.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(receptionNumberLabel.mas_left);
            make.top.equalTo(lineView.mas_bottom).offset(10);
            make.height.mas_equalTo(FONT(cellFontNumber).lineHeight);
        }];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.textColor = gray191;
        timeLabel.font = FONT(cellFontNumber);
        timeLabel.tag = 1003;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    LJConsumptionListModel *entity = mySearchBar.isHidden ? [self.dataList objectAtIndex:indexPath.row] : [self.searchData objectAtIndex:indexPath.row];
    
    UILabel *receptionNumberLabel = (UILabel *)[cell viewWithTag:1000];
    receptionNumberLabel.text = [NSString stringWithFormat:@"接待单号：%@", entity.orderCd];
    if (self.isConsumption) {
        receptionNumberLabel.text = [NSString stringWithFormat:@"消费单号：%@", entity.orderCd];
    }
    
    
    UILabel *receptionMinisterLabel = (UILabel *)[cell viewWithTag:1001];
    
    receptionMinisterLabel.text = [NSString stringWithFormat:@"接待部长：%@", entity.salemanName];
    
    UILabel *personCountLabel = (UILabel *)[cell viewWithTag:1002];
    personCountLabel.text = [NSString stringWithFormat:@"人数：%@人", entity.customerQty];
    
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:1003];
    timeLabel.text = isConsumption ? entity.createDate : entity.salesDateTime;

    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isPushed) {
        return;
    }
    LJConsumptionListModel *entity = mySearchBar.isHidden ? [self.dataList objectAtIndex:indexPath.row] : [self.searchData objectAtIndex:indexPath.row];
    if (isConsumption) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        LJConsumptionViewController *next = [[LJConsumptionViewController alloc] init];
        next.roomCd = self.roomModel.roomCd;
        next.orderCd =entity.orderCd;
        self.isPushed = YES;
        [self.navigationController pushViewController:next animated:YES];
        
    } else {

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        LJReceptionListViewController *next = [[LJReceptionListViewController alloc] init];
        next.orderCd = entity.orderCd;
        next.roomCd = self.roomModel.roomCd;
        [self.tabBarController.tabBar removeFromSuperview];
        [(ShoppingMallTabBarViewController *)self.tabBarController hideTabBar:YES];
        self.isPushed = YES;
        [self.navigationController pushViewController:next animated:YES];
    }
    
}

// 侧滑
- (NSArray *)rightButtons
{
    if (isConsumption) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        [rightUtilityButtons sw_addUtilityButtonWithColor: LightBrownColor title:@"删除"];
        
        return rightUtilityButtons;
    } else {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        [rightUtilityButtons sw_addUtilityButtonWithColor: LightBrownColor title:@"消费单"];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:245/255.0f green:149/255.0f blue:149/255.0f alpha:1.0f] title:@"删除"];
        
        return rightUtilityButtons;
    }
    
    
    
}

- (NSArray *)leftButtons
{
    
    
    return nil;
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            if (isConsumption) {
//                删除消费单
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除该条消费单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                av.tag = 2001;
                [av show];
                delIndexPath = [myTableView indexPathForCell:cell];
            } else {
//                接待单转消费单
                delIndexPath = [myTableView indexPathForCell:cell];
                LJSelectRoomViewController *next = [[LJSelectRoomViewController alloc] init];
                next.delegate = self;
                next.isConsumption = NO;
                next.navColor = NavBackColor;
                next.titleString = @"选择房间";
                next.view.backgroundColor = WhiteColor;
                [self.tabBarController.tabBar removeFromSuperview];
                [(ShoppingMallTabBarViewController *)self.tabBarController hideTabBar:YES];
                
                [self.navigationController pushViewController:next animated:YES];
                
            }
            break;
        }
        case 1:// 删除
        {
            // Delete button was pressed
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除该条接待单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            av.tag = 2000;
            [av show];
            delIndexPath = [myTableView indexPathForCell:cell];
            break;
        }
        default:
            break;
    }
}

- (void)sendRoom:(LJRoomModel *)room {
    // 转消费单
    LJConsumptionListModel *entity = [self.dataList objectAtIndex:delIndexPath.row];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
    
    if (room.roomCd.length) {
        [dic setValue:room.roomCd forKey:@"roomCd"];
    }
    if (entity.orderCd.length) {
        [dic setValue:entity.orderCd forKey:@"orderCd"];
    }

    NSLog(@"dic = %@", dic);
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:JIEDAIXIAOFEIALL parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        if (ISSUCCESS) {
            [self loadData];
        } else {
            if ([OBJMESSAGE isEqualToString:@"error_sex"]) {
                SHOWTEXTINWINDOW(@"性别不能为空", 1);
            } else if ([OBJMESSAGE isEqualToString:@"error_sofa"]) {
                SHOWTEXTINWINDOW(@"房间沙发数量不足", 1);
            } else if ([OBJMESSAGE isEqualToString:@"error_project"]) {
                SHOWTEXTINWINDOW(@"项目不能为空", 1);
            }  else if ([OBJMESSAGE isEqualToString:@"error_waiting"]) {
                 SHOWTEXTINWINDOW(@"多人项目只能选择空闲技师", 1);
            } else {
                BADREQUEST
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2000) {
        if (buttonIndex == 1) {
            
            LJConsumptionListModel *entity = [self.dataList objectAtIndex:delIndexPath.row];
            SHOWSTATUSCLEAR
            if (entity.orderCd.length) {
                [[NetWorkingModel sharedInstance] POST:RECEPTIONORDERHEADERDELETE parameters:@{@"orderCd":entity.orderCd, @"userId":[userDefaults objectForKey:USERID]} success:^(AFHTTPRequestOperation *operation, id obj) {
                    DISMISS
                    if (ISSUCCESS) {
                        SHOWTEXTINWINDOW(@"删除成功", 1);
                        [myTableView.mj_header beginRefreshing];
                    } else if ([OBJMESSAGE isEqualToString:@"error_Noauthority"]) {
                        SHOWTEXTSELFVIEW(@"没有权限", 1);
                    }  else {
                        BADREQUEST
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                }];
            }
        }
    } else if (alertView.tag == 2001) {
        if (buttonIndex == 1) {
            
            LJConsumptionListModel *entity = [self.dataList objectAtIndex:delIndexPath.row];
            SHOWSTATUSCLEAR
            if (entity.orderCd.length) {
                [[NetWorkingModel sharedInstance] POST:XIAOFEILISTELETE parameters:@{@"orderCd":entity.orderCd, @"userId":[userDefaults objectForKey:USERID]} success:^(AFHTTPRequestOperation *operation, id obj) {
                    DISMISS
                    if (ISSUCCESS) {
                        SHOWTEXTINWINDOW(@"删除成功", 1);
                        [myTableView.mj_header beginRefreshing];
                    } else {
                        if ([OBJMESSAGE isEqualToString:@"error_deleted"]) {
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                            hud.mode = MBProgressHUDModeText;
                            hud.labelText = @"上钟、落钟的明细不能删除";
                            [hud hide:YES afterDelay:1];
                            
                        } else if ([OBJMESSAGE isEqualToString:@"error_Noauthority"]) {
                            SHOWTEXTSELFVIEW(@"没有权限", 1);
                        } else {
                            BADREQUEST
                        }
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                }];
            }
        }
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

-(void)leftButton2Pressed {
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:BUSINESSDATE parameters:@{} success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", jsonString);
        
        if (ISSUCCESS) {
            NSString *dateStr = [CONTENTOBJ objectForKey:@"BusinessDate"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
            df.dateFormat = @"YYYY-MM-dd";
            NSDate *date = [df dateFromString:dateStr];
            date = [self getNowDateFromatAnDate:date];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            
            NSDate *nowDate = [NSDate date];
            
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nowDate];
            nowDate = [calendar dateFromComponents:components];
            nowDate = [self getNowDateFromatAnDate:nowDate];
            
            NSLog(@"date = %@, nowdate = %@", date, nowDate);
            NSTimeInterval business = [date timeIntervalSince1970];
            NSTimeInterval now = [nowDate timeIntervalSince1970];
            
            if (business > now) {
                //NSLog(@"Date1  is in the future");
                NSLog(@"大");
            } else if (business < now){
                //NSLog(@"Date1 is in the past");
                NSLog(@"小");
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
                NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
                int hour = (int) [dateComponent hour];
                if (hour >= 7) {
                    SHOWTEXTINWINDOW(@"还未日结，请日结后开单", 1);
                    return ;
                }
            } else  {
                NSLog(@"相等");
            }
            LJAddClientViewController *addClientViewController = [[LJAddClientViewController alloc] init];
            [self.tabBarController.tabBar removeFromSuperview];
            [(ShoppingMallTabBarViewController *)self.tabBarController hideTabBar:YES];
            [self.navigationController pushViewController:addClientViewController animated:YES];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DISMISS
        SHOWTEXTINWINDOW(@"获取营业日失败", 1);
        
    }];
}

- (void)leftButtonPressed {
    if (isConsumption) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
    
    
}

- (void)rightButtonPressed {
    
    if (mySearchBar.hidden) {
        mySearchBar.hidden = NO;
        [topView.rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [topView.rightButton setTitle:@"取消" forState:UIControlStateNormal];
        
        myTableView.mj_header = nil;
        
    } else {
//        搜索
        myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadData];
        }];
        
        self.keyWords = [mySearchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        mySearchBar.hidden = YES;
        [mySearchBar endEditing:YES];
        
        [topView.rightButton setImage:[UIImage imageNamed:@"icon_Search_bg color"] forState:UIControlStateNormal];
        [topView.rightButton setTitle:@"" forState:UIControlStateNormal];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSString *text = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (text.length) {
        if (self.searchData) {
            [self.searchData removeAllObjects];
        } else {
            self.searchData = [NSMutableArray array];
        }
        for (LJConsumptionListModel *entity in self.dataList) {
            if ([entity.salemanCd containsString:searchText] || [entity.salemanName containsString:searchText] || [entity.orderCd.uppercaseString containsString:searchText.uppercaseString		]) {
                [self.searchData addObject:entity];
            }
        }
        [myTableView reloadData];
        [myTableView reloadData];
    } else {
        self.searchData = [NSMutableArray arrayWithArray:self.dataList];
        [myTableView reloadData];
    }
}


- (void)selectedMenu:(NSInteger)page {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
