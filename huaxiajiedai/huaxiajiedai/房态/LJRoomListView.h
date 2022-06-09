//
//  LJRoomListView.h
//  huaxiajiedai
//
//  Created by qm on 16/4/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJRoomListCollectionViewCell.h"
#import "LJRoomStateViewController.h"
#import "LJRoomModel.h"

@protocol LJRoomListDelegate <NSObject>

- (void) sendRoomModel:(LJRoomModel*)room;

@end


@interface LJRoomListView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *myCollectionView;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) LJRoomStateViewController *superVC;

@property (nonnull, assign) id<LJRoomListDelegate> delegate;

@end
