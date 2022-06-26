//
//  LJSelectTechnicianViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/4/21.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJSelectTechnicianViewController.h"

@interface LJSelectTechnicianViewController () {
    
    UIButton *lunButton;
    
    UIButton *nextButton;
    
    UIScrollView *mainScrollView;
    
    LJTECTopMenu *topMenu;
    
    UIView *lastTechnicianView;
    
    CGFloat heightForLast;
    
    UIButton *changeResonBtn;
    
    NSMutableArray *allDatas;
    
    UIColor *selectedColor;
    
    NSMutableArray *bianhaoArr;
    NSMutableArray *nameArr;
}

@end

@implementation LJSelectTechnicianViewController
@synthesize topView, titleString, myCollectionView, datas, mySearchBar, myControl, pickView;

- (void) loadData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([[userDefaults objectForKey:STORECD] length]) {
        [dic setValue:[userDefaults objectForKey:STORECD] forKey:@"storeCd"];
    }
    
    if (self.projectCd.length) {
        [dic setValue:self.projectCd forKey:@"projectCd"];
    }
    
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] GET:RECEPTIONARTFICERLIST parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        
        if (ISSUCCESS) {
            if (allDatas) {
                [allDatas removeAllObjects];
            } else {
                allDatas = [NSMutableArray array];
            }
            for (NSDictionary *dic in CONTENTOBJ) {
                LJArtModel *entity = [[LJArtModel alloc] init];
                [entity setValuesForKeysWithDictionary:dic];
                [allDatas addObject:entity];
            }
            
            if (self.artRecModel) {
//                for (LJArtModel *entity in allDatas) {
//                    if ([entity.artificerCd isEqualToString:self.artRecModel.artificer1Cd] && [self.artRecModel.artificer1SelectType isEqualToString:@"callTime"]) {
//                        allDatas = [NSMutableArray arrayWithObject:entity];
//                    } else if ([entity.artificerCd isEqualToString:self.artRecModel.artificer2Cd] && [self.artRecModel.artificer2SelectType isEqualToString:@"callTime"]) {
//                        allDatas = [NSMutableArray arrayWithObject:entity];
//                    }
//                }
            }
            
            [self selectedMenu:0];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (self.searchData == nil) {
                    self.searchData = [NSMutableArray array];
                } else {
                    [self.searchData removeAllObjects];
                }
                self.searchData = [NSMutableArray arrayWithArray:allDatas];
            });
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    datas = [NSMutableArray array];
    
    [self loadData];
    
    self.view.backgroundColor = gray238;
    
    if ([self.titleString isEqualToString:@"更换技师"]) {
        heightForLast = 10 + FONT15.lineHeight*2 + FONT12.lineHeight + 5 + 5 + 44 + 20;
    } else {
        heightForLast = 0;
    }
    
    lastTechnicianView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kappScreenWidth, heightForLast)];
    [self.view addSubview:lastTechnicianView];
    if ([self.titleString isEqualToString:@"更换技师"]) {
        [lastTechnicianView setHidden:NO];
    } else {
        [lastTechnicianView setHidden:YES];
    }
    UILabel *label = [UILabel new];
    [lastTechnicianView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastTechnicianView).offset(20);
        make.top.equalTo(lastTechnicianView).offset(10);
        make.height.mas_equalTo(FONT12.lineHeight);
    }];
    label.text = @"当前技师";
    label.textColor = self.isConsumption ? navLightBrownColor : NavBackColor;
    label.font = FONT12;
    
    selectedColor = self.isConsumption ? navLightBrownColor : NavBackColor;
    
