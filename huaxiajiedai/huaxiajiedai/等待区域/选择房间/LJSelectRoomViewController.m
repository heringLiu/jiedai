//
//  LJSelectRoomViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/4/21.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJSelectRoomViewController.h"
#import "LJRoomListCollectionViewCell.h"
#import "LJRoomListView.h"

@interface LJSelectRoomViewController () <LJRoomListDelegate> {
    UIButton *nextButton;
    
    UIScrollView *mainScrollView;
    
    TopScrollViewMenuView *topMenu;
    
    
}


@end

@implementation LJSelectRoomViewController
@synthesize topView, titleString, myCollectionView, datas, mySearchBar;

- (void) loadData {
    NSLog(@"STORCDSTRING %@", STORCDSTRING);
    
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] GET:ROOMINDEX parameters:@{@"storeCd":STORCDSTRING} success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        
        if (ISSUCCESS) {
            //            [self.dataList removeAllObjects];
            //            [self.titleArray removeAllObjects];
            [self.searchList removeAllObjects];
            [self.allDatas removeAllObjects];
            
            if (self.allDatas == nil) {
                self.allDatas = [NSMutableArray array];
            }
            
            if (self.titleArray == nil) {
                self.titleArray = [NSMutableArray array];
            }
            
            NSMutableArray *titleArr = [NSMutableArray array];
            NSMutableArray *dataArr = [NSMutableArray array];
            for (NSDictionary *dic in CONTENTOBJ) {
                LJFloorModel *floorModel = [[LJFloorModel alloc] init];
                [floorModel setValuesForKeysWithDictionary:dic];
                [dataArr addObject:floorModel];
                [titleArr addObject:[NSString stringWithFormat:@"%@层", floorModel.floor]];
            }
            
            if (self.titleArray.count == titleArr.count) {
                self.dataList = [NSMutableArray arrayWithArray:dataArr];
                for (NSInteger i = 0; i < self.titleArray.count; i++) {
                    LJRoomListView *roomListView = (LJRoomListView *)[self.mainScrollView viewWithTag:i + 4000];
                    roomListView.dataList = [[self.dataList objectAtIndex:i] rooms];
                    [roomListView.myCollectionView.mj_header endRefreshing];
                }
            } else {
                self.dataList = [NSMutableArray arrayWithArray:dataArr];
                self.titleArray = [NSMutableArray arrayWithArray:titleArr];
                [topMenu setMenuListWithData:[NSMutableArray arrayWithArray:self.titleArray]];
                self.mainScrollView.contentSize = CGSizeMake(kappScreenWidth * self.titleArray.count, self.mainScrollView.frame.size.height);
                for (NSInteger i = 0; i < self.titleArray.count; i++) {
                    LJRoomListView *roomListView = [[LJRoomListView alloc] initWithFrame:CGRectMake(kappScreenWidth * i, 0, kappScreenWidth, self.mainScrollView.frame.size.height)];
                    roomListView.delegate = self;
                    roomListView.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                        [self loadData];
                    }];
                    roomListView.tag = i + 4000;
                    roomListView.superVC = nil;
                    [self.mainScrollView addSubview:roomListView];
                    roomListView.dataList = [[self.dataList objectAtIndex:i] rooms];
                    
                }
                
            }
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (LJFloorModel *entity in self.dataList) {
                    [self.allDatas addObjectsFromArray:entity.rooms];
                }
            });
            
            
            //            [roomList.myCollectionView.mj_header endRefreshing];
            
            
        } else {
            BADREQUEST
        }
        [myCollectionView.mj_header endRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [myCollectionView.mj_header endRefreshing];

    }];
}

