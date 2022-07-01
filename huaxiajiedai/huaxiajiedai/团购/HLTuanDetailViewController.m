//
//  HLTuanDetailViewController.m
//  huaxiajiedai
//
//  Created by 刘慧林 on 2022/6/26.
//  Copyright © 2022 LJ. All rights reserved.
//

#import "HLTuanDetailViewController.h"

@interface HLTuanDetailViewController () {
    UILabel *groupLabel;
    UILabel *phoneNumLabel;
    UILabel * groupCdLabel;
    UILabel * groupCashLabel;
    UILabel * custmoerOrignLabel;
    UILabel *groupTypeLabel;
    UILabel *groupFCashLabel;
    UILabel *groupUsedLabel;
    UILabel *custmoerCountLabel;
    UIButton *sendButton;
}

@end

@implementation HLTuanDetailViewController
@synthesize topView, mySearchBar, topInfoView, myTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:WhiteColor];
    // Do any additional setup after loading the view.
    
    self.dataList = [[NSMutableArray alloc] init];
    
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    topView.delegate = self;
    [self.view addSubview:topView];
    topView.titleLabel.text = @"";
    topView.backgroundColor =  navLightBrownColor;
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    [topView.rightButton setImage:[UIImage imageNamed:@"saoyi_sao"] forState:UIControlStateNormal];
    topView.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    topView.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40.0f, kSafeHeight ? kSafeHeight + 10.0f : 20.0f, kappScreenWidth - 80.0f, 40.0f)];
    //    searchBar.
    [topView addSubview:mySearchBar];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"请输入团购码";
    //    searchBar.tintColor = LightBrownColor;
    mySearchBar.showsCancelButton = YES;
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
//    mySearchBar.hidden = YES;
    
    [self createTopInfo];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:sendButton];
    CGFloat btnBottom = 10.0f;
    if ([[UIApplication sharedApplication] statusBarFrame].size.height >= 44) {
        btnBottom = 44.0f;
    }
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-btnBottom);
        make.height.mas_equalTo(50);
    }];

    sendButton.layer.cornerRadius = 5;
    sendButton.layer.masksToBounds = YES;
    [sendButton setTitle:@"转消费单" forState:UIControlStateNormal];
    [sendButton setBackgroundColor:LightBrownColor];
    [sendButton addTarget:self action:@selector(sendConsump) forControlEvents:UIControlEventTouchUpInside];
    
    myTableView = [[UITableView alloc] init];
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(topInfoView.mas_bottom);
        make.bottom.equalTo(sendButton.mas_top);
        make.right.equalTo(self.view);
    }];
//    [myTableView setBackgroundColor:[UIColor blueColor]];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [myTableView reloadData];
    if (@available(iOS 15.0, *)) {
        myTableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }

    [topInfoView setHidden:YES];
    [myTableView setHidden:YES];
    [sendButton setHidden:YES];
}

- (void) sendConsump {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self.roomCd forKey:@"roomCd"];
    [dic setValue:NULL forKey:@"orderCd"];
    [dic setValue:[userDefaults objectForKey:UUID] forKey:@"userId"];
    [dic setValue:[userDefaults objectForKey:UUID] forKey:@"saleManCd"];
   
    [dic setValue:self.dataDic forKey:@"groupDetail"];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
//    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[NetWorkingModel sharedInstance] POST:GROUPCONSUMP parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
        if (ISSUCCESS) {
            SHOWTEXTINWINDOW(@"转单成功", 1.5);
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            SHOWTEXTINWINDOW(OBJMESSAGE, 1.5);
        }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
}

