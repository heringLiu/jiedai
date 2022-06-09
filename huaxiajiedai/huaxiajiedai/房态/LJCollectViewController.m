//
//  LJCollectViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/9/27.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJCollectViewController.h"

@interface LJCollectViewController () {
    NSMutableArray *nameArr;
    NSMutableArray *employeeIdArr;
    NSString *employeeId;
    LJNornalView *employeeView;
    
    NSMutableArray *emArr;
}

@end

@implementation LJCollectViewController
@synthesize topView, dataList, myControl, pickView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    nameArr = [NSMutableArray array];
    employeeIdArr = [NSMutableArray array];
    employeeId = [userDefaults objectForKey:UUID];
    [self getEmpLIst];
    
    employeeView = [[LJNornalView alloc] initWithTitleName:@"查询所有接待部长的开单状况"];
    employeeView.delegaete = self;
    employeeView.titleLabel.font = SYSTEMFONT(13);
    [self.view addSubview:employeeView];
    [employeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kTopScreenWidth);
        make.height.mas_equalTo(40);
    }];
    employeeView.bottomLine.hidden = YES;
    
    
    dataList = [NSMutableArray array];
    self.view.backgroundColor = gray238;
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    topView.delegate = self;
    topView.titleLabel.text = @"开单明细";
    [self.view addSubview:topView];
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    UIView *fBackView = [[UIView alloc] init];
    [self.view addSubview:fBackView];
    UILabel *fLabel = [[UILabel alloc] init];
    [fBackView addSubview:fLabel];
    [fLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fBackView).offset(6);
        make.left.equalTo(fBackView).offset(20);
        make.right.equalTo(fBackView).offset(20);
        make.height.mas_equalTo(SYSTEMFONT(13).lineHeight);
    }];
    fLabel.font = SYSTEMFONT(13);
    fLabel.text = @"开单明细查询";
    fLabel.textColor = gray70;
    
    UILabel *sLabel = [[UILabel alloc] init];
    [fBackView addSubview:sLabel];
    [sLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fLabel.mas_bottom).offset(5);
        make.left.equalTo(fBackView).offset(20);
        make.right.equalTo(fBackView).offset(20);
        make.height.mas_equalTo(SYSTEMFONT(12).lineHeight);
    }];
    sLabel.text = @"开单总数";
    sLabel.tag = 1000;
    sLabel.textColor = gray104;
    sLabel.font = SYSTEMFONT(12);
    
    UILabel *tLabel = [[UILabel alloc] init];
    [fBackView addSubview:tLabel];
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sLabel.mas_bottom).offset(5);
        make.left.equalTo(fBackView).offset(20);
        make.right.equalTo(fBackView).offset(20);
        make.height.mas_equalTo(SYSTEMFONT(12).lineHeight);
    }];
    tLabel.text = @"总金额";
    tLabel.tag = 1001;
    tLabel.textColor = gray104;
    tLabel.font = SYSTEMFONT(12);
    [fBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(topView.mas_bottom).offset(50);
        make.right.equalTo(self.view);
        make.bottom.equalTo(tLabel.mas_bottom).offset(6);
    }];
    
    fBackView.backgroundColor = WhiteColor;
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(fBackView.mas_bottom).offset(10);
    }];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];

    myControl = [[UIControl alloc] init];
    myControl.frame = CGRectMake(0, 0, kappScreenWidth, kappScreenHeight);
    myControl.backgroundColor = [UIColor blackColor];
    myControl.alpha = 0.4;
    [myControl addTarget:self action:@selector(closePickView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myControl];
    myControl.hidden = YES;
    
    pickView = [[LJPickerView alloc] init];
    pickView.delegate = self;
    pickView.frame = CGRectMake(0, kappScreenHeight, kappScreenWidth, 260);
    [self.view addSubview:pickView];
    pickView.backgroundColor = WhiteColor;
    
    [self.tableView.mj_header beginRefreshing];
}

- (void) getEmpLIst {
    
}

- (void)tapView:(UIView *)tapView {
//    if (nameArr.count) {
//        [self showPickViewWithData:nameArr];
//    }
    LJAllJieDaiListViewController *next = [[LJAllJieDaiListViewController alloc] init];
    [self presentViewController:next animated:YES completion:^{
        
    }];
}

- (void)closePickView {
    [self pickViewDone];
}

- (void)selectedDone:(NSInteger)index {
//    [gridView selectedDone:index];
    employeeView.titleLabel.text = [nameArr objectAtIndex:index];
    employeeId = [employeeIdArr objectAtIndex:index];
}


