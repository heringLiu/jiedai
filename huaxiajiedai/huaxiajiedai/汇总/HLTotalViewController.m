//
//  HLTotalViewController.m
//  huaxiajishi
//
//  Created by gjhgj on 2017/9/21.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "HLTotalViewController.h"

@interface HLTotalViewController () {
    NSMutableArray *_mutArr;
}

@end

@implementation HLTotalViewController
@synthesize topView,myTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = gray238;
    
    _mutArr = [NSMutableArray arrayWithCapacity:5];
    [_mutArr addObject:@{@"listName":@"做活数", @"listValue":[NSNumber numberWithInteger:0],@"listImageName":@"work"}];
    [_mutArr addObject:@{@"listName":@"点钟数", @"listValue":[NSNumber numberWithInteger:0],@"listImageName":@"select"}];
    [_mutArr addObject:@{@"listName":@"开卡充值次数", @"listValue":[NSNumber numberWithInteger:0],@"listImageName":@"card"}];
    [_mutArr addObject:@{@"listName":@"套票销售次数", @"listValue":[NSNumber numberWithInteger:0],@"listImageName":@"ticket"}];
    [_mutArr addObject:@{@"listName":@"套盒销售次数", @"listValue":[NSNumber numberWithInteger:0],@"listImageName":@"box"}];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    topView.delegate = self;
    [self.view addSubview:topView];
    topView.titleLabel.text = @"做活和销售统计";
    topView.backgroundColor = navLightBrownColor ;
    //    topView.rightButton.hidden = YES;
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
//    topView.leftButton.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    [topView.rightButton setImage:[UIImage imageNamed:@"search3"] forState:UIControlStateNormal];
//    topView.rightButton.imageEdgeInsets = UIEdgeInsetsMake(7, 20, 7, 7);
//    topView.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth + 20, kMainScreenWidth, kMainScreenHeight - kTopScreenWidth - 20)];
    myTableView.backgroundColor = gray238;
    myTableView.scrollEnabled = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [myTableView registerClass:[HLTotalTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    interval = 0;
    
    NSDate *nowDate = [date dateByAddingTimeInterval: interval];
    
    NSLog(@"nowdate   %@", nowDate);
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"YYYY-MM-dd";

    self.startStr = @"";
    self.endStr = @"";
//    self.startStr = [df stringFromDate:nowDate];
//    self.endStr = [df stringFromDate:nowDate];
    
    [self loadNew];
    
    
    self.searchView = [[HLSearchView alloc] initWithFrame:CGRectMake(0, -230, kMainScreenWidth, 230)];
    
    self.searchView.delegate = self;
    [self.view addSubview:self.searchView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLTotalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    for (UIView *sub in cell.subviews) {
        [sub removeFromSuperview];
    }
    
    [cell setCellWithDic:[_mutArr objectAtIndex:indexPath.row]];
    
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HLWorksViewController *worksViewController = [[HLWorksViewController alloc] init];
    NSDictionary *dic = [_mutArr objectAtIndex:indexPath.row];
    NSString *type = [dic objectForKey:@"listImageName"];
    worksViewController.type = type;
    worksViewController.frontTitle = self.frontTitle;
    worksViewController.startDate = self.startStr;
    worksViewController.endDate = self.endStr;
    [self.navigationController pushViewController:worksViewController animated:YES];
}

- (void) sendRestTime:(NSDictionary *)restData {
    // 接收剩余时间
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(void) loadNew {
    NSLog(@"=========%@============%@", self.searchView.endDateText.currentTitle, self.searchView.startDateText.currentTitle);
    if (self.searchView.startStr.length && self.searchView.endStr.length && ![self.searchView.endDateText.currentTitle isEqualToString:@"选择结束营业日"]) {
        self.frontTitle = [NSString stringWithFormat:@"%@至%@", self.searchView.startStr, self.searchView.endStr];
        topView.titleLabel.text = [NSString stringWithFormat:@"%@至%@做活和销售统计", self.searchView.startStr, self.searchView.endStr];
        NSLog(@"%@至%@", self.searchView.startStr, self.searchView.endStr);
    } else if (self.searchView.startStr.length && [self.searchView.endDateText.titleLabel.text isEqualToString:@"选择结束营业日"]) {
        self.frontTitle = [NSString stringWithFormat:@"%@至上个营业日", self.searchView.startStr];
        topView.titleLabel.text = [NSString stringWithFormat:@"%@至上个营业日做活和销售统计", self.searchView.startStr];
        NSLog(@"%@至上个营业日", self.searchView.startStr);
    } else {
        self.frontTitle = @"当前营业日";
        topView.titleLabel.text = @"当前营业日做活和销售统计";
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[userDefaults objectForKey:USERID] forKey:@"artificerCd"];
    [dic setObject:self.startStr forKey:@"startTime"];
    [dic setObject:self.endStr forKey:@"endTime"];
    
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:TOTALLIST parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        if (ISSUCCESS) {
            _mutArr = [NSMutableArray arrayWithCapacity:5];
            
            if ([CONTENTOBJ isKindOfClass:[NSArray class]] && [CONTENTOBJ count] > 0) {
                NSDictionary *dic = [CONTENTOBJ firstObject];
                ;
//                [_mutArr addObject:@{@"listName":@"做活数", @"listValue":[NSString stringWithFormat:@"%ld", [[dic objectForKey:@"workQty"] integerValue]],@"listImageName":@"work"}];
//                [_mutArr addObject:@{@"listName":@"点钟数", @"listValue":[NSString stringWithFormat:@"%ld", [[dic objectForKey:@"selectQty"] integerValue]],@"listImageName":@"select"}];
                [_mutArr addObject:@{@"listName":@"开卡充值次数", @"listValue":[NSString stringWithFormat:@"%ld", [[dic objectForKey:@"cardSaleQty"] integerValue]],@"listImageName":@"card"}];
                [_mutArr addObject:@{@"listName":@"套票销售次数", @"listValue":[NSString stringWithFormat:@"%ld", [[dic objectForKey:@"ticketSaleQty"] integerValue]],@"listImageName":@"ticket"}];
                [_mutArr addObject:@{@"listName":@"套盒销售次数", @"listValue":[NSString stringWithFormat:@"%ld", [[dic objectForKey:@"boxSaleQty"] integerValue]],@"listImageName":@"box"}];
                [myTableView reloadData];
            }
            
//            [CONTENTOBJ objectForKey:@"workAmt"];
            
        } else {
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DISMISS
    }];

}

- (void)beginSearchWithStart:(NSString *)startStr end:(NSString *)endStr {
    self.startStr = startStr;
    self.endStr = endStr;
    [UIView animateWithDuration:0.3 animations:^{
        self.searchView.frame = CGRectMake(0, -230, kMainScreenWidth, 230);
        [self.searchView hideCon];
    }];
    [self loadNew];
    
}

-(void)leftButtonPressed {
    [self.searchView hideCon];
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)rightButtonPressed {
    if (self.searchView.frame.origin.y < 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.searchView.frame = CGRectMake(0, kTopScreenWidth, kMainScreenWidth, 230);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.searchView.frame = CGRectMake(0, -230, kMainScreenWidth, 230);
        }];
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