- (void) createTopInfo {
    topInfoView = [[UIView alloc] init];
    [self.view addSubview:topInfoView];
    [topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(155);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    [self.topInfoView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topInfoView);
        make.right.equalTo(topInfoView);
        make.bottom.equalTo(topInfoView);
        make.height.mas_equalTo(10);
    }];
    [bottomView setBackgroundColor:gray238];
    
    groupLabel = [[UILabel alloc] init];
    [topInfoView addSubview:groupLabel];
    [groupLabel setText:@"团购信息"];
    [groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topInfoView).offset(10);
        make.top.equalTo(topInfoView).offset(10);
        make.height.mas_equalTo(25);
    
    }];
    [groupLabel setFont:FONT15];
    
    phoneNumLabel = [[UILabel alloc] init];
    [topInfoView addSubview:phoneNumLabel];
    [phoneNumLabel setText:@"电话号码："];
    [phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topInfoView).offset(10);
        make.top.equalTo(groupLabel.mas_bottom);
        make.height.mas_equalTo(25);
    
    }];
    [phoneNumLabel setFont:FONT14];
    
    groupCdLabel = [[UILabel alloc] init];
    [topInfoView addSubview:groupCdLabel];
    [groupCdLabel setText:@"订单编号："];
    [groupCdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topInfoView).offset(10);
        make.top.equalTo(phoneNumLabel.mas_bottom);
        make.height.mas_equalTo(25);
    
    }];
    [groupCdLabel setFont:FONT14];

    groupCashLabel = [[UILabel alloc] init];
    [topInfoView addSubview:groupCashLabel];
    [groupCashLabel setText:@"团购金额："];
    [groupCashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topInfoView).offset(10);
        make.top.equalTo(groupCdLabel.mas_bottom);
        make.height.mas_equalTo(25);
    
    }];
    [groupCashLabel setFont:FONT14];
    
    custmoerCountLabel = [[UILabel alloc] init];
    [topInfoView addSubview:custmoerCountLabel];
    [custmoerCountLabel setText:@"客户数量："];
    [custmoerCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topInfoView).offset(10);
        make.top.equalTo(groupCashLabel.mas_bottom);
        make.height.mas_equalTo(25);
    
    }];
    [custmoerCountLabel setFont:FONT14];
    
    custmoerOrignLabel = [[UILabel alloc] init];
    [topInfoView addSubview:custmoerOrignLabel];
    [custmoerOrignLabel setText:@"客户来源："];
    [custmoerOrignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(10);
        make.top.equalTo(groupLabel.mas_bottom);
        make.height.mas_equalTo(25);
    }];
    [custmoerOrignLabel setFont:FONT14];
    
    groupTypeLabel = [[UILabel alloc] init];
    [topInfoView addSubview:groupTypeLabel];
    [groupTypeLabel setText:@"团购类型："];
    [groupTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(10);
        make.top.equalTo(custmoerOrignLabel.mas_bottom);
        make.height.mas_equalTo(25);
    }];
    [groupTypeLabel setFont:FONT14];
    
    groupFCashLabel = [[UILabel alloc] init];
    [topInfoView addSubview:groupFCashLabel];
    [groupFCashLabel setText:@"实收金额："];
    [groupFCashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(10);
        make.top.equalTo(groupTypeLabel.mas_bottom);
        make.height.mas_equalTo(25);
    }];
    [groupFCashLabel setFont:FONT14];
    
    groupUsedLabel = [[UILabel alloc] init];
    [topInfoView addSubview:groupUsedLabel];
    [groupUsedLabel setText:@"使用状态："];
    [groupUsedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(10);
        make.top.equalTo(groupFCashLabel.mas_bottom);
        make.height.mas_equalTo(25);
    }];
    [groupUsedLabel setFont:FONT14];
    
}


