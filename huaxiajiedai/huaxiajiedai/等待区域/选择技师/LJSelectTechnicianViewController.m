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
    
    UIColor *lightGrenn;
}

@end

@implementation LJSelectTechnicianViewController
@synthesize topView, titleString, myCollectionView, datas, mySearchBar, myControl, pickView, jishiView;

- (void) loadData {
    lightGrenn = [UIColor colorWithRed:153/255.0f green:228/255.0f blue:153/255.0f alpha:1];
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
        heightForLast = 30+50+([self.detailEntity.serviceHeadcount intValue]-1)/3*50;
    }
    
    
//    if ([self.titleString isEqualToString:@"更换技师"]) {
//        [lastTechnicianView setHidden:NO];
//    } else {
//        [lastTechnicianView setHidden:YES];
//    }
   
    
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
    
    // 技师显示区域
    // 当前技师长按删除 30 每行高度 50
    NSInteger count = [self.detailEntity.serviceHeadcount integerValue];
    float height = 30+50+(count-1)/3*50;
    jishiView = [[UIView alloc] init];
    [self.view addSubview:jishiView];
    [jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(height + 80);
        make.top.mas_equalTo(kTopScreenWidth);
    }];
    
    // 当前技师，长按删除。
    UILabel *selectedLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, kappScreenWidth, 30)];
    [jishiView addSubview:selectedLable];
    [selectedLable setText:@"当前技师（长按删除）"];
    [selectedLable setTextColor:navLightBrownColor];
    [selectedLable setFont:FONT13];
    
//    [jishiView setCount:self.detailEntity.artificerList];
    
    float width = kappScreenWidth/3;
    
    for (int i = 0; i < count; i++) {
        NSString *artificerName = self.detailEntity.artificerList.count > i ? [[self.detailEntity.artificerList objectAtIndex:i] objectForKey:@"artificerName"] : @"";
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 5000 + i;
        btn.frame = CGRectMake(i%3  * width+4, 4 + i / 3 * 50 + 30 , kappScreenWidth/3 - 14, 44);
        [jishiView addSubview:btn];
        [btn setBackgroundColor:gray210];
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        [btn setTitle:artificerName forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == count -1 ) {
            [btn setSelected:YES];
            [btn setBackgroundColor:lightGrenn];
            if (btn.titleLabel.text.length) {
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jishiBtnLongPress:)];
                longPress.minimumPressDuration = 0.8;
                [btn addGestureRecognizer:longPress];
            }
        }
        
        [btn addTarget:self action:@selector(jishiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        
        
    }
    
    lastTechnicianView = [[UIView alloc] initWithFrame:CGRectMake(0, height, kappScreenWidth, 80)];
    [jishiView addSubview:lastTechnicianView];
//    [lastTechnicianView setHidden:YES];
//    [lastTechnicianView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(50);
//        make.left.equalTo(jishiView.mas_left);
//        make.right.equalTo(jishiView.mas_right);
//        make.bottom.equalTo(jishiView.mas_bottom);
//    }];
//    UILabel *label = [UILabel new];
//    [lastTechnicianView addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(lastTechnicianView).offset(20);
//        make.top.equalTo(lastTechnicianView).offset(10);
//        make.height.mas_equalTo(FONT12.lineHeight);
//    }];
//    label.text = @"当前技师";
//    label.textColor = self.isConsumption ? navLightBrownColor : NavBackColor;
//    label.font = FONT12;
    changeResonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastTechnicianView addSubview:changeResonBtn];
    changeResonBtn.backgroundColor = gray238;
    [changeResonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastTechnicianView.mas_left).offset(4);
        make.top.equalTo(lastTechnicianView).offset(10);
        make.right.equalTo(lastTechnicianView).offset(-10);
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

// 选择，更换技师
- (void) jishiBtnLongPress:(UILongPressGestureRecognizer *) sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIButton *btn = (UIButton *) sender.view;
        self.longPressTag = btn.tag;
        if (self.detailEntity.artificerList.count > 1) {
            UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"请选择菜单" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除该技师", @"切换轮点钟", nil];
            as.tag = 6000;
            [as showInView:self.view];
        } else {
            UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"请选择菜单" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"切换轮点钟", nil];
            as.tag = 6000;
            [as showInView:self.view];
        }
        
    }

    
    
}

// 当前技师点击按钮之后
- (void) jishiButtonClicked:(UIButton *) sender {
    for (int i = 0; i < [self.detailEntity.serviceHeadcount integerValue]; i ++ ) {
        UIButton *btn = (UIButton *)[jishiView viewWithTag:5000+i];
        [btn setSelected:NO];
        [btn setBackgroundColor:gray210];
        while (btn.gestureRecognizers.count) {
            [btn removeGestureRecognizer:[btn.gestureRecognizers objectAtIndex:0]];
        }
        
    }
    [sender setSelected:YES];
    [sender setBackgroundColor:lightGrenn];
    if (sender.titleLabel.text.length) {// 选择了技师
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jishiBtnLongPress:)];
        longPress.minimumPressDuration = 0.8;
        [sender addGestureRecognizer:longPress];
        //显示更换删除原因
        [lastTechnicianView setHidden:NO];