- (void)pickViewDone {
    [self loadData];
    [UIView animateWithDuration:0.3 animations:^{
        myControl.hidden = YES;
        pickView.frame = CGRectMake(0, kappScreenHeight, kappScreenWidth, 260);
    }];
    
}

- (void) showPickViewWithData:(NSMutableArray *) datas {
    pickView.datas = datas;
    [UIView animateWithDuration:0.3 animations:^{
        myControl.hidden = NO;
        pickView.frame = CGRectMake(0, kappScreenHeight - 260, kappScreenWidth, 260);
    }];
}

- (void) loadData {
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] GET:countConsumeTable parameters:@{@"userId":employeeId} success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", jsonString);
        if (ISSUCCESS) {
            self.dataList = [NSMutableArray arrayWithArray:[CONTENTOBJ objectForKey:@"detail"]];
            NSString *countStr = [[CONTENTOBJ objectForKey:@"map"] objectForKey:@"COUNT"];
            NSString *amountStr = [[CONTENTOBJ objectForKey:@"map"] objectForKey:@"CONSUME_AMT"];
            
            UILabel *countLabel = (UILabel *)[self.view viewWithTag:1000];
            countLabel.text = [NSString stringWithFormat:@"开单总数: %@", countStr];
            
            UILabel *amountLabel = (UILabel *)[self.view viewWithTag:1001];
            amountLabel.text = [NSString stringWithFormat:@"总金额: ￥%.2f", amountStr.length ? [amountStr doubleValue] : 0.00];
            if (self.dataList.count) {
                [self.tableView reloadData];
            } else {
                SHOWTEXTINWINDOW(@"您今天没有开单", 1.5);
                [self.dataList removeAllObjects];
                [self.tableView reloadData];
            }
            
            
        } else {
            BADREQUEST
            [self.dataList removeAllObjects];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.dataList removeAllObjects];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}


- (void)leftButtonPressed {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UILabel *customCDLabel = [[UILabel alloc] init];
        [cell addSubview:customCDLabel];
        [customCDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(20);
            make.height.mas_equalTo(SYSTEMFONT(13).lineHeight);
            make.top.equalTo(cell).offset(6);
        }];
        customCDLabel.textColor = gray70;
        customCDLabel.text = @"消费单号：";
        customCDLabel.tag = 1010;
        customCDLabel.font = SYSTEMFONT(13);
        
        
        UILabel *projectNameLabel = [[UILabel alloc] init];
        [cell addSubview:projectNameLabel];
        [projectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(20);
            make.height.mas_equalTo(SYSTEMFONT(12).lineHeight);
            make.top.equalTo(customCDLabel.mas_bottom).offset(5);
        }];
        projectNameLabel.textColor = gray80;
        projectNameLabel.text = @"项目名称：";
        projectNameLabel.tag = 1011;
        projectNameLabel.font = SYSTEMFONT(12);
        
        UILabel *textLabel = [[UILabel alloc] init];
        [cell addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-40 * kappScreenWidth / 320.0f);
            make.height.mas_equalTo(SYSTEMFONT(12).lineHeight);
            make.top.equalTo(customCDLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(SYSTEMFONT(12).pointSize * 5.5);
        }];
        textLabel.textColor = gray104;
        textLabel.text = @"消费单状态:";
        textLabel.tag = 1016;
        textLabel.font = SYSTEMFONT(12);
        
        UILabel *serveStatusLabel = [[UILabel alloc] init];
        [cell addSubview:serveStatusLabel];
        [serveStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textLabel.mas_right).offset(0);
            make.height.mas_equalTo(SYSTEMFONT(12).lineHeight);
            make.top.equalTo(customCDLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(SYSTEMFONT(12).pointSize * 3);
        }];
        serveStatusLabel.textColor = gray104;
        serveStatusLabel.text = @"";
        serveStatusLabel.tag = 1013;
        serveStatusLabel.font = SYSTEMFONT(12);
        
        UILabel *roomNameLabel = [[UILabel alloc] init];
        [cell addSubview:roomNameLabel];
        [roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(20);
            make.height.mas_equalTo(SYSTEMFONT(12).lineHeight);
            make.top.equalTo(projectNameLabel.mas_bottom).offset(5);
        }];
        roomNameLabel.textColor = gray104;
        roomNameLabel.text = @"房间名称：";
        roomNameLabel.tag = 1012;
        roomNameLabel.font = SYSTEMFONT(12);
        
        UILabel *moneyLabel = [[UILabel alloc] init];
        [cell addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textLabel).offset(0);
            make.height.mas_equalTo(SYSTEMFONT(12).lineHeight);
            make.top.equalTo(textLabel.mas_bottom).offset(5);
        }];
        moneyLabel.textColor = gray104;
        moneyLabel.text = @"开单金额：";
        moneyLabel.tag = 1014;
        moneyLabel.font = SYSTEMFONT(12);
        
        UILabel *timeLabel = [[UILabel alloc] init];
        [cell addSubview:timeLabel];