//    UILabel *ltNameLable = [UILabel new];
//    [lastTechnicianView addSubview:ltNameLable];
//    [ltNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(label.mas_left);
//        make.top.equalTo(label.mas_bottom).offset(5);
//        make.height.mas_equalTo(FONT15.lineHeight);
//    }];
//    ltNameLable.text = @"好美丽";
//    ltNameLable.font = FONTBOLD(15);
//    
//    UILabel *ltNumberLabel = [UILabel new];
//    [lastTechnicianView addSubview:ltNumberLabel];
//    [ltNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(ltNameLable.mas_right).offset(15);
//        make.top.equalTo(label.mas_bottom).offset(5);
//        make.height.mas_equalTo(FONT15.lineHeight);
//    }];
//    ltNumberLabel.text = @"Y0015";
//    ltNumberLabel.font = FONT15;
    
    
    for (int i = 0; i < self.technicianCount; i++) {
        LJTechnicianButton *tButton = [LJTechnicianButton buttonWithType:UIButtonTypeCustom];
        [lastTechnicianView addSubview:tButton];
        tButton.delegate = self;
        
        tButton.frame = CGRectMake(20 + 120 * i, 10 + FONT12.lineHeight + 5, 100, FONT15.lineHeight*2);
        NSString *strCd = @"";
        if (i == 0) {
            strCd = self.detailEntity.artificer1Cd;
        } else if (i == 1) {
            strCd = self.detailEntity.artificer2Cd;
        } else if (i == 2) {
            strCd = self.detailEntity.artificer3Cd;
        } else if (i == 3) {
            strCd = self.detailEntity.artificer4Cd;
        }
        
        if (strCd.length) {
            [tButton setTitle:[NSString stringWithFormat:@"%@", strCd] forState:UIControlStateNormal];
            
        } else {
            [tButton setTitle:@"空" forState:UIControlStateNormal];
        }
        [tButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tButton setTitleColor:WhiteColor forState:UIControlStateSelected];
        tButton.backgroundColor = gray238;
        tButton.layer.cornerRadius = 6;
        tButton.layer.masksToBounds = YES;
        tButton.tag = 3000 + i;
        [tButton setBackgroundImage:[LJColorImage imageWithColor:gray238] forState:UIControlStateNormal];
        [tButton setBackgroundImage:[LJColorImage imageWithColor:self.isConsumption ? LightBrownColor : NavBackColor] forState:UIControlStateSelected];
        
        [tButton addTarget:self action:@selector(tButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [tButton addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
        
        if (i==0) {
            self.selectedButton = tButton;
        }
    }
    
    
    changeResonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastTechnicianView addSubview:changeResonBtn];
    changeResonBtn.backgroundColor = gray238;
    [changeResonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_left);
        make.top.equalTo(label).offset(25 + FONT15.lineHeight * 2);
        make.right.equalTo(lastTechnicianView).offset(-20);
        make.height.mas_equalTo(44);
    }];
    [changeResonBtn setTitle:@"请选择更换原因" forState:UIControlStateNormal];
    [changeResonBtn setTitleColor:gray104 forState:UIControlStateNormal];
    changeResonBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    changeResonBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    changeResonBtn.layer.cornerRadius = 6;
    changeResonBtn.layer.masksToBounds = YES;
    [changeResonBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *lineView = [[UIView alloc] init];
    [lastTechnicianView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastTechnicianView);
        make.right.equalTo(lastTechnicianView);
        make.bottom.equalTo(lastTechnicianView);
        make.height.mas_equalTo(10);
    }];
    lineView.backgroundColor = gray238;
    
    
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    topView.delegate = self;
    [self.view addSubview:topView];
    topView.titleLabel.text = titleString;
    topView.backgroundColor = self.isConsumption ? navLightBrownColor : NavBackColor;
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    [topView.rightButton setImage:[UIImage imageNamed:@"icon_Search_bg color"] forState:UIControlStateNormal];
    topView.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    topView.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, kSafeHeight ? kSafeHeight + 10 : 20 , kappScreenWidth - 80, 40)];
    //    searchBar.
    [topView addSubview:mySearchBar];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"请输入技师编号、姓名或拼音简码";
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
    
    NSArray *titleArray = @[@"全部", @"上钟", @"空闲",@"预定"];
