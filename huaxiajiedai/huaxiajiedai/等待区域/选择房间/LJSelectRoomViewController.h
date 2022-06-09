//
//  LJSelectRoomViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/4/21.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopScrollViewMenuView.h"
#import "LJRoomModel.h"
#import "LJFloorModel.h"
#import "LJConsumptionViewController.h"
#import "LJReceptionListViewController.h"


@protocol SelectRoomDelegate <NSObject>

- (void) sendRoom:(LJRoomModel *) room;

@end


@interface LJSelectRoomViewController : UIViewController <topScrollViewMenuDelegate, CustomTopNavigationViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) id<SelectRoomDelegate> delegate;

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, strong) UIColor *navColor;

@property (nonatomic, strong) UICollectionView *myCollectionView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) BOOL isConsumption;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *allDatas;

@property (strong,nonatomic) NSMutableArray  *searchList;

@property (nonatomic, strong) UISearchBar *mySearchBar;

@property (strong,nonatomic) NSMutableArray  *dataList;

@property (nonatomic, strong) LJRoomModel *selectedRoom;

@property (nonatomic, strong) NSString *keyWords;

@property (nonatomic, strong) NSMutableArray *searchData;

@property (nonnull, strong) UIScrollView *mainScrollView;

@end