//        CGSize size1 = [@":2016-09-28 10:44:25" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(12),NSFontAttributeName,nil]];
//        CGSize size2 = [@"开单时间" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(12),NSFontAttributeName,nil]];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(20);
            make.height.mas_equalTo(SYSTEMFONT(12).lineHeight);
            make.top.equalTo(roomNameLabel.mas_bottom).offset(5);
//            make.width.mas_equalTo(SYSTEMFONT(12).pointSize * 4);
        }];
        timeLabel.textColor = gray104;
        timeLabel.text = @"开单时间:";
        timeLabel.tag = 1015;
        timeLabel.font = SYSTEMFONT(12);
        
        
        
    }
    
    UILabel *customCDLabel = (UILabel *)[cell viewWithTag:1010];
    UILabel *projectNameLabel = (UILabel *)[cell viewWithTag:1011];
    UILabel *roomNameLabel = (UILabel *)[cell viewWithTag:1012];
    UILabel *textLabel = (UILabel *)[cell viewWithTag:1013];
    UILabel *moneyLabel = (UILabel *)[cell viewWithTag:1014];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:1015];
//    UILabel *textLabel2 = (UILabel *)[cell viewWithTag:1016];
    
    NSDictionary *dic = [self.dataList objectAtIndex:indexPath.row];
    
    NSString *serveStatus = [dic objectForKey:@"serveStatus"];
    
    if ([serveStatus isEqualToString:@"overdue"]) {
        serveStatus = @"未到";
        textLabel.textColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1];
    } else if ([serveStatus isEqualToString:@"uptime"]) {
        serveStatus = @"上钟";
        textLabel.textColor = [UIColor colorWithRed:93/255.0f green:156/255.0f blue:236/255.0f alpha:1];
    } else if ([serveStatus isEqualToString:@"suspend"]) {
        serveStatus = @"暂停";
        textLabel.textColor = [UIColor colorWithRed:255/255.0f green:155/255.0f blue:155/255.0f alpha:1];
    } else if ([serveStatus isEqualToString:@"wait"]) {
        serveStatus = @"等待";
        textLabel.textColor = [UIColor colorWithRed:248/255.0f green:178/255.0f blue:77/255.0f alpha:1];
    } else if ([serveStatus isEqualToString:@"downtime"]) {
        serveStatus = @"下钟";
        textLabel.textColor = [UIColor colorWithRed:151/255.0f green:227/255.0f blue:153/255.0f alpha:1];
    } else {
        serveStatus = @"";
    }
    
    NSString *amountStr = [dic objectForKey:@"consumeAmt"];
    NSString *projectStr = [dic objectForKey:@"projectName"];
    NSString *roomNameStr = [dic objectForKey:@"roomName"];
    
    customCDLabel.text = [NSString stringWithFormat:@"消费单号:%@", [dic objectForKey:@"orderCd"]];
    projectNameLabel.text = [NSString stringWithFormat:@"项目名称:%@", projectStr.length ? projectStr : @""];
    roomNameLabel.text = [NSString stringWithFormat:@"房间名称:%@", roomNameStr.length ? roomNameStr : @""];
    textLabel.text = serveStatus;
    moneyLabel.text = [NSString stringWithFormat:@"开单金额:%.2f", amountStr.length ? [amountStr doubleValue] : 0.00];
    timeLabel.text = [NSString stringWithFormat:@"开单时间:%@", [dic objectForKey:@"createDate"]];
    
    [dic allKeys];
    
    
//    [textLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(timeLabel).offset(0);
//        make.height.mas_equalTo(SYSTEMFONT(12).lineHeight);
//        make.top.equalTo(customCDLabel.mas_bottom).offset(5);
//        make.right.equalTo(cell).offset(-20);
//    }];
    
    return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 27 + SYSTEMFONT(13).lineHeight + SYSTEMFONT(12).lineHeight*3;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
