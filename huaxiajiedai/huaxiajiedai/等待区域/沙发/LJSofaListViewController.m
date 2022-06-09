//
//  LJSofaListViewController.m
//  huaxia
//
//  Created by qm on 16/4/11.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJSofaListViewController.h"
#import "LJSofaCollectionViewCell.h"

@interface LJSofaListViewController (){
    UIView *topView;
    UILabel *myTitileLabel;
    UIButton *backBtn;
    NSMutableArray *datas;
    
    UIButton *submitBtn;
}

@end

@implementation LJSofaListViewController
@synthesize myCollectionView;

- (void) loadData {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.roomCd.length) {
        [dic setValue:self.roomCd forKey:@"roomCd"];
    }
    NSLog(@"dic = %@", dic);
    
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] GET:XIAOFEIGETSOFA parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
        
        DISMISS
        if (ISSUCCESS) {
            [datas removeAllObjects];
            for (NSDictionary *dic in CONTENTOBJ) {
                SofaModel *entity  = [[SofaModel alloc] init];
                [entity setValuesForKeysWithDictionary:dic];
                [datas addObject:entity];
            }
            [myCollectionView reloadData];
            
        } else {
            BADREQUEST
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor colorWithRed:239/255.0f green:210/255.0f blue:171/255.0f alpha:1];
    self.view.backgroundColor = WhiteColor;
    datas = [NSMutableArray array];
    
    [self loadData];
    
    myTitileLabel = [UILabel new];
    [topView addSubview:myTitileLabel];
    [myTitileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view.mas_left).offset(80);
        make.right.equalTo(self.view.mas_right).offset(-80);
        make.height.mas_equalTo(44);
    }];
    myTitileLabel.text = @"选择沙发";
    myTitileLabel.textColor = WhiteColor;
    myTitileLabel.textAlignment = NSTextAlignmentCenter;
    myTitileLabel.font = FONT18;
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    [backBtn setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake((kappScreenWidth - 30)/4, (kappScreenWidth - 30)/4 * (96/140.0f));
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
    // 设置最小行间距
    flowLayout.minimumLineSpacing = 0;
    // 设置垂直间距
    flowLayout.minimumInteritemSpacing = 0;
    
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, kTopScreenWidth + 10, kappScreenWidth - 10, kappScreenHeight - kTopScreenWidth - 10 - 110) collectionViewLayout:flowLayout];
    myCollectionView.backgroundColor = WhiteColor;
    myCollectionView.showsHorizontalScrollIndicator = NO;
    myCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myCollectionView];
    
    
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    [myCollectionView registerClass:[LJSofaCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    //    确定按钮
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(60);
        make.left.equalTo(self.view).mas_equalTo(leftMargin);
        make.right.equalTo(self.view).mas_equalTo(-leftMargin);
    }];
    submitBtn.backgroundColor = LightBrownColor;
    submitBtn.layer.cornerRadius = 30;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submintBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) submintBtn {
    if ([self.delegate respondsToSelector:@selector(sendSofa:)]) {
        [self.delegate sendSofa:self.selectedEntity];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return datas.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJSofaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    for (UIView *sub in cell.subviews) {
        [sub removeFromSuperview];
    }
    
    SofaModel *entity = [datas objectAtIndex:indexPath.row];
    
    if ([entity.sofaNo isEqualToString:self.selectedEntity.sofaNo]) {
        entity.isChoosed = YES;
    }
    
    [cell setCellWithData:entity];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.myIndexPath = indexPath;
    SofaModel *entity = [datas objectAtIndex:indexPath.row];
    if ([entity.availableFlg isEqualToString:@"disabled"]) {
//        [[iToast makeText:@"该沙发已被占用"] show];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该沙发已被占用" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [av show];
        return;
    }
    
    for (int i = 0; i < datas.count; i++) {
        SofaModel *model = [datas objectAtIndex:i];
        if (indexPath.row == i) {
            
            model.isChoosed = YES;
        } else {
            model.isChoosed = NO;
        }
    }
    self.selectedEntity = entity;
    
    [collectionView reloadData];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        for (int i = 0; i < datas.count; i++) {
            SofaModel *model = [datas objectAtIndex:i];
            if (self.myIndexPath.row == i) {
                
                model.isChoosed = YES;
            } else {
                model.isChoosed = NO;
            }
        }
        
        self.selectedEntity = [datas objectAtIndex:self.myIndexPath.row];
        [myCollectionView reloadData];
    }
}

- (void) backPressed {
    [self.navigationController popViewControllerAnimated:YES];
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