//        topMenu.frame =  CGRectMake(topMenu.frame.origin.x, topMenu.frame.origin.y, topMenu.frame.size.width, topMenu.frame.size.height + 50);
        if (!self.selectedJishi) {
            NSInteger count = [self.detailEntity.serviceHeadcount integerValue];
            float height = 30+50+(count-1)/3*50 + 50;
        
            [jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.height.mas_equalTo(height);
                make.top.mas_equalTo(kTopScreenWidth);
            }];
            topMenu.center = CGPointMake(topMenu.center.x, topMenu.center.y + 80);
            myCollectionView.center = CGPointMake(myCollectionView.center.x, myCollectionView.center.y + 80);
//            myCollectionView.bounds = CGRectMake(myCollectionView.frame.origin.x, myCollectionView.frame.origin.y, myCollectionView.frame.size.width, myCollectionView.frame.size.height - 50);
            self.selectedJishi = YES;
        }
        
//
    } else {
        if (self.selectedJishi) {
            NSInteger count = [self.detailEntity.serviceHeadcount integerValue];
            float height = 30+50+(count-1)/3*50;
        
            [jishiView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.height.mas_equalTo(height);
                make.top.mas_equalTo(kTopScreenWidth);
            }];
            topMenu.center = CGPointMake(topMenu.center.x, topMenu.center.y - 80);
            myCollectionView.center = CGPointMake(myCollectionView.center.x, myCollectionView.center.y - 80);
//            myCollectionView.bounds = CGRectMake(myCollectionView.frame.origin.x, myCollectionView.frame.origin.y, myCollectionView.frame.size.width, myCollectionView.frame.size.height + 50);
            
            self.selectedJishi = NO;
        }
    }
    
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
            // 点钟
            [dic setValue:[NSNumber numberWithInt:2] forKey:@"operateType"];
            // 更新数  1
            [dic setValue:[NSNumber numberWithInt:1] forKey:@"modifyCount"];
            // 旧技师 oldArtificerCd
            [dic setValue:@"" forKey:@"oldArtificerCd"];
            // 新技师  artificerCd
            [dic setValue:self.selectedEntity.artificerCd forKey:@"artificerCd"];
            // 新计时:1:是,0:否   isRetime
            [dic setValue:[NSNumber numberWithInt:0] forKey:@"isRetime"];
            NSLog(@"dic = %@", dic);
            
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
                            if (self.projectCd.length) {
                                [dic setValue:self.projectCd forKey:@"projectCd"];
                            }
                            
                            // 点钟
                            [dic setValue:[NSNumber numberWithInt:2] forKey:@"operateType"];
                            // 更新数  1
                            
                            [dic setValue:self.detailEntity.modifyCount forKey:@"modifyCount"];
                            // 旧技师 oldArtificerCd
                            [dic setValue:@"" forKey:@"oldArtificerCd"];
                            // 新技师  artificerCd
                            [dic setValue:self.selectedEntity.artificerCd forKey:@"artificerCd"];
                            // 新计时:1:是,0:否   isRetime
                            [dic setValue:[NSNumber numberWithInt:0] forKey:@"isRetime"];
                            if (self.detailEntity.roomCd) {
                                [dic setValue:self.detailEntity.roomCd forKey:@"roomCd"];
                            }
                            if (self.detailEntity.roomName) {
                                [dic setValue:self.detailEntity.roomName forKey:@"roomName"];
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
                SHOWTEXTINWINDOW(@"请先选择技师", 2);
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
        if (!self.canLunFlag) {
            SHOWTEXTINWINDOW(@"该客户有其他明细未完成，不能选择轮钟", 1);
            return;
        }
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"未指定" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
        [as showInView:self.view];
        
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
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    if (self.projectCd.length) {
        [dic setValue:self.projectCd forKey:@"projectCd"];
    }
    
    if (self.detailEntity.orderCd.length) {
        [dic setValue:self.detailEntity.orderCd forKey:@"orderCd"];
    }
    
    if (self.detailEntity.customerCd.length) {
        [dic setValue:self.detailEntity.customerCd forKey:@"customerCd"];
    }
    
    
    if (self.detailEntity.sex.length) {
        [dic setValue:self.detailEntity.sex forKey:@"sex"];
    }
    
    
    if (self.detailEntity.detailNo.length) {
        [dic setValue:self.detailEntity.detailNo forKey:@"detailNo"];
    }
    
    
    if (self.detailEntity.roomCd) {
        [dic setValue:self.detailEntity.roomCd forKey:@"roomCd"];
    }
    if (self.detailEntity.roomName) {
        [dic setValue:self.detailEntity.roomName forKey:@"roomName"];
    }
    if (self.detailEntity.modifyCount) {
        [dic setValue:self.detailEntity.modifyCount forKey:@"modifyCount"];
    }
    
    [dic setValue:@"" forKey:@"artificerCd"];
    [dic setValue:@"" forKey:@"isRetime"];
    
    [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
    
    if (self.isConsumption) {
        [dic setValue:@"consume" forKey:@"orderFag"];
    } else {
        [dic setValue:@"reception" forKey:@"orderFag"];
    }
    if (self.selectSex.length) {
        [dic setValue:self.selectSex forKey:@"selectSex"];
    }
    NSLog(@"dic  = %@", dic);
    if (actionSheet.tag == 6000) {
        NSLog(@"%ld", buttonIndex);
        if (self.detailEntity.artificerList.count == 1) {
            if(buttonIndex == 0) {
                // 切换轮点钟
                if (self.changeStr.length) {
                    [dic setValue:self.changeStr forKey:@"changeReason"];
                } else {
                    SHOWTEXTINWINDOW(@"请选择更换原因", 1);
                    return ;
                }
                NSDictionary *selectEntity = [self.detailEntity.artificerList objectAtIndex:self.longPressTag - 5000];
                NSLog(@"%@", selectEntity);
                if ([[selectEntity objectForKey:@"selectType"] isEqual:@"callTime"]) {
                    // 点钟转轮钟
                    self.operateType = 7;
                    [dic setValue:[selectEntity objectForKey:@"artificerCd"] forKey:@"oldArtificerCd"];
                    [dic setValue:[NSNumber numberWithInteger:self.operateType] forKey:@"operateType"];
                } else {
                    // 轮钟转点钟
                    self.operateType = 6;
                    [dic setValue:[selectEntity objectForKey:@"artificerCd"] forKey:@"oldArtificerCd"];
                    [dic setValue:[NSNumber numberWithInteger:self.operateType] forKey:@"operateType"];
                }
                
                
            } else {
                //取消
                return;
            }
        } else if (self.detailEntity.artificerList.count > 1) {
            if(buttonIndex == 0) {
                // 删除技师
                if (self.changeStr.length) {
                    [dic setValue:self.changeStr forKey:@"changeReason"];
                } else {
                    SHOWTEXTINWINDOW(@"请选择更换原因", 2);
                    return ;
                }
                NSDictionary *selectEntity = [self.detailEntity.artificerList objectAtIndex:self.longPressTag - 5000];
                [dic setValue:[selectEntity objectForKey:@"artificerCd"] forKey:@"oldArtificerCd"];
                self.operateType = 5;
                [dic setValue:[NSNumber numberWithInteger:self.operateType] forKey:@"operateType"];
            } else if (buttonIndex == 1) {
                // 切换轮点钟
                 if (self.changeStr.length) {
                    [dic setValue:self.changeStr forKey:@"changeReason"];
                } else {
                    SHOWTEXTINWINDOW(@"请选择更换原因", 2);
                    return ;
                }
                
                NSDictionary *selectEntity = [self.detailEntity.artificerList objectAtIndex:self.longPressTag - 5000];
                NSLog(@"%@", selectEntity);
                if ([[selectEntity objectForKey:@"selectType"] isEqual:@"callTime"]) {
                    // 点钟转轮钟
                    self.operateType = 7;
                    [dic setValue:[selectEntity objectForKey:@"artificerCd"] forKey:@"oldArtificerCd"];
                    [dic setValue:[NSNumber numberWithInteger:self.operateType] forKey:@"operateType"];
                } else {
                    // 轮钟转点钟
                    self.operateType = 6;
                    [dic setValue:[selectEntity objectForKey:@"artificerCd"] forKey:@"oldArtificerCd"];
                    [dic setValue:[NSNumber numberWithInteger:self.operateType] forKey:@"operateType"];
                }
            } else {
                // 取消
                return;
            }
        }
    } else {
        // 轮钟
        self.selectSex = [NSString stringWithFormat:@"%ld", (long)buttonIndex + 1];
    //        [self nextButtonClick:nextButton];
        if (self.selectSex.length) {
            [dic setValue:self.selectSex forKey:@"selectSex"];
        }
        self.operateType = 1;
        [dic setValue:[NSNumber numberWithInteger:self.operateType] forKey:@"operateType"];
        [dic setValue:@"" forKey:@"oldArtificerCd"];
    }
        

    
   

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
                SHOWTEXTINWINDOW(@"暂时没有空闲技师可以轮钟", 1.5);
                return;
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
