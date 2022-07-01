//
//  LJRoomListView.m
//  huaxiajiedai
//
//  Created by qm on 16/4/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJRoomListView.h"
#import "LJWaitingAreaViewController.h"
#import "ShoppingMallTabBarViewController.h"
@implementation LJRoomListView
@synthesize  myCollectionView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        NSInteger count = 2;
//        if (kappScreenWidth == 320) {
//            count = 3;
//        }
        flowLayout.itemSize = CGSizeMake((kappScreenWidth - 20)/count, (kappScreenWidth - 20)/count * (160/215.0f));
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        // 设置最小行间距
        flowLayout.minimumLineSpacing = 0;
        // 设置垂直间距
        flowLayout.minimumInteritemSpacing = 0;
        
        
        myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];
        
        [myCollectionView registerClass:[LJRoomListCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        myCollectionView.delegate = self;
        myCollectionView.backgroundColor = [UIColor whiteColor];
        myCollectionView.dataSource = self;
        [self addSubview:myCollectionView];
        [myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.top.equalTo(self);
        }];
        
    }
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJRoomListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setCellWitdData:[self.dataList objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
    LJWaitingAreaViewController *next = [[LJWaitingAreaViewController alloc] init];
    
    next.roomName = [[self.dataList objectAtIndex:indexPath.row] roomName];
    next.roomCd = [[self.dataList objectAtIndex:indexPath.row] roomCd];
    next.isConsumption = YES;
    next.roomModel = [self.dataList objectAtIndex:indexPath.row];
    
    [self.superVC.tabBarController.tabBar removeFromSuperview];
    [(ShoppingMallTabBarViewController *)self.superVC.tabBarController hideTabBar:YES];
    if (self.superVC) {
        [self.superVC.view endEditing:YES];
        [self.superVC.navigationController pushViewController:next animated:YES];
    } else {
        
        LJRoomModel *room = [self.dataList objectAtIndex:indexPath.row];
        if ([room.manNum integerValue] + [room.womanNum integerValue] == [room.sofaQty integerValue]) {
            return;
        } else {
//            LJRoomListCollectionViewCell *cell = (LJRoomListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//            cell.backView.backgroundColor = NavBackColor;
            for (LJRoomModel *entity in self.dataList) {
                if ([entity.roomCd isEqualToString:room.roomCd]) {
                    entity.isChoosed = YES;
                } else {
                    entity.isChoosed = NO;
                }
            }
            [myCollectionView reloadData];
            if ([self.delegate respondsToSelector:@selector(sendRoomModel:)]) {
                [self.delegate sendRoomModel:room];
            }
        }
    }
    
    
}


- (void)setDataList:(NSMutableArray *)dataList {
    _dataList = dataList;
    [myCollectionView reloadData];
}






@end
