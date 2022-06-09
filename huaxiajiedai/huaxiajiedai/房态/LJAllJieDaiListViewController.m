//
//  LJAllJieDaiListViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/10/8.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJAllJieDaiListViewController.h"

@interface LJAllJieDaiListViewController ()

@end

@implementation LJAllJieDaiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = gray238;
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    
    [_tableView.mj_header beginRefreshing];
}


#pragma mark UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LJAllJieDaiModel *entity = [_dataList objectAtIndex:section];
    if (entity.isChoosed) {
        return entity.room.count;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    LJAllJieDaiModel *entity = [_dataList objectAtIndex:section];
    
    NSString *imageUrl = @"right_arrow_64px_1205479_easyicon.net@2x";
    if (entity.isChoosed) {
        imageUrl = @"down_arrow_64px_1205405_easyicon.net@2x";
    }
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageUrl]];
    leftImageView.tag = section + 1000;
    [headerView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(10);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, kappScreenWidth, 40);
    button.tag=section;
    [button addTarget:self action:@selector(clickTheGroup:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kappScreenWidth * 0.6, 40)];
    [button addSubview:nameLabel];
    nameLabel.font = SYSTEMFONT(15);
    nameLabel.text = entity.name;

    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.font = SYSTEMFONT(15);
    [button addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(button).offset(-25);
        make.top.equalTo(button);
        make.bottom.equalTo(button);
    }];
    
    countLabel.text = [NSString stringWithFormat:@"共计:%@", entity.total];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
       LJAllJieDaiModel *entity = [_dataList objectAtIndex:indexPath.section];
        NSDictionary *dic = [entity.room objectAtIndex:indexPath.row];
        
        UILabel *roomNameLabel = [[UILabel alloc] init];
        
        [cell addSubview:roomNameLabel];
        [roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(40);
            make.height.mas_equalTo(44);
            make.top.equalTo(cell);
        }];
        roomNameLabel.textColor = gray70;
        roomNameLabel.text = [dic objectForKey:@"roomName"];
        roomNameLabel.tag = 1010;
        roomNameLabel.font = SYSTEMFONT(15);
        
        
        UILabel *countLabel = [[UILabel alloc] init];
        [cell addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-25);
            make.height.mas_equalTo(44);
            make.top.equalTo(cell).offset(0);
        }];
        countLabel.textColor = gray80;
        countLabel.text = [NSString stringWithFormat:@"开单数:%@", [dic objectForKey:@"roomCount"]];
        countLabel.tag = 1011;
        countLabel.font = SYSTEMFONT(14);
        
    }
    
    return cell;

}


- (CGFloat ) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

#pragma mark CustomTopNavigationViewDelegate
- (void)leftButtonPressed {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark CustumMethod
- (void) loadData {
    [[NetWorkingModel sharedInstance] GET:empLIst parameters:@{@"storeCd":STORCDSTRING} success:^(AFHTTPRequestOperation *operation, id obj) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        
        if (ISSUCCESS) {
            [self.dataList removeAllObjects];
            for (NSDictionary *dic in CONTENTOBJ) {
                LJAllJieDaiModel *entity = [[LJAllJieDaiModel alloc] init];
                [entity setValuesForKeysWithDictionary:dic];
                [_dataList addObject:entity];
            }
            
            [_tableView reloadData];
        } else {
            [_dataList removeAllObjects];
            [_tableView reloadData];
        }
        
        [_tableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_dataList removeAllObjects];
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
    }];
}

- (void) clickTheGroup:(UIButton *) sender {
    if (sender.tag < _dataList.count) {
        LJAllJieDaiModel *entity = [_dataList objectAtIndex:sender.tag];
        
        entity.isChoosed = !entity.isChoosed;
        [_tableView reloadData];
    }
}

#pragma mark getter & setter
- (CustomTopNavigationView *)topView {
    if (_topView == nil) {
        _topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
        _topView.delegate = self;
        _topView.titleLabel.adjustsFontSizeToFitWidth = YES;
        _topView.titleLabel.text = @"所有接待部长的开单状况";
        [self.view addSubview:_topView];
        [_topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    }
    
    return _topView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.view);
//            make.right.equalTo(self.view);
//            make.bottom.equalTo(self.view);
//            make.top.equalTo(_topView.mas_bottom).offset(0);
//        }];
        
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadData];
        }];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
        
    }
    
    return _dataList;
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