//    NSArray *titleArray = @[@"全部", @"上钟", @"空闲"];
    topMenu = [[LJTECTopMenu alloc] initWithFrame:CGRectMake(0, kTopScreenWidth + heightForLast, kappScreenWidth, 50)];
    topMenu.TinColor = self.isConsumption ? navLightBrownColor : NavBackColor;
    [topMenu setMenuListWithData:[NSMutableArray arrayWithArray:titleArray]];
    topMenu.bottomView.hidden = NO;
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
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth + topMenu.frame.size.height + 10 + heightForLast, kappScreenWidth, kappScreenHeight - kTopScreenWidth - topMenu.frame.size.height - heightForLast - 110) collectionViewLayout:flowLayout];
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    myCollectionView.backgroundColor = WhiteColor;
    [self.view addSubview:myCollectionView];
    
    myCollectionView.delegate = self;
    myCollectionView.dataSource= self;
    
    if (self.isConsumption) {
        lunButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:lunButton];
        [lunButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(30);
            make.right.equalTo(self.view.mas_centerX).offset(-15);
            make.bottom.equalTo(self.view).offset(-30);
            make.bottom.height.mas_equalTo(60);
        }];
        [lunButton setTitleColor:WhiteColor forState:UIControlStateNormal];
        lunButton.backgroundColor = [UIColor colorWithRed:114/255.0f green:206/255.0f blue:183/255.0f alpha:1];
        [lunButton setTitle:@"轮钟" forState:UIControlStateNormal];
        [lunButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        lunButton.layer.masksToBounds = YES;
        lunButton.layer.cornerRadius = 30;
        
        nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:nextButton];
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lunButton.mas_right).offset(30);
            make.right.equalTo(self.view).offset(-30);
            make.bottom.equalTo(self.view).offset(-30);
            make.bottom.height.mas_equalTo(60);
        }];
        [nextButton setTitleColor:WhiteColor forState:UIControlStateNormal];
        nextButton.backgroundColor = self.isConsumption ? LightBrownColor : NavBackColor;
        [nextButton setTitle:@"点钟" forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        nextButton.layer.masksToBounds = YES;
        nextButton.layer.cornerRadius = 30;
    } else {
        nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:nextButton];
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(30);
            make.right.equalTo(self.view).offset(-30);
            make.bottom.equalTo(self.view).offset(-30);
            make.bottom.height.mas_equalTo(60);
        }];
        [nextButton setTitleColor:WhiteColor forState:UIControlStateNormal];
        nextButton.backgroundColor = self.isConsumption ? LightBrownColor : NavBackColor;
        [nextButton setTitle:@"确定" forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        nextButton.layer.masksToBounds = YES;
        nextButton.layer.cornerRadius = 30;
    }
    
    
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
    
}
- (void)closePickView {
    [self pickViewDone];
}
- (void)pickViewDone {
    [UIView animateWithDuration:0.3 animations:^{
        myControl.hidden = YES;
        pickView.frame = CGRectMake(0, kappScreenHeight, kappScreenWidth, 260);
    }];
    
}
- (void)selectedDone:(NSInteger)index {

    [changeResonBtn setTitle:[nameArr objectAtIndex:index] forState:UIControlStateNormal];
    self.changeStr = [bianhaoArr objectAtIndex:index];
}
- (void) showPickViewWithData:(NSMutableArray *) pickDatas {
    [self.view endEditing:YES];
    pickView.datas = pickDatas;
    [UIView animateWithDuration:0.3 animations:^{
        myControl.hidden = NO;
        pickView.frame = CGRectMake(0, kappScreenHeight - 260, kappScreenWidth, 260);
    }];
}
- (void)changeBtnClick {
    if (nameArr.count) {
        [self showPickViewWithData:nameArr];
    } else {
        nameArr = [NSMutableArray array];
        bianhaoArr = [NSMutableArray array];
        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] POST:RESONLIST parameters:@{} success:^(AFHTTPRequestOperation *operation, id obj) {
            DISMISS
            if (ISSUCCESS) {
                for (NSDictionary *dic in CONTENTOBJ) {
                    [bianhaoArr addObject:[dic objectForKey:@"parameterCd"]];
                    [nameArr addObject:[dic objectForKey:@"charValue1"]];
                }
                [self showPickViewWithData:nameArr];
            } else {
                BADREQUEST
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
}

- (void) longPress:(UILongPressGestureRecognizer *) longPressGes {
    if (longPressGes.state == UIGestureRecognizerStateBegan) {
        LJTechnicianButton *tButton = (LJTechnicianButton *)longPressGes.view;
        if (tButton.closeBtn) {
            if (tButton.closeBtn.hidden) {
                [tButton showButton];
            } else {
                [tButton closeButton];
            }
        } else {
            [tButton showButton];
        }
    }
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    
    [UIView animateWithDuration:0.2 animations:^{
        myCollectionView.frame = CGRectMake(0, kTopScreenWidth + 5, kappScreenWidth, kappScreenHeight - kTopScreenWidth  - 105);
    }];
    [myCollectionView reloadData];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.2 animations:^{
        myCollectionView.frame = CGRectMake(0, kTopScreenWidth + topMenu.frame.size.height + 10 + heightForLast, kappScreenWidth, kappScreenHeight - kTopScreenWidth - topMenu.frame.size.height - heightForLast - 110);
    }];
    
    [myCollectionView reloadData];
    return YES;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *text = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (text.length) {
            [self.searchData removeAllObjects];
            for (LJArtModel *entity in allDatas) {
                if ([entity.artificerCd containsString:searchText] || [entity.artificerName containsString:searchText] || [entity.fastCode.uppercaseString containsString:searchText.uppercaseString]) {
                    [self.searchData addObject:entity];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [myCollectionView reloadData];
            });
            
        } else {
            self.searchData = [NSMutableArray arrayWithArray:allDatas];
            dispatch_async(dispatch_get_main_queue(), ^{
                [myCollectionView reloadData];
            });
        }
        
    });
}




- (void)sendTButton:(LJTechnicianButton *)tButton {
    
}


- (void) tButtonClick: (UIButton *) sender {
    for (int i = 0; i < 4; i++) {
        UIButton *btn = (UIButton *)[lastTechnicianView viewWithTag:3000 + i];
        [btn setSelected:NO];
    }
    
    [sender setSelected:YES];
    
    self.selectedButton = (LJTechnicianButton *)sender;
}