- (void)leftButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setInfo:(NSMutableDictionary *) dic {
    [topInfoView setHidden:NO];
    [myTableView setHidden: NO];
    [sendButton setHidden:NO];
    self.orderCd =[dic objectForKey:@"orderNo"];
    [groupLabel setText:[NSString stringWithFormat:@"团购信息（%@）", [dic objectForKey:@"verifCode"]]];
    [phoneNumLabel setText:[NSString stringWithFormat:@"电话号码：%@", [dic objectForKey:@"telNo"]]];
    [groupCdLabel setText:[NSString stringWithFormat:@"订单编号：%@", [dic objectForKey:@"orderNo"]]];
    [groupCashLabel setText:[NSString stringWithFormat:@"团购金额：%@", [dic objectForKey:@"groupBuyingAmt"]]];
    [custmoerCountLabel setText:[NSString stringWithFormat:@"客户数量：%@", [dic objectForKey:@"customerQty"]]];
    [custmoerOrignLabel setText:[NSString stringWithFormat:@"客户来源：%@", [dic objectForKey:@"customerName"]]];
    [groupTypeLabel setText:[NSString stringWithFormat:@"团购类型：%@", [dic objectForKey:@"groupName"]]];
    [groupFCashLabel setText:[NSString stringWithFormat:@"实收金额：%@", [dic objectForKey:@"receiveAmt"]]];
    
    if ([dic objectForKey:@"status"] != nil) {
        UIColor *color = [UIColor colorWithRed:151/255.0f green:227/255.0f blue:153/255.0f alpha:1];
        if ([[dic objectForKey:@"status"] isEqual:@"已使用已转单"]) {
            color =[UIColor colorWithRed:255/255.0f green:64/255.0f blue:129/255.0f alpha:1];
        }
        NSString *strNumber = [NSString stringWithFormat:@"使用状态：%@",[dic objectForKey:@"status"]];
        NSMutableAttributedString *str_number = [[NSMutableAttributedString alloc] initWithString:strNumber];
        NSString *strLength = [dic objectForKey:@"status"];
        [self setDiffString:str_number withString:@"使用状态：" loaction:0 textColor:[UIColor blackColor] textSize:@"AppleGothic" size:14.0];
        [self setDiffString:str_number withString:strLength loaction:5 textColor:color textSize:@"AppleGothic" size:14.0];
        ;
        groupUsedLabel.attributedText = str_number;
    }
    
    [self.dataList addObjectsFromArray:[dic objectForKey:@"projectList"]];
    [myTableView reloadData];
    

}


#pragma mark - 同一label设置不同颜色、字体
- (void)setDiffString:(NSMutableAttributedString *)str_number withString:(NSString *)str_jq loaction:(NSInteger)loca textColor:(UIColor *)color textSize:(NSString *)fontName size:(CGFloat)size
{
    
    [str_number addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(loca,[str_jq length])];
    [str_number addAttribute:NSFontAttributeName value:[UIFont fontWithName:[UIFont systemFontOfSize:14.0f].familyName size:size] range:NSMakeRange(loca,[str_jq length])];
}

