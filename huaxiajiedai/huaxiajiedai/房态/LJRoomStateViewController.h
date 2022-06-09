//
//  LJRoomStateViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/4/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopScrollViewMenuView.h"
#import "LJFloorModel.h"
#import "LJRoomModel.h"
#import "WQCodeScanner.h"
#import "HLBoxInfoViewController.h"

@interface LJRoomStateViewController : UIViewController <topScrollViewMenuDelegate, UIScrollViewDelegate, UISearchBarDelegate,CustomTopNavigationViewDelegate>

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (strong,nonatomic) NSMutableArray  *dataList;

@property (strong,nonatomic) NSMutableArray  *searchList;

@property (nonatomic, strong) UISearchBar *mySearchBar;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *allDatas;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIButton *detailBtn;

@property (nonatomic, assign) NSInteger page;

@end