- (void)selectedMenu:(NSInteger)page {
    self.page = page;
    [datas removeAllObjects];
    switch (page) {
//            @[@"全部", @"上钟", @"空闲",@"预约"];
        case 0:
            //            全部
            datas = [NSMutableArray arrayWithArray:allDatas];
            [myCollectionView reloadData];
            break;
        case 1:
            //            上钟
            
            for (LJArtModel *entity in allDatas) {
                if ([entity.curState isEqualToString:@"onTime"]) {
                    [datas addObject:entity];
                }
            }
            [myCollectionView reloadData];
            break;
        case 2:
            //            空闲
            for (LJArtModel *entity in allDatas) {
                if ([entity.curState isEqualToString:@"free"]) {
                    [datas addObject:entity];
                }
            }
            [myCollectionView reloadData];
            break;
        case 3:
            //            预定
            for (LJArtModel *entity in allDatas) {
                if ([entity.curState isEqualToString:@"reserve"]) {
                    [datas addObject:entity];
                }
            }
            [myCollectionView reloadData];
            break;
        default:
            break;
    }
}

- (void) nextButtonClick:(UIButton *) sender {
    
    if (sender == nextButton) {
        
        //    确定技师是否可用给出提示
        if (self.isConsumption || !self.isConsumption) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (self.projectCd.length) {
                [dic setValue:self.projectCd forKey:@"projectCd"];
            }
            
            NSLog(@"dic = %@", dic);
            
            // 都是空
            if (self.technicianCount == 1) {
                if (!self.artificer1Cd.length) {
                    SHOWTEXTINWINDOW(@"请选择技师", 1);
                    return;
                } else {
                    if ([self.artificer1Cd isEqualToString:@"w"]) {
//                        返回轮钟标识
//                        if ([self.delegate respondsToSelector:@selector(sendTechnician:)]) {
//                            [self.delegate sendTechnician:self];
//                        }
//                        [self.navigationController popViewControllerAnimated:YES];
//                        return;
                    } else if ([self.artificer1Cd isEqualToString:self.detailEntity.artificer1Cd]) {
                        [self.navigationController popViewControllerAnimated:YES];
                        return;
                    }
                    [dic setValue:self.artificer1Cd forKey:@"artificerCd"];
                }
            } else if (self.technicianCount == 2) {
                if (!self.artificer1Cd.length || !self.artificer2Cd.length) {
                    SHOWTEXTINWINDOW(@"请选择技师", 1);
                    return;
                } else {
//                    1 w 2 c
                    if (([self.artificer1SelectType isEqualToString:@"wheelTime"] || self.artificer1Cd.length == 0)&& [self.artificer2SelectType isEqualToString:@"callTime"] && self.artificer2Cd.length) {
                        
                        if (![self.detailEntity.serveStatus isEqualToString:@"suspend"]) {
                            SHOWTEXTINWINDOW(@"非暂停状态技师2只能轮钟", 1.5);
                            return;
                        }
                        
                        if ([self.artificer2Cd isEqualToString:self.detailEntity.artificer2Cd]) {
//                            [self.navigationController popViewControllerAnimated:YES];
//                            return;
                        } else {
//                            if ([self.delegate respondsToSelector:@selector(sendTechnician:)]) {
//                                [self.delegate sendTechnician:self];
//                            }
                            [dic setValue:self.artificer2Cd forKey:@"artificerCd"];
                        }
                    }
//                    1 c 2 w
                    if (([self.artificer2SelectType isEqualToString:@"wheelTime"] || self.artificer2Cd.length == 0) && [self.artificer1SelectType isEqualToString:@"callTime"] && self.artificer1Cd.length) {
                        if ([self.artificer1Cd isEqualToString:self.detailEntity.artificer1Cd]) {
                            
                        } else {
//
                            [dic setValue:self.artificer1Cd forKey:@"artificerCd"];
                        }
                    }
//                    1 w 2 w
                    if ([self.artificer1SelectType isEqualToString:@"wheelTime"] && [self.artificer2SelectType isEqualToString:@"wheelTime"]) {

                        
                    }
//                    1 c 2 c
                    if ([self.artificer1SelectType isEqualToString:@"callTime"] && self.artificer1Cd.length && [self.artificer2SelectType isEqualToString:@"callTime"] && self.artificer2Cd.length ) {
                        if ([self.detailEntity.serveStatus isEqualToString:@"suspend"]) {
                            if ([self.artificer1Cd isEqualToString:self.artificer2Cd]) {
                                SHOWTEXTINWINDOW(@"不能选择两个相同技师", 1);
                                return;
                            }
                            
                        } else {
                            if ([self.artificer1Cd isEqualToString:self.artificer2Cd]) {
                                SHOWTEXTINWINDOW(@"不能选择两个相同技师", 1);
                                return;
                            } else {
                                SHOWTEXTINWINDOW(@"一个客户只能点钟一个技师", 1);
                                return;
                            }
                            
                        }
                        
                    }
                }
            }
            
            if (self.detailEntity.artificer1Cd.length || self.detailEntity.artificer2Cd.length) {
                if (!self.changeStr.length) {
                    SHOWTEXTINWINDOW(@"请选择更换原因", 1);
                    return ;
                }
            }
            
//            NSDictionary *dic = @{@"projectCd":self.projectCd.length ? self.projectCd : @"", @"artificerCd":self.selectedEntity.artificerCd};
            if ([[dic objectForKey:@"artificerCd"] length] && ![[dic objectForKey:@"artificerCd"] isEqualToString:@"w"]) {
                SHOWSTATUSCLEAR
                [[NetWorkingModel sharedInstance] GET:XIAOFEIVERIFIJISHI parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                    if (ISSUCCESS) {
                        if ([[CONTENTOBJ objectForKey:@"waitTime"] integerValue] == 0) {
                            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                            if (self.detailEntity.orderCd.length) {
                                [dic setValue:self.detailEntity.orderCd forKey:@"orderCd"];
                            }
                            
                            if (self.detailEntity.customerCd.length) {
                                [dic setValue:self.detailEntity.customerCd forKey:@"customerCd"];
                            }
                            
                            
                            if (self.detailEntity.sex.length) {
                                [dic setValue:self.detailEntity.sex forKey:@"sex"];
                            }
                            
                            if (self.detailEntity.projectCd.length) {
                                [dic setValue:self.detailEntity.projectCd forKey:@"projectCd"];
                            }
                            
                            if (self.detailEntity.detailNo.length) {
                                [dic setValue:self.detailEntity.detailNo forKey:@"detailNo"];
                            }
                            
                            if (self.artificer2Cd.length) {
                                [dic setValue:self.artificer2Cd forKey:@"artificer2Cd"];
                                [dic setValue:self.artificer2SelectType forKey:@"artificer2SelectType"];
                            }
                            
                            if (self.artificer1Cd.length) {
                                [dic setValue:self.artificer1Cd forKey:@"artificer1Cd"];
                                [dic setValue:self.artificer1SelectType forKey:@"artificer1SelectType"];
                            }
                            
                            if (self.detailEntity.roomCd) {
                                [dic setValue:self.detailEntity.roomCd forKey:@"roomCd"];
                            }
                            if (self.detailEntity.roomName) {
                                [dic setValue:self.detailEntity.roomName forKey:@"roomName"];
                            }
                            
                            if ((![self.artificer1Cd isEqualToString:self.detailEntity.artificer1Cd] && self.detailEntity.artificer1Cd.length) || (![self.artificer2Cd isEqualToString:self.detailEntity.artificer2Cd] && self.detailEntity.artificer2Cd.length)) {
                                if (self.changeStr.length) {
                                    [dic setValue:self.changeStr forKey:@"changeReason"];
                                } else {
                                    SHOWTEXTINWINDOW(@"请选择更换原因", 1);
                                    return ;
                                }
                            }
                            
                            [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
                            
                            [dic setValue:[CONTENTOBJ objectForKey:@"startTime"] forKey:@"startTime"];
                            
                            if (self.isConsumption) {
                                [dic setValue:@"consume" forKey:@"orderFag"];
                            } else {
                                [dic setValue:@"reception" forKey:@"orderFag"];
                            }
                            if (self.selectSex.length) {
                                [dic setValue:self.selectSex forKey:@"selectSex"];
                            }
                            NSLog(@"dic  = %@", dic);
                            [[NetWorkingModel sharedInstance] POST:XIAOFEIINSERTJISHI parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                                DISMISS
                                if (ISSUCCESS) {
                                    if ([self.delegate respondsToSelector:@selector(sendTechnician:)]) {
                                        [self.delegate sendTechnician:self];
                                    }
                                    [self.navigationController popViewControllerAnimated:YES];
                                } else {
                                    if ([OBJMESSAGE isEqualToString:@"error_waiting"]) {
                                        SHOWTEXTINWINDOW(@"多人项目只能选择空闲技师", 1);
                                    } else if ([OBJMESSAGE isEqualToString:@"error_art"]) {
                                        SHOWTEXTINWINDOW(@"插入技师错误", 1);
                                    } else if ([OBJMESSAGE isEqualToString:@"error_sex"]) {
                                        SHOWTEXTINWINDOW(@"性别为空", 1);
                                    } else if ([OBJMESSAGE isEqualToString:@"error_turnNnull"]) {
                                        SHOWTEXTINWINDOW(@"暂时没有空闲技师可以轮钟", 1);
                                    } else if ([OBJMESSAGE isEqualToString:@"error_close"]) {
                                        SHOWTEXTINWINDOW(@"技师选择功能已经关闭，不允许用任何方式选择任何技师", 2);
                                    } else if ([OBJMESSAGE isEqualToString:@"error_onClock"]) {
                                        SHOWTEXTINWINDOW(@"正在上钟，不允许更换技师", 2);
                                    } else {
                                        BADREQUEST
                                    }
                                    
                                }
                                
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                
                            }];
                            
                        } else if ([[CONTENTOBJ objectForKey:@"waitTime"] integerValue] < 0) {
                            DISMISS
                            NSString *str = [NSString stringWithFormat:@"该技师服务所做的项目已超过预订落钟时间%lld分，是否继续预约?", llabs([[CONTENTOBJ objectForKey:@"waitTime"] longLongValue])];
                            self.startTime =  [CONTENTOBJ objectForKey:@"startTime"];
                            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
                            av.tag = 4003;
                            [av show];
                        } else {
                            DISMISS
                            NSString *str =[NSString stringWithFormat:@"%@号技师需要等待%@分钟，约%@上钟，确定点钟？", [CONTENTOBJ objectForKey:@"artificerCd"],[CONTENTOBJ objectForKey:@"waitTime"], [CONTENTOBJ objectForKey:@"startTime"]];
                            self.startTime =  [CONTENTOBJ objectForKey:@"startTime"];
                            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
                            av.tag = 4000;
                            [av show];
                        }
                        
                    } else {
                        DISMISS
                        if ([OBJMESSAGE isEqualToString:@"error_project"]) {
                            //                        没有选择项目  不调用插入技师接口
                            
                            if ([self.delegate respondsToSelector:@selector(sendTechnician:)]) {
                                [self.delegate sendTechnician:self];
                            }
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            BADREQUEST
                        }
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            } else {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (self.detailEntity.orderCd.length) {
                    [dic setValue:self.detailEntity.orderCd forKey:@"orderCd"];
                }
                
                if (self.detailEntity.customerCd.length) {
                    [dic setValue:self.detailEntity.customerCd forKey:@"customerCd"];
                }
                
                if (self.detailEntity.projectCd.length) {
                    [dic setValue:self.detailEntity.projectCd forKey:@"projectCd"];
                }
                
                if (self.detailEntity.detailNo.length) {
                    [dic setValue:self.detailEntity.detailNo forKey:@"detailNo"];
                }
                
                if (self.detailEntity.sex.length) {
                    [dic setValue:self.detailEntity.sex forKey:@"sex"];
                }
                
                if (self.artificer2Cd.length) {
                    [dic setValue:self.artificer2Cd forKey:@"artificer2Cd"];
                    [dic setValue:self.artificer2SelectType forKey:@"artificer2SelectType"];
                }
                
                if (self.artificer1Cd.length) {
                    [dic setValue:self.artificer1Cd forKey:@"artificer1Cd"];
                    [dic setValue:self.artificer1SelectType forKey:@"artificer1SelectType"];
                }
                
                [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
                
                if (self.isConsumption) {
                    [dic setValue:@"consume" forKey:@"orderFag"];
                } else {
                    [dic setValue:@"reception" forKey:@"orderFag"];
                }
                
                if ((![self.artificer1Cd isEqualToString:self.detailEntity.artificer1Cd] && self.detailEntity.artificer1Cd.length) || (![self.artificer2Cd isEqualToString:self.detailEntity.artificer2Cd] && self.detailEntity.artificer2Cd.length)) {
                    if (self.changeStr.length) {
                        [dic setValue:self.changeStr forKey:@"changeReason"];
                    } else {
                        SHOWTEXTINWINDOW(@"请选择更换原因", 1);
                        return ;
                    }
                }
                if (self.selectSex.length) {
                    [dic setValue:self.selectSex forKey:@"selectSex"];
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
                        if ([self.delegate respondsToSelector:@selector(sendTechnician:)]) {
                            [self.delegate sendTechnician:self];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        if ([OBJMESSAGE isEqualToString:@"error_waiting"]) {
                            SHOWTEXTINWINDOW(@"多人项目只能选择空闲技师", 1);
                        } else if ([OBJMESSAGE isEqualToString:@"error_art"]) {
                            SHOWTEXTINWINDOW(@"插入技师错误", 1);
                        } else if ([OBJMESSAGE isEqualToString:@"error_sex"]) {
                            SHOWTEXTINWINDOW(@"性别为空", 1);
                        } else if ([OBJMESSAGE isEqualToString:@"error_turnNnull"]) {
                            SHOWTEXTINWINDOW(@"暂时没有空闲技师可以轮钟", 1);
                        } else if ([OBJMESSAGE isEqualToString:@"error_close"]) {
                            SHOWTEXTINWINDOW(@"技师选择功能已经关闭，不允许用任何方式选择任何技师", 2);
                        } else if ([OBJMESSAGE isEqualToString:@"error_onClock"]) {
                            SHOWTEXTINWINDOW(@"正在上钟，不允许更换技师", 2);
                        } else {
                            BADREQUEST
                        }
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        } else {
            LJTechnicianButton *tButton1 = (LJTechnicianButton *)[lastTechnicianView viewWithTag:3000];
            if ([tButton1.titleLabel.text isEqualToString:@"空"]) {
                SHOWTEXTINWINDOW(@"请选择技师", 1);
                return;
            }
            if ([self.delegate respondsToSelector:@selector(sendTechnician:)]) {
                [self.delegate sendTechnician:self];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }

    } else if (sender == lunButton) {
//        存在其他项目选择了技师但是未落钟的情况下  不能选择轮钟
        
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"未指定" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
        [as showInView:self.view];
        
        if (!self.canLunFlag) {
            SHOWTEXTINWINDOW(@"该客户有其他明细未完成，不能选择轮钟", 1);
            return;
        }
        
        self.selectedButton.titleName = @"轮钟";
        self.selectedButton.technician = [[LJArtModel alloc] init];
        self.selectedButton.technician.artificerCd = @"w";
        self.selectedButton.technician.artificerName = @"轮钟";
        
        self.selectedEntity = self.selectedButton.technician;
        
        if (self.selectedButton.tag == 3000) {
            self.artificer1Cd = @"w";
            self.artificer1SelectType = @"wheelTime";
        } else if (self.selectedButton.tag == 3001) {
            self.artificer2Cd = @"w";
            self.artificer2SelectType = @"wheelTime";
        }

    }
    
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.selectSex = [NSString stringWithFormat:@"%ld", (long)buttonIndex + 1];
    [self nextButtonClick:nextButton];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DISMISS
    if (alertView.tag == 4000 || alertView.tag == 4003) {
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
            
            if (self.detailEntity.projectCd.length) {
                [dic setValue:self.detailEntity.projectCd forKey:@"projectCd"];
            }
            
            if (self.detailEntity.detailNo.length) {
                [dic setValue:self.detailEntity.detailNo forKey:@"detailNo"];
            }
            
            if (self.detailEntity.sex.length) {
                [dic setValue:self.detailEntity.sex forKey:@"sex"];
            }
            
            if (self.selectedEntity.artificerCd.length) {
                [dic setValue:self.selectedEntity.artificerCd forKey:@"artificer1Cd"];
            }
            
            
            [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
            if (self.startTime.length) {
                [dic setValue:self.startTime forKey:@"startTime"];
            }
            if (self.isConsumption) {
                [dic setValue:@"consume" forKey:@"orderFag"];
            } else {
                [dic setValue:@"reception" forKey:@"orderFag"];
            }
            
            if ((![self.artificer1Cd isEqualToString:self.detailEntity.artificer1Cd] && self.detailEntity.artificer1Cd.length) || (![self.artificer2Cd isEqualToString:self.detailEntity.artificer2Cd] && self.detailEntity.artificer2Cd.length)) {
                if (self.changeStr.length) {
                    [dic setValue:self.changeStr forKey:@"changeReason"];
                } else {
                    SHOWTEXTINWINDOW(@"请选择更换原因", 1);
                    return ;
                }
            }
            if (self.selectSex.length) {
                [dic setValue:self.selectSex forKey:@"selectSex"];
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
                    if ([self.delegate respondsToSelector:@selector(sendTechnician:)]) {
                        [self.delegate sendTechnician:self];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    if ([OBJMESSAGE isEqualToString:@"error_waiting"]) {
                        SHOWTEXTINWINDOW(@"多人项目只能选择空闲技师", 1);
                    } else if ([OBJMESSAGE isEqualToString:@"error_art"]) {
                        //                                        [[iToast makeText:@"插入技师错误"] show];
                        SHOWTEXTINWINDOW(@"插入技师错误", 1);
                    } else if ([OBJMESSAGE isEqualToString:@"error_sex"]) {
                        //                                        [[iToast makeText:@"性别为空"] show];
                        SHOWTEXTINWINDOW(@"性别为空", 1);
                    } else if ([OBJMESSAGE isEqualToString:@"error_turnNnull"]) {
                        //                                        [[iToast makeText:@"暂时没有空闲技师可以轮钟"] show];
                        SHOWTEXTINWINDOW(@"暂时没有空闲技师可以轮钟", 1);
                    } else if ([OBJMESSAGE isEqualToString:@"error_close"]) {
                        SHOWTEXTINWINDOW(@"技师选择功能已经关闭，不允许用任何方式选择任何技师", 2);
                    } else if ([OBJMESSAGE isEqualToString:@"error_onClock"]) {
                        SHOWTEXTINWINDOW(@"正在上钟，不允许更换技师", 2);
                    } else {
                        BADREQUEST
                    }
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            
            
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(kappScreenWidth / 4, 60);
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return datas.count;
    return mySearchBar.isHidden ? self.datas.count : self.searchData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    LJArtModel *entity = mySearchBar.isHidden ? [datas objectAtIndex:indexPath.row] : [self.searchData objectAtIndex:indexPath.row];
    
    UIButton *btn = (UIButton *) [cell viewWithTag:1000];
    if (!btn) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [btn setBackgroundImage:[LJColorImage imageWithColor:gray238] forState:UIControlStateNormal];
        
        [btn setTitleColor:WhiteColor forState:UIControlStateSelected];
        
        
//        [btn setBackgroundImage:[LJColorImage imageWithColor:NavBackColor] forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
//        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
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
        UILabel *label = [UILabel new];
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14, 14));
            make.top.equalTo(btn.mas_top).offset(2);
            make.right.equalTo(btn.mas_right).offset(-2);
        }];
        label.font = FONTBOLD(15);
        label.textColor = WhiteColor;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"√";
        label.layer.masksToBounds = YES;
        label.tag = 1001;
        
    }
    //    [btn setTitle:@"" forState:UIControlStateSelected];
    
    
    [btn setTitle:[NSString stringWithFormat:@"%@(%@)\n%@", entity.artificerCd, [entity.sex isEqualToString:@"woman"] ? @"女" : @"男", entity.artificerName] forState:UIControlStateNormal];
    
    if ([entity.curState isEqualToString:@"free"]) {
        [btn setBackgroundImage:[LJColorImage imageWithColor:[UIColor colorWithRed:153/255.0f green:228/255.0f blue:153/255.0f alpha:1]] forState:UIControlStateNormal];
        
        
    } else if([entity.curState isEqualToString:@"reserve"]) {
        [btn setBackgroundImage:[LJColorImage imageWithColor:[UIColor colorWithRed:242/255.0f green:219/255.0f blue:157/255.0f alpha:1]] forState:UIControlStateNormal];
        
    } else if([entity.curState isEqualToString:@"onTime"]) {
        [btn setBackgroundImage:[LJColorImage imageWithColor:[UIColor colorWithRed:249/255.0f green:167/255.0f blue:167/255.0f alpha:1]] forState:UIControlStateNormal];
        
    }
    
    [btn setSelected:entity.isChoosed];
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    label.hidden = !entity.isChoosed;
    
    
    return cell;
    
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIButton *btn = (UIButton *) [cell viewWithTag:1000];
    
    LJArtModel *entity = mySearchBar.isHidden ? [datas objectAtIndex:indexPath.row] : [self.searchData objectAtIndex:indexPath.row];
    if (self.isConsumption) {
        if (![entity.curState isEqualToString:@"free"] && !self.canSelectNotFree && ![entity.artificerCd isEqualToString:_doubleEntity.artificer1Cd] && _doubleEntity.artificer1Cd.length && [_doubleEntity.artificer1SelectType isEqualToString:@"callTime"]) {
            NSString *str = [NSString stringWithFormat:@"您可以选择【%@号】技师或者选择更换其他空闲技师", _doubleEntity.artificer1Cd];
            SHOWTEXTINWINDOW(str, 1);
            return;
        }
        
        
        if ([self.detailEntity.serveStatus isEqualToString:@"wait"] || [self.detailEntity.serveStatus isEqualToString:@"overdue"] || [self.detailEntity.serveStatus isEqualToString:@"nothing"]) {
        } else if ([self.detailEntity.serveStatus isEqualToString:@"nothing"]) {
            if (self.selectedButton.tag == 3001) {
                SHOWTEXTINWINDOW(@"该工位只能选择轮钟", 1);
                return;
            }
        }
        
        if ([self.detailEntity.serviceHeadcount integerValue] > 1) {
            if (![entity.curState isEqualToString:@"free"]) {
                SHOWTEXTINWINDOW(@"多人项目只能选择空闲技师", 1);
                return;
            }
        }
        
        if (self.artRecModel) {
            //        有正在上钟的项目时  其他明细点钟只能选择该技师
//            if (![entity.artificerCd isEqualToString:self.artRecModel.artificer1Cd]) {
//                SHOWTEXTINWINDOW(@"您选择的技师与正在上钟的点钟技师不一致", 1);
//                return;
//            }
        }
    }

    self.selectedEntity = entity;
    for (LJArtModel *model in allDatas) {
        if ([entity.artificerCd isEqualToString:model.artificerCd]) {
            model.isChoosed = YES;
        } else {
            model.isChoosed = NO;
        }
    }
    
    [btn setSelected:entity.isChoosed];
    self.selectedButton.titleName = entity.artificerCd;
    self.selectedButton.technician = entity;
    
    if (self.selectedButton.tag == 3000) {
        self.artificer1Cd = entity.artificerCd;
        self.artificer1SelectType = @"callTime";
    } else if (self.selectedButton.tag == 3001) {
        self.artificer2Cd = entity.artificerCd;
        self.artificer2SelectType = @"callTime";
    }
    
    [myCollectionView reloadData];
}

- (void) buttonClick:(UIButton *) sender {
    [sender setSelected:!sender.isSelected];
}

- (void)leftButtonPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonPressed {
    
    if (mySearchBar.hidden) {
        mySearchBar.hidden = NO;
        [topView.rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [topView.rightButton setTitle:@"取消" forState:UIControlStateNormal];
        myCollectionView.mj_header = nil;
    } else {
        myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadData];
        }];
        //        搜索
        self.keyWords = [mySearchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        mySearchBar.hidden = YES;
        [mySearchBar endEditing:YES];
        
        [topView.rightButton setImage:[UIImage imageNamed:@"icon_Search_bg color"] forState:UIControlStateNormal];
        [topView.rightButton setTitle:@"" forState:UIControlStateNormal];
    }
    
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
