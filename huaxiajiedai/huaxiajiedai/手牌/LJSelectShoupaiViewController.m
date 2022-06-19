//
//  LJTechnicianViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/4/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJSelectShoupaiViewController.h"

@interface LJSelectShoupaiViewController () {
    LJTECTopMenu *topMenu;
}

@end

@implementation LJSelectShoupaiViewController
@synthesize topView, myCollectionView, dataList, datas, mySearchBar;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar removeFromSuperview];
    [(ShoppingMallTabBarViewController *)self.tabBarController hideTabBar:NO];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tabBarController.tabBar removeFromSuperview];
    [(ShoppingMallTabBarViewController *)self.tabBarController hideTabBar:NO];
}


- (void) loadData {
    
    NSLog(@"-- %@", STORCDSTRING);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *str = @"";
    [dic setObject:str forKey:@"saleManCd"];
    if (self.handCd.length > 0) {
        [dic setObject:self.handCd forKey:@"handCd"];
    }
    
    [[NetWorkingModel sharedInstance] GET:HANDINDEX parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        [dataList removeAllObjects];
        if (ISSUCCESS) {
            dataList = [NSMutableArray arrayWithArray:CONTENTOBJ];
            [self selectedMenu:0];
        }
        [myCollectionView.mj_header endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [myCollectionView.mj_header endRefreshing];
        }];
}


- (void)selectedMenu:(NSInteger)page {
    self.page = page;
    [datas removeAllObjects];
    switch (page) {
            //            @[@"全部", @"上钟", @"空闲",@"预定"];
        case 0:
            //            全部
            datas = [NSMutableArray arrayWithArray:dataList];
            [myCollectionView reloadData];
            break;
        case 1:
            //            上钟
            
            for (NSDictionary *dic in dataList) {
                if ([[dic objectForKey:@"curState"] isEqualToString:@"onTime"]) {
                    [datas addObject:dic];
                }
            }
            [myCollectionView reloadData];
            break;
        case 2:
            //            空心啊
            for (NSDictionary *dic in dataList) {
                if ([[dic objectForKey:@"curState"] isEqualToString:@"free"]) {
                    [datas addObject:dic];
                }
            }
            [myCollectionView reloadData];
            break;
        case 3:
            //            预定
            for (NSDictionary *dic in dataList) {
                if ([[dic objectForKey:@"curState"] isEqualToString:@"reserve"]) {
                    [datas addObject:dic];
                }
            }
            [myCollectionView reloadData];
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    datas = [NSMutableArray array];
    self.dataList = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    [self.view addSubview:topView];

    topView.delegate = self;
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(30, kSafeHeight ? kSafeHeight + 10 : 20, kappScreenWidth - 100, 40)];
    [topView addSubview:mySearchBar];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"请输入手牌";
    mySearchBar.showsCancelButton = YES;
    mySearchBar.returnKeyType = YES;
    mySearchBar.barTintColor = LightBrownColor;
    [mySearchBar setImage:[UIImage imageNamed:@"icon_Search_bg white"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    mySearchBar.backgroundColor = [UIColor clearColor];

    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flowLayout.itemSize = CGSizeMake((kappScreenWidth - 20)/4, (kappScreenWidth - 20)/4 * (116/140.0f));
    // 设置最小行间距
    flowLayout.minimumLineSpacing = 0;
    // 设置垂直间距
    flowLayout.minimumInteritemSpacing = 0;
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth - 50) collectionViewLayout:flowLayout] ;
    myCollectionView.backgroundColor = WhiteColor;
    [self.view addSubview:myCollectionView];
    
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [myCollectionView.mj_header beginRefreshing];
//    myCollectionView.tag = 2000;
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    
//    [myCollectionView addGestureRecognizer:singleTap];
}
- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    if (sender.view.tag == 2000) {
        [mySearchBar endEditing:YES];
        [self loadData];

    }
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return datas.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIButton *btn = (UIButton *) [cell viewWithTag:1000];
    if (!btn) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:gray104 forState:UIControlStateNormal];
        [btn setTitleColor:WhiteColor forState:UIControlStateSelected];
        
        [btn setBackgroundImage:[LJColorImage imageWithColor:gray238] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.userInteractionEnabled = NO;
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
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        CGFloat width = (kappScreenWidth - 20)/4/4;
        UILabel *label = [UILabel new];
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, width));
            make.centerX.equalTo(btn.mas_right).offset(-2);
            make.centerY.equalTo(btn.mas_top).offset(5);
        }];
        label.font = FONT13;
        label.textColor = WhiteColor;
        label.backgroundColor = [UIColor greenColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"占";
        label.layer.cornerRadius = width/2;
        label.layer.masksToBounds = YES;
        label.tag = 1001;
        
        UIView *midelView = [[UIView alloc] init];
        [btn addSubview:midelView];
        [midelView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(btn.mas_centerX).offset(0);
                    make.centerY.equalTo(btn.mas_centerY).offset(0);
                    make.height.mas_equalTo(1);
                    make.width.mas_equalTo(btn.mas_width);
        }];
        midelView.backgroundColor = gray146;
        
        
        UILabel *handlCDLabel = [[UILabel alloc] init];
        [btn addSubview:handlCDLabel];
        handlCDLabel.tag = 1002;
        [handlCDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(btn.mas_top);
                    make.left.equalTo(btn.mas_left);
                    make.right.equalTo(btn.mas_right);
                    make.height.equalTo(btn.mas_height).multipliedBy(0.5);
        }];
        [handlCDLabel setFont:FONT18];
        [handlCDLabel setTextColor: [UIColor blackColor]];
        handlCDLabel.textAlignment = NSTextAlignmentCenter;

        UILabel *maleLabel = [[UILabel alloc] init];
        [btn addSubview:maleLabel];
        maleLabel.tag = 1003;
        [maleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(btn.mas_bottom);
                    make.left.equalTo(btn.mas_left);
                    make.width.equalTo(btn.mas_width).multipliedBy(0.5);
                    make.height.equalTo(btn.mas_height).multipliedBy(0.5);
        }];
        [maleLabel setFont:FONT14];
        
        UILabel *availableLabel = [[UILabel alloc] init];
        [btn addSubview:availableLabel];
        availableLabel.tag = 1004;
        [availableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(btn.mas_bottom);
                    make.right.equalTo(btn.mas_right);
                    make.width.equalTo(btn.mas_width).multipliedBy(0.5);
                    make.height.equalTo(btn.mas_height).multipliedBy(0.5);
        }];
        [availableLabel setFont:FONT14];
        availableLabel.textAlignment = NSTextAlignmentRight;
        
    }

    NSDictionary *dic = [datas objectAtIndex:indexPath.row];