- (void) rightButtonPressed {
    WQCodeScanner *scanner = [[WQCodeScanner alloc] init];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [self presentViewController:scanner animated:YES completion:nil];
    scanner.resultBlock = ^(NSString *value) {
        if (value.length) {
            [dic setObject:value forKey:@"groupCd"];
        }
        [dic setObject:[userDefaults objectForKey:UUID] forKey:@"userCd"];
        [[NetWorkingModel sharedInstance] GET:GETXMDINFO parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@", jsonString);
            
            if (ISSUCCESS) {
                self.dataDic = CONTENTOBJ;
                [self setInfo:CONTENTOBJ];
                
            } else {
                if ([OBJSTATUS isEqualToString:@"error"]) {
                    SHOWTEXTINWINDOW(OBJMESSAGE, 1.5);
                }
            }
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
    };
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *groupCd = searchBar.text;
    NSLog(@"%@", groupCd);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:groupCd forKey:@"groupCd"];
    [dic setObject:[userDefaults objectForKey:UUID] forKey:@"userCd"];
    [[NetWorkingModel sharedInstance] GET:GETXMDINFO parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", jsonString);
        
        if (ISSUCCESS) {
            self.dataDic = CONTENTOBJ;
            [self setInfo:CONTENTOBJ];
            
        } else {
            if ([OBJSTATUS isEqualToString:@"error"]) {
                SHOWTEXTINWINDOW(OBJMESSAGE, 1.5);
            }
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat ) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, 0)];
    return headerView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UILabel *customerLabel = [[UILabel alloc] init];
        customerLabel.tag = 2000;
        [cell addSubview:customerLabel];
        [customerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).offset(5);
            make.right.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.height.mas_equalTo(25);
        }];
        [customerLabel setFont:FONT15];
        [customerLabel setText:@"第一人"];
        
        UILabel *projectNameLabel = [[UILabel alloc] init];
        projectNameLabel.tag = 2001;
        [cell addSubview:projectNameLabel];
        [projectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(customerLabel.mas_bottom);
            make.right.equalTo(cell.mas_centerX);
            make.left.equalTo(cell).offset(15);
            make.height.mas_equalTo(25);
        }];
        [projectNameLabel setFont:FONT14];
        [projectNameLabel setText:@"项目名称："];
        
        UILabel *projectPriceLabel = [[UILabel alloc] init];
        projectPriceLabel.tag = 2002;
        [cell addSubview:projectPriceLabel];
        [projectPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(projectNameLabel.mas_bottom);
            make.right.equalTo(cell.mas_centerX);
            make.left.equalTo(cell).offset(15);
            make.height.mas_equalTo(25);
        }];
        [projectPriceLabel setFont:FONT14];
        [projectPriceLabel setText:@"项目价格："];
        
        UILabel *projectCdLabel = [[UILabel alloc] init];
        projectCdLabel.tag = 2003;
        [cell addSubview:projectCdLabel];
        [projectCdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(customerLabel.mas_bottom);
            make.left.equalTo(cell.mas_centerX);
            make.right.equalTo(cell).offset(5);
            make.height.mas_equalTo(25);
        }];
        [projectCdLabel setFont:FONT14];
        [projectCdLabel setText:@"项目编号："];
        
        UILabel *tuanPriceLabel = [[UILabel alloc] init];
        tuanPriceLabel.tag = 2004;
        [cell addSubview:tuanPriceLabel];
        [tuanPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(projectCdLabel.mas_bottom);
            make.left.equalTo(cell.mas_centerX);
            make.right.equalTo(cell).offset(5);
            make.height.mas_equalTo(25);
        }];
        [tuanPriceLabel setFont:FONT14];
        [tuanPriceLabel setText:@"团购金额："];
    }
    
    NSDictionary *dic = [self.dataList objectAtIndex:indexPath.row];
    
    UILabel *customerLabel = [cell viewWithTag:2000];;
    [cell addSubview:customerLabel];
    [customerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).offset(5);
        make.right.equalTo(cell);
        make.left.equalTo(cell).offset(15);
        make.height.mas_equalTo(25);
    }];
    [customerLabel setFont:FONT15];
    [customerLabel setText:[NSString stringWithFormat:@"第%@人", [dic objectForKey:@"groupNum"]]];
    
    UILabel *projectNameLabel = [cell viewWithTag:2001];
    [cell addSubview:projectNameLabel];
    [projectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customerLabel.mas_bottom);
        make.right.equalTo(cell.mas_centerX);
        make.left.equalTo(cell).offset(15);
        make.height.mas_equalTo(25);
    }];
    [projectNameLabel setFont:FONT14];
    [projectNameLabel setText:[NSString stringWithFormat:@"项目名称：%@", [dic objectForKey:@"groupProjectName"]]];
    
    UILabel *projectPriceLabel = [cell viewWithTag:2002];
    [cell addSubview:projectPriceLabel];
    [projectPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(projectNameLabel.mas_bottom);
        make.right.equalTo(cell.mas_centerX);
        make.left.equalTo(cell).offset(15);
        make.height.mas_equalTo(25);
    }];
    [projectPriceLabel setFont:FONT14];
    [projectPriceLabel setText:[NSString stringWithFormat:@"项目价格：%@", [dic objectForKey:@"projectPrice"]]];
    
    UILabel *projectCdLabel = [cell viewWithTag:2003];
    [cell addSubview:projectCdLabel];
    [projectCdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customerLabel.mas_bottom);
        make.left.equalTo(cell.mas_centerX);
        make.right.equalTo(cell).offset(5);
        make.height.mas_equalTo(25);
    }];
    [projectCdLabel setFont:FONT14];
    [projectCdLabel setText:[NSString stringWithFormat:@"项目编号：%@",[dic objectForKey:@"groupProjectCd"]]];
    
    UILabel *tuanPriceLabel = [cell viewWithTag:2004];
    [cell addSubview:tuanPriceLabel];
    [tuanPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(projectCdLabel.mas_bottom);
        make.left.equalTo(cell.mas_centerX);
        make.right.equalTo(cell).offset(5);
        make.height.mas_equalTo(25);
    }];
    [tuanPriceLabel setFont:FONT14];
    [tuanPriceLabel setText:[NSString stringWithFormat:@"团购金额：%@", [dic objectForKey:@"groupProjectPrice"]]];
    
    
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
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
