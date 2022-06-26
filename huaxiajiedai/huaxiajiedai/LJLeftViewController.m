//
//  LJLeftViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/5/25.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJLeftViewController.h"
#import "LJIPSettingViewController.h"
#import "LJLoginViewController.h"

@interface LJLeftViewController ()


@end

@implementation LJLeftViewController
@synthesize myTableView, topView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = WhiteColor;
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth * 0.8, kTopScreenWidth)];
    topView.titleLabel.text = @"设置";
    [self.view addSubview:topView];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kappScreenWidth * 0.8, kappScreenHeight - kTopScreenWidth) style:UITableViewStylePlain];
    [self.view addSubview:myTableView];
    myTableView.backgroundColor = WhiteColor;
    
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UILabel *label = [[UILabel alloc] init];
        label.tag = 1000;
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(40);
            make.right.equalTo(cell);
            make.top.equalTo(cell);
            make.bottom.equalTo(cell);
        }];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    if (indexPath.row == 0) {
        label.text = @"退出登录";
    } else if (indexPath.row == 1) {
        label.text = @"退出登录";
    }
    cell.backgroundColor = WhiteColor;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    LJIPSettingViewController *ipViewController = [[LJIPSettingViewController alloc] init];
//    [self presentViewController:ipViewController animated:YES completion:^{
//        
//    }];
    
    [userDefaults setObject:@"" forKey:ISLOGIN];
    LJLoginViewController *login = [LJLoginViewController shareLogin];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    login.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:login animated:YES completion:^{
        
    }];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