//    [btn setTitle:[NSString stringWithFormat:@"%@(%@)\n%@", [dic objectForKey:@"artificerCd"], [[dic objectForKey:@"sex"] isEqualToString:@"woman"] ? @"女" : @"男", [dic objectForKey:@"artificerName"]] forState:UIControlStateNormal];
    UILabel *label = (UILabel *)[cell viewWithTag:1001];

    label.hidden = YES;
//    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    
    UILabel *handlCDLabel = (UILabel *)[cell viewWithTag:1002];
    [handlCDLabel setText: [dic objectForKey:@"handCd"]];
    
    UILabel *maleLabel = (UILabel *)[cell viewWithTag:1003];
    if ([[dic objectForKey:@"sex"] isEqual:@"1"]) {
        [maleLabel setText: @"  男"];
        [maleLabel setTextColor: [UIColor blueColor]];
    } else if ([[dic objectForKey:@"sex"] isEqual:@"2"]) {
        [maleLabel setText: @"  女"];
        [maleLabel setTextColor: [UIColor redColor]];
    }
    
    UILabel *availableLabel = (UILabel *)[cell viewWithTag:1004];
    if ([[dic objectForKey:@"availableFlg"] boolValue]) {
        [availableLabel setText: @"启用 "];
    } else {
        [availableLabel setFont:FONT12];
        [availableLabel setText: @"未启用 "];
    }
    
    
    return cell;
}

- (void)rightButtonPressed {
    [mySearchBar endEditing: YES];
    topView.rightButton.hidden = YES;
}

- (void) buttonClick:(UIButton *) sender {
    [sender setSelected:!sender.isSelected];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [topView.rightButton setTitle:@"取消" forState:UIControlStateNormal];
    topView.rightButton.hidden = NO;
    return YES;
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
   
    
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
   
    self.handCd = searchText;
    [self loadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    NSDictionary *dic = [datas objectAtIndex:indexPath.row];
    if (self.delegate) {
        [self.delegate sendShouPai:[dic objectForKey:@"handCd"] andSex:[dic objectForKey:@"sex"]];
    }
    [self.navigationController popViewControllerAnimated:YES];
   
//    [[NetWorkingModel sharedInstance] GET:CLICKJISHI parameters:@{@"artificerCd":[dic objectForKey:@"artificerCd"]} success:^(AFHTTPRequestOperation *operation, id obj) {
//        DISMISS
//        if (ISSUCCESS) {
//            if ([[CONTENTOBJ objectForKey:@"type"] isEqualToString:@"appointment"]) {
//                NSString *str = [NSString stringWithFormat:@"预定上钟时间为 %@", [CONTENTOBJ objectForKey:@"startTime"]];
//                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [av show];
//            } else {
//                if ([[CONTENTOBJ objectForKey:@"time"] longLongValue] < 0) {
//                     NSString *str = [NSString stringWithFormat:@"该技师服务所做的项目已超过预订落钟时间%lld分", llabs([[CONTENTOBJ objectForKey:@"time"] longLongValue])];
//                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [av show];
//                } else {
//                    NSString *str = [NSString stringWithFormat:@"距离下钟还有 %@ 分钟", [CONTENTOBJ objectForKey:@"time"]];
//                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [av show];
//                }
//
//            }
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//    }];
    
}
-(void)toucheEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [mySearchBar endEditing:YES];
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
