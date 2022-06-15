//
//  LJSelectedProjectViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/4/21.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "HLSelectedProjectViewController.h"
#import "WQCodeScanner.h"

@interface HLSelectedProjectViewController () {
    UIButton *nextButton;
    
    UIScrollView *mainScrollView;
    
    TopScrollViewMenuView *topMenu;
}

@end

@implementation HLSelectedProjectViewController
@synthesize topView, titleString, myCollectionView, datas, mySearchBar;

- (void) loadData {
    
    NSMutableDictionary *dicP = [NSMutableDictionary dictionary];
    [dicP setValue:STORCDSTRING forKey:@"storeCd"];
    if (self.artificerCd.length) {
        [dicP setValue:self.artificerCd forKey:@"artificerCd"];
    }
    
    if (self.detailEntity.projectName.length) {
        [dicP setValue:[NSNumber numberWithBool:self.detailEntity.qtyUpdateFlg] forKey:@"qtyUpdateFlg"];
    } 
    
    NSLog(@"dic = %@", dicP);
    [[NetWorkingModel sharedInstance] GET:RECEPTIONPROJECTLIST parameters:dicP success:^(AFHTTPRequestOperation *operation, id obj) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        [self.dataList removeAllObjects];
        [self.titleArray removeAllObjects];
        [self.searchData removeAllObjects];
        [self.allDatas removeAllObjects];
        
        if (ISSUCCESS) {
            if (self.titleArray == nil) {
                self.titleArray = [NSMutableArray array];
            } else {
                [self.titleArray removeAllObjects];
            }
            for (NSDictionary *dic in CONTENTOBJ) {
                LJProjectTitleModel *titleModel = [[LJProjectTitleModel alloc] init];
                [titleModel setValuesForKeysWithDictionary:dic];
                [self.dataList addObject:titleModel];
                [self.titleArray addObject:titleModel.typeName];
            }
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (self.allDatas == nil) {
                    self.allDatas = [NSMutableArray array];
                } else {
                    [self.allDatas removeAllObjects];
                }
                for (LJProjectTitleModel *entity in self.dataList) {
                    [self.allDatas addObjectsFromArray:entity.projectList];
                }
                
                self.searchData = [NSMutableArray arrayWithArray:self.allDatas];
            });
            
            [topMenu setMenuListWithData:[NSMutableArray arrayWithArray:self.titleArray]];
        }
        
        [myCollectionView.mj_header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [myCollectionView.mj_header endRefreshing];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    datas = [NSMutableArray array];
    self.dataList = [NSMutableArray array];
    [self loadData];
    
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    topView.delegate = self;
    [self.view addSubview:topView];
    topView.titleLabel.text = titleString;
    topView.backgroundColor = self.isConsumption ? navLightBrownColor : NavBackColor;
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    [topView.rightButton setImage:[UIImage imageNamed:@"saoyi_sao"] forState:UIControlStateNormal];
    topView.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    topView.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 20, kappScreenWidth - 80, 40)];
    //    searchBar.
    [topView addSubview:mySearchBar];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"请输入项目编号、名称或拼音简码";
    //    searchBar.tintColor = LightBrownColor;
    mySearchBar.showsCancelButton = NO;
    mySearchBar.barTintColor = LightBrownColor;
    [mySearchBar setImage:[UIImage imageNamed:@"icon_Search_bg white"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    mySearchBar.backgroundColor = [UIColor clearColor];
    for (UIView *subView in mySearchBar.subviews) {
//        if ([subView isKindOfClass:NSClassFromString(@"UIView")] && subView.subviews.count > 0) {
//            [[subView.subviews objectAtIndex:0] removeFromSuperview];
//            break;
//        }
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            subView.layer.contents = nil;
        }
    }
    mySearchBar.hidden = YES;
    
    
    topMenu = [[TopScrollViewMenuView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kappScreenWidth, 50)];
    topMenu.TinColor = self.isConsumption ? navLightBrownColor : NavBackColor;
    topMenu.bottomView.hidden = YES;
    topMenu.delegate = self;
    [self.view addSubview:topMenu];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //        flowLayout.itemSize = CGSizeMake(80, 50);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 设置最小行间距
    flowLayout.minimumLineSpacing = 0;
    // 设置垂直间距
    flowLayout.minimumInteritemSpacing = 0;
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth + topMenu.frame.size.height + 10, kappScreenWidth, kappScreenHeight - kTopScreenWidth - topMenu.frame.size.height - 110) collectionViewLayout:flowLayout];
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    myCollectionView.backgroundColor = WhiteColor;
    [self.view addSubview:myCollectionView];
    
    myCollectionView.delegate = self;
    myCollectionView.dataSource= self;
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.bottom.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(60);
    }];
    [nextButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    nextButton.backgroundColor = self.isConsumption ? LightBrownColor : NavBackColor;
    [nextButton setTitle:@"确定" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = 30;
    
    if (([_detailEntity.settlementStatus isEqualToString:@"appointment"] || [_detailEntity.settlementStatus isEqualToString:@"settleing"])) {
        // 除扫盒项目外，预结和结算中的项目不允许修改
        nextButton.userInteractionEnabled=NO;//交互关闭
        nextButton.alpha=0.4;//透明度
        if (_detailEntity.boxCd.length == 0) {
            topView.rightButton.userInteractionEnabled = NO;
        }
    }
    
    myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    [myCollectionView.mj_header beginRefreshing];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    
    [UIView animateWithDuration:0.2 animations:^{
        myCollectionView.frame =  CGRectMake(0, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth - 110);
    }];
    [myCollectionView reloadData];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.2 animations:^{
        myCollectionView.frame = CGRectMake(0, kTopScreenWidth + topMenu.frame.size.height + 10, kappScreenWidth, kappScreenHeight - kTopScreenWidth - topMenu.frame.size.height - 110);
    }];
    [myCollectionView reloadData];
    return YES;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *text = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (text.length) {
            [self.searchData removeAllObjects];
            for (LJProjectModel *entity in self.allDatas) {
                if ([entity.projectCd containsString:searchText] || [entity.projectName containsString:searchText] || [entity.fastCode.uppercaseString containsString:searchText.uppercaseString]) {
                    [self.searchData addObject:entity];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [myCollectionView reloadData];
            });
            
        } else {
            self.searchData = [NSMutableArray arrayWithArray:self.allDatas];
            dispatch_async(dispatch_get_main_queue(), ^{
                [myCollectionView reloadData];
            });
        }
        
    });
}


