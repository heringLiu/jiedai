//
//  LJRoomStateViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/4/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJRoomStateViewController.h"
#import "TopScrollViewMenuView.h"
#import "LJRoomListView.h"
#import "ShoppingMallTabBarViewController.h"
#import "LJColorImage.h"
#import "LJCollectViewController.h"
#import "LJLoginViewController.h"

@interface LJRoomStateViewController () <UIGestureRecognizerDelegate, LJRoomListDelegate> {
    
    TopScrollViewMenuView *topMenu;
    CGFloat barHeight;
    LJRoomListView *roomList;
}

@end

@implementation LJRoomStateViewController
@synthesize topView, mySearchBar;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    [self.view endEditing:YES];
    [self.mySearchBar endEditing:YES];
    [self.mySearchBar resignFirstResponder];
    
    if (![[userDefaults objectForKey:ISLOGIN] length]) {
        
        LJLoginViewController *rootViewController = [LJLoginViewController shareLogin];
        //        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        //        nav.navigationBarHidden = YES;
        rootViewController.modalPresentationStyle = 0;
        [self presentViewController:rootViewController animated:YES completion:^{
            
        }];
        return;
    }
    [self loadData];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tabBarController.tabBar removeFromSuperview];
    [(ShoppingMallTabBarViewController *)self.tabBarController hideTabBar:NO];
    self.mainScrollView.contentSize = CGSizeMake(kappScreenWidth * self.titleArray.count, self.mainScrollView.frame.size.height);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    } else {
        return YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    barHeight = 0;
    if ([UIApplication sharedApplication].statusBarFrame.size.height >= 44.0f) {
        barHeight = 50;
    }
    
    [self createUI];
}

- (void) createUI {
    self.dataList = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    [self.view addSubview:topView];
    [topView.rightButton setImage:[UIImage imageNamed:@"saoyi_sao"] forState:UIControlStateNormal];
    topView.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    topView.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    topView.delegate = self;
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(30, kSafeHeight ? kSafeHeight + 10 : 20, kappScreenWidth - 70, 40)];
    [topView addSubview:mySearchBar];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"请输入房间号、名称或名称简码";
    mySearchBar.showsCancelButton = NO;
//    mySearchBar.barTintColor = LightBrownColor;
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
    
    [mySearchBar setImage:[UIImage imageNamed:@"icon_Search_bg white"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    mySearchBar.backgroundColor = [UIColor clearColor];
    
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.frame = mySearchBar.frame;
//    imageView.backgroundColor = [UIColor whiteColor];
//    [mySearchBar insertSubview:imageView atIndex:1];

    
    topMenu = [[TopScrollViewMenuView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kappScreenWidth, 50)];
    if (self.titleArray.count) {
        [topMenu setMenuListWithData:[NSMutableArray arrayWithArray:self.titleArray]];
    }
    topMenu.clipsToBounds = YES;
    topMenu.bottomView.hidden = YES;
    topMenu.delegate = self;
    [self.view addSubview:topMenu];
    
    roomList = [[LJRoomListView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth + 50, kappScreenWidth, kappScreenHeight - kTopScreenWidth - 50 - barHeight - kSafeHeight)];
    roomList.superVC = self;
    roomList.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    if ([[userDefaults objectForKey:ISLOGIN] length]) {
        [roomList.myCollectionView.mj_header beginRefreshing];
    }
    
    
    [self.view addSubview:roomList];
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth + 50, kappScreenWidth, kappScreenHeight - kTopScreenWidth - 50 -barHeight - kSafeHeight)];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.bounces = NO;
    [self.view addSubview:self.mainScrollView];
    
    
    self.detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.detailBtn];
    
    [self.detailBtn setTitle:@"汇总" forState:UIControlStateNormal];
    [self.detailBtn setBackgroundImage:[LJColorImage imageWithColor:[UIColor cyanColor]] forState:UIControlStateNormal];
    [self.detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.detailBtn setHidden:YES];
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20-barHeight);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    self.detailBtn.layer.cornerRadius = 30;
    self.detailBtn.layer.masksToBounds = YES;
    self.detailBtn.alpha = 0.6;
    [self.detailBtn addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void) detailBtnClick {
    
    LJCollectViewController *next = [[LJCollectViewController alloc] init];
    [self presentViewController:next animated:YES completion:^{
        
    }];
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.view bringSubviewToFront:roomList];
    [UIView animateWithDuration:0.3 animations:^{
        searchBar.showsCancelButton = YES;
        roomList.frame = CGRectMake(0, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth - 220 -barHeight);
        
    }];
    roomList.dataList = self.allDatas;
    roomList.myCollectionView.mj_header = nil;
    return YES;
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.view bringSubviewToFront:self.mainScrollView];
    [UIView animateWithDuration:0.3 animations:^{
        searchBar.showsCancelButton = NO;
        roomList.frame = CGRectMake(0, kTopScreenWidth + 50 , kappScreenWidth, kappScreenHeight - kTopScreenWidth - 50 - barHeight);
    }];
    roomList.dataList = [[self.dataList objectAtIndex:self.page] rooms];
    
    roomList.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
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
                roomList.dataList = arr;
            });
            
        });
    } else {
        roomList.dataList = self.allDatas;
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}


- (void)selectedMenu:(NSInteger)page {
    self.page = page;
    self.mainScrollView.contentOffset = CGPointMake(self.page * kappScreenWidth, 0);
    roomList.dataList = [[self.dataList objectAtIndex:page] rooms];
    
}

- (void) loadData {
    
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
                    roomListView.superVC = self;
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
            for (NSInteger i = 0; i < self.titleArray.count; i++) {
                LJRoomListView *roomListView = (LJRoomListView *)[self.mainScrollView viewWithTag:i + 4000];
                roomListView.dataList = [[self.dataList objectAtIndex:i] rooms];
                [roomListView.myCollectionView.mj_header endRefreshing];
            }
        }
        
        
        [roomList.myCollectionView.mj_header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [roomList.myCollectionView.mj_header endRefreshing];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.page = scrollView.contentOffset.x/kappScreenWidth;
    topMenu.selectedIndex = self.page;
}


- (void)rightButtonPressed {
    WQCodeScanner *scanner = [[WQCodeScanner alloc] init];
    [self presentViewController:scanner animated:YES completion:nil];
    scanner.resultBlock = ^(NSString *value) {
        HLBoxInfoViewController *box = [[HLBoxInfoViewController alloc] init];
        box.boxCd = value;
        box.boxCdLabel.text = [NSString stringWithFormat:@"扫描到的条形码为：%@",value];
        [self.navigationController pushViewController:box animated:YES];
    };
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