- (void)sendRoomModel:(LJRoomModel *)room {
    for (LJRoomModel *entity  in self.allDatas) {
        if ([entity.roomCd isEqualToString:room.roomCd]) {
            entity.isChoosed = YES;
        } else {
            entity.isChoosed = NO;
        }
    }
    for (NSInteger i = 0; i < self.titleArray.count; i++) {
        LJRoomListView *roomListView = (LJRoomListView *)[self.mainScrollView viewWithTag:i + 4000];
        roomListView.dataList = [[self.dataList objectAtIndex:i] rooms];
        [roomListView.myCollectionView.mj_header endRefreshing];
    }
    
    self.selectedRoom = room;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    datas = [NSMutableArray array];
    self.dataList = [NSMutableArray array];
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    topView.delegate = self;
    topView.backgroundColor = self.isConsumption ? navLightBrownColor : NavBackColor;
    [self.view addSubview:topView];
    topView.titleLabel.text = titleString;
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
//    [topView.rightButton setImage:[UIImage imageNamed:@"icon_Search_bg color"] forState:UIControlStateNormal];
    topView.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    topView.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    topView.rightButton.hidden = YES;
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 20, kappScreenWidth - 80, 40)];
    //    searchBar.
    [topView addSubview:mySearchBar];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"请输入房间编号、名称或拼音简码";

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
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth + topMenu.frame.size.height + 10, kappScreenWidth, kappScreenHeight - kTopScreenWidth - topMenu.frame.size.height - 110)];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.bounces = NO;
    [self.view addSubview:self.mainScrollView];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.bottom.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(60);
    }];
    [nextButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    nextButton.backgroundColor = self.isConsumption ? navLightBrownColor : NavBackColor;
    [nextButton setTitle:@"确定" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = 30;
    
    [self loadData];
    
    myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    [myCollectionView.mj_header beginRefreshing];
}

- (void) nextButtonClick:(UIButton *) sender {
    
    if (self.selectedRoom) {
        if ([self.delegate respondsToSelector:@selector(sendRoom:)]) {
            [self.delegate sendRoom:self.selectedRoom];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        SHOWTEXTINWINDOW(@"请选择项目", 1);
    }
    
   
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(kappScreenWidth / 4, 60);
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return mySearchBar.isHidden ? self.datas.count : self.searchData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LJRoomListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setCellWitdData:[self.dataList objectAtIndex:indexPath.row] ];
    
    return cell;
    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    
//    UIButton *btn = (UIButton *) [cell viewWithTag:1000];
//    if (!btn) {
//        btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitleColor:gray104 forState:UIControlStateNormal];
//        [btn setTitleColor:WhiteColor forState:UIControlStateSelected];
//        
//        [btn setBackgroundImage:[LJColorImage imageWithColor:gray238] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[LJColorImage imageWithColor:NavBackColor] forState:UIControlStateSelected];
//        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        btn.userInteractionEnabled = NO;
//        
//        btn.titleLabel.font = FONT14;
//        btn.titleLabel.numberOfLines = 0;
//        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        
//        btn.tag = 1000;
//        [cell addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(cell).offset(8);
//            make.right.equalTo(cell).offset(-8);
//            make.top.equalTo(cell).offset(5);
//            make.bottom.equalTo(cell).offset(-5);
//        }];
//        btn.clipsToBounds = YES;
//        btn.layer.masksToBounds = YES;
//        btn.layer.cornerRadius = 6;
//    }
//    LJRoomModel *entity =  mySearchBar.isHidden ? [datas objectAtIndex:indexPath.row] : [self.searchData objectAtIndex:indexPath.row];
//    
//    if ([entity.manNum integerValue] + [entity.womanNum integerValue] == [entity.sofaQty integerValue]) {
//        [btn setBackgroundImage:[LJColorImage imageWithColor:[UIColor colorWithRed:253/255.0f green:159/255.0f blue:142/255.0f alpha:1]] forState:UIControlStateNormal];
//        
//        [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
//    } else {
//        [btn setBackgroundImage:[LJColorImage imageWithColor:gray238] forState:UIControlStateNormal];
//        [btn setTitleColor:gray104 forState:UIControlStateNormal];
//    }
//    
//    [btn setTitle:[NSString stringWithFormat:@"%@\n%@", entity.roomCd, entity.roomName] forState:UIControlStateNormal];
//    [btn setSelected:entity.isChoosed];
//    
//    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     LJRoomModel *entity =  mySearchBar.isHidden ? [datas objectAtIndex:indexPath.row] : [self.searchData objectAtIndex:indexPath.row];
    if ([entity.manNum integerValue] + [entity.womanNum integerValue] == [entity.sofaQty integerValue]) {
        return;
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    for (LJRoomModel *entity in self.allDatas) {
        entity.isChoosed = NO;
    }
    
    [ mySearchBar.isHidden ? [datas objectAtIndex:indexPath.row] : [self.searchData objectAtIndex:indexPath.row] setIsChoosed:YES];
    self.selectedRoom =  mySearchBar.isHidden ? [datas objectAtIndex:indexPath.row] : [self.searchData objectAtIndex:indexPath.row];
    [myCollectionView reloadData];
    
}

- (void)selectedMenu:(NSInteger)page {
    self.page = page;
    self.mainScrollView.contentOffset = CGPointMake(self.page * kappScreenWidth, 0);
    self.datas = [[self.dataList objectAtIndex:page] rooms];
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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.3 animations:^{
        topMenu.frame = CGRectMake(0, kTopScreenWidth, kappScreenWidth, 0);
        myCollectionView.frame = CGRectMake(0, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth - 49);
        
    }];
    datas = self.allDatas;
    [myCollectionView reloadData];
    return YES;
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.3 animations:^{
        topMenu.frame = CGRectMake(0, kTopScreenWidth, kappScreenWidth, 50);
        myCollectionView.frame = CGRectMake(0, kTopScreenWidth + 50, kappScreenWidth, kappScreenHeight - kTopScreenWidth - 50 - 49);
    }];
    datas = [[self.dataList objectAtIndex:self.page] rooms];
    [myCollectionView reloadData];
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *str = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"str = %@", str);
    if (str.length) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableArray *arr = [NSMutableArray array];
            for (LJRoomModel *entity in self.allDatas) {
                if ([entity.roomCd containsString:str] || [entity.roomName containsString:str] || [entity.roomEname.uppercaseString containsString:str.uppercaseString]) {
                    [arr addObject:entity];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                datas = arr;
                [myCollectionView reloadData];
            });
            
        });
    } else {
        datas = self.allDatas;
        [myCollectionView reloadData];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.page = scrollView.contentOffset.x/kappScreenWidth;
    topMenu.selectedIndex = self.page;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
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