- (void) nextButtonClick:(UIButton *) sender {
    
    
    
    if (self.selectedProject) {
        
        if (self.artificerCd.length) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            if (self.selectedProject.projectCd.length) {
                [dic setValue:self.selectedProject.projectCd forKey:@"projectCd"];
            }
            
            if (self.artificerCd.length) {
                [dic setValue:self.artificerCd forKey:@"artificerCd"];
            }
            
            if ([self.selectedProject.projectCd isEqualToString:self.detailEntity.projectCd]) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            
            if ([self.delegate respondsToSelector:@selector(sendProject:)]) {
                [self.delegate sendProject:self.selectedProject];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            return;
            
            SHOWSTATUSCLEAR
            [[NetWorkingModel sharedInstance] GET:XIAOFEIVERIFIJISHI parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                DISMISS
                if (ISSUCCESS) {
                    if ([[CONTENTOBJ objectForKey:@"waitTime"] integerValue] == 0) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        if (self.detailEntity.orderCd.length) {
                            [dic setValue:self.detailEntity.orderCd forKey:@"orderCd"];
                        }
                        
                        if (self.detailEntity.customerCd.length) {
                            [dic setValue:self.detailEntity.customerCd forKey:@"customerCd"];
                        }
                        
                        if (self.selectedProject.projectCd.length) {
                            [dic setValue:self.selectedProject.projectCd forKey:@"projectCd"];
                        }
                        
                        if (self.detailEntity.detailNo.length) {
                            [dic setValue:self.detailEntity.detailNo forKey:@"detailNo"];
                        }
                        
                        if (self.detailEntity.sex.length) {
                            [dic setValue:self.detailEntity.sex forKey:@"sex"];
                        }
                        
                        [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
                        
                        if (self.artificerCd.length) {
                            [dic setValue:self.artificerCd forKey:@"artificer1Cd"];
                        }
                        
                        if ([[CONTENTOBJ objectForKey:@"startTime"] length]) {
                            [dic setValue:[CONTENTOBJ objectForKey:@"startTime"] forKey:@"startTime"];
                        }
                        
                        if (self.isConsumption) {
                            [dic setValue:@"consume" forKey:@"orderFag"];
                        } else {
                            [dic setValue:@"reception" forKey:@"orderFag"];
                        }
                        if (self.detailEntity.roomCd) {
                            [dic setValue:self.detailEntity.roomCd forKey:@"roomCd"];
                        }
                        if (self.detailEntity.roomName) {
                            [dic setValue:self.detailEntity.roomName forKey:@"roomName"];
                        }
                        NSLog(@"dic  = %@", dic);
                        SHOWSTATUSCLEAR
                        [[NetWorkingModel sharedInstance] POST:XIAOFEIINSERTJISHI parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                            DISMISS
                            if (ISSUCCESS) {
                                if ([self.delegate respondsToSelector:@selector(sendProject:)]) {
                                    [self.delegate sendProject:self.selectedProject];
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            } else {
                                BADREQUEST
                            }
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        }];
                        
                    } else if ([[CONTENTOBJ objectForKey:@"waitTime"] integerValue] < 0) {
                        DISMISS
                        NSString *str =@"技师状态异常，暂时不能选择。";
                        self.startTime =  [CONTENTOBJ objectForKey:@"startTime"];
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        av.tag = 4003;
                        [av show];
                    } else {
                        DISMISS
                        NSString *str =[NSString stringWithFormat:@"%@号技师需要等%@待分钟，约%@上钟，确定点钟？", [CONTENTOBJ objectForKey:@"artificerCd"],[CONTENTOBJ objectForKey:@"waitTime"], [CONTENTOBJ objectForKey:@"startTime"]];
                        self.startTime =  [CONTENTOBJ objectForKey:@"startTime"];
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
                        av.tag = 4000;
                        [av show];
                    }
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
            
        } else {
            if ([self.delegate respondsToSelector:@selector(sendProject:)]) {
                [self.delegate sendProject:self.selectedProject];

                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    } else {
        SHOWTEXTINWINDOW(@"请选择项目", 1);
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 4000) {
        if (buttonIndex == 0) {
            // 取消
            
        } else {
            //            继续
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (self.detailEntity.orderCd.length) {
                [dic setValue:self.detailEntity.orderCd forKey:@"orderCd"];
            }
            
            if (self.detailEntity.customerCd.length) {
                [dic setValue:self.detailEntity.customerCd forKey:@"customerCd"];
            }
            
            if (self.selectedProject.projectCd.length) {
                [dic setValue:self.selectedProject.projectCd forKey:@"projectCd"];
            }
            
            if (self.detailEntity.detailNo.length) {
                [dic setValue:self.detailEntity.detailNo forKey:@"detailNo"];
            }
            
            if (self.detailEntity.sex.length) {
                [dic setValue:self.detailEntity.sex forKey:@"sex"];
            }
            
            [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
            
            if (self.artificerCd.length) {
                [dic setValue:self.artificerCd forKey:@"artificer1Cd"];
            }
            
            if ([self.startTime length]) {
                [dic setValue:self.startTime forKey:@"startTime"];
            }

            if (self.isConsumption) {
                [dic setValue:@"consume" forKey:@"orderFag"];
            } else {
                [dic setValue:@"reception" forKey:@"orderFag"];
            }
            if (self.detailEntity.roomCd) {
                [dic setValue:self.detailEntity.roomCd forKey:@"roomCd"];
            }
            if (self.detailEntity.roomName) {
                [dic setValue:self.detailEntity.roomName forKey:@"roomName"];
            }
            NSLog(@"dic  = %@", dic);
            SHOWSTATUSCLEAR
            [[NetWorkingModel sharedInstance] POST:XIAOFEIINSERTJISHI parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                DISMISS
                if (ISSUCCESS) {
                    if ([self.delegate respondsToSelector:@selector(sendProject:)]) {
                        [self.delegate sendProject:self.selectedProject];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } else {
                    BADREQUEST
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            
            
        }
    }
}

- (void)selectedMenu:(NSInteger)page {
    if (!self.dataList.count) {
        return;
    }
    datas = [[self.dataList objectAtIndex:page] projectList];
    [myCollectionView reloadData];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(kappScreenWidth / 4, 50);
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return mySearchBar.isHidden ? self.datas.count : self.searchData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //    return self.dataList.count + 1;
    return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIButton *btn = (UIButton *) [cell viewWithTag:1000];
    if (!btn) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:gray104 forState:UIControlStateNormal];
        [btn setTitleColor:WhiteColor forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        [btn setBackgroundImage:[LJColorImage imageWithColor:gray238] forState:UIControlStateNormal];
        [btn setBackgroundImage:[LJColorImage imageWithColor:NavBackColor] forState:UIControlStateSelected];

        
        btn.titleLabel.font = FONT14;
        btn.titleLabel.numberOfLines = 0;
        
        btn.tag = 1000;
        [cell addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(8);
            make.right.equalTo(cell).offset(-8);
            make.top.equalTo(cell).offset(5);
            make.bottom.equalTo(cell).offset(-5);
        }];
        btn.clipsToBounds = YES;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 6;
    }
    LJProjectModel *entity = mySearchBar.isHidden ? [datas objectAtIndex:indexPath.row] : [self.searchData objectAtIndex:indexPath.row];
    [btn setTitle:entity.projectName forState:UIControlStateNormal];
    [btn setSelected:entity.isChoosed];
    
    return cell;
    
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    for (LJProjectModel *model in self.allDatas) {
        model.isChoosed = NO;
    }
    LJProjectModel *entity = mySearchBar.isHidden ? [datas objectAtIndex:indexPath.row] : [self.searchData objectAtIndex:indexPath.row];
    self.selectedProject = entity;
    entity.isChoosed = YES;
    [myCollectionView reloadData];
}


- (void)leftButtonPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonPressed {
    
    WQCodeScanner *scanner = [[WQCodeScanner alloc] init];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_detailEntity.orderCd.length) {
        [dic setObject:_detailEntity.orderCd forKey:@"orderCd"];
    }
    if (_detailEntity.orderCd.length) {
        [dic setObject:_detailEntity.detailNo forKey:@"detailNo"];
    }
    if (_detailEntity.customerCd.length) {
        [dic setObject:_detailEntity.customerCd forKey:@"customerCd"];
    }
    if (_detailEntity.projectCd.length) {
        [dic setObject:_detailEntity.projectCd forKey:@"projectCd"];
    }

    [dic setObject:[userDefaults objectForKey:USERID] forKey:@"userId"];
    

    [self presentViewController:scanner animated:YES completion:nil];
    scanner.resultBlock = ^(NSString *value) {
        if (value.length) {
            [dic setObject:value forKey:@"boxCd"];
        }
        [[NetWorkingModel sharedInstance] POST:BOXCDUPDATE parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@", jsonString);
            
            if (ISSUCCESS) {
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                if ([OBJMESSAGE isEqualToString:@"error"]) {
                    SHOWTEXTINWINDOW(@"查询没有信息", 1.5);
                } else if ([OBJMESSAGE isEqualToString:@"request_error"]) {
                    SHOWTEXTINWINDOW(@"网络请求失败", 1.5);
                }  else if ([OBJMESSAGE isEqualToString:@"hasothersettlementstatus_error"]) {
                    SHOWTEXTINWINDOW(@"存在其他的结算方式，不能更改", 1.5);
                }  else if ([OBJMESSAGE isEqualToString:@"num_error"]) {
                    SHOWTEXTINWINDOW(@"次数不足", 1.5);
                } else {
                    SHOWTEXTINWINDOW(@"查询错误", 1.5);
                }
            }
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];

    };
//    if (mySearchBar.hidden) {
//        mySearchBar.hidden = NO;
//        [topView.rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [topView.rightButton setTitle:@"取消" forState:UIControlStateNormal];
//        myCollectionView.mj_header = nil;
//    } else {
//        myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self loadData];
//        }];
//        //        搜索
//        self.keyWords = [mySearchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        mySearchBar.hidden = YES;
//        [mySearchBar endEditing:YES];
//        
//        [topView.rightButton setImage:[UIImage imageNamed:@"icon_Search_bg color"] forState:UIControlStateNormal];
//        [topView.rightButton setTitle:@"" forState:UIControlStateNormal];
//    }

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
