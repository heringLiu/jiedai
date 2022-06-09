//
//  LJProjectListViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/5/9.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJProjectListViewController.h"

@interface LJProjectListViewController ()

@end

@implementation LJProjectListViewController
@synthesize topView, myTableView, dataList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = gray238;
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    topView.delegate = self;
    topView.backgroundColor = navLightBrownColor;
    [self.view addSubview:topView];
    topView.titleLabel.text = @"技师状态";
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    
    dataList = [NSMutableArray array];
    
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth) style:UITableViewStyleGrouped];
    [self.view addSubview:myTableView];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[LJPListTableViewCell class] forCellReuseIdentifier:@"Cell"];
    myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [myTableView.mj_header beginRefreshing];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return self.thDatas.count;
    } else {
        return self.cusDatas.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section) {
        return @"技师信息";
    } else {
        return @"等待客户信息";
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJPListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (indexPath.section) {
        [cell setDataWithT:[self.thDatas objectAtIndex:indexPath.row]];
    } else {
        [cell setDataWithC:[self.cusDatas objectAtIndex:indexPath.row]];
    }
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)leftButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadData {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.entity.orderCd.length) {
        [dic setValue:self.entity.orderCd forKey:@"orderCd"];
    }
    if (self.entity.customerCd.length) {
        [dic setValue:self.entity.customerCd forKey:@"customerCd"];
    }
    if (self.entity.projectCd.length) {
        [dic setValue:self.entity.projectCd forKey:@"projectCd"];
    }
    if (self.entity.detailNo.length) {
        [dic setValue:self.entity.detailNo forKey:@"detailNo"];
    }
    
    NSLog(@"dic = %@", dic);
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:XIAOFEIWORKLIST parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        DISMISS
        if (ISSUCCESS) {
            if (self.cusDatas) {
                [self.cusDatas removeAllObjects];
            } else {
                self.cusDatas = [NSMutableArray array];
            }
            if (self.thDatas) {
                [self.thDatas removeAllObjects];
            } else {
                self.thDatas = [NSMutableArray array];
            }
            
            for (NSDictionary *dic in [CONTENTOBJ objectForKey:@"DetailTabs"]) {
                LJReceptionDetailModel *entity = [[LJReceptionDetailModel alloc] init];
                [entity setValuesForKeysWithDictionary:dic];
                [self.cusDatas addObject:entity];
            }
            for (NSDictionary *dic in [CONTENTOBJ objectForKey:@"artificer"]) {
                LJPListTModel *entity = [[LJPListTModel alloc] init];
                [entity setValuesForKeysWithDictionary:dic];
                [self.thDatas addObject:entity];
            }
            [myTableView reloadData];
        }
        
        [myTableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [myTableView.mj_header endRefreshing];
    }];
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
