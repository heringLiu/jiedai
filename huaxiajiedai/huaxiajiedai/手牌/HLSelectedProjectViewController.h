//
//  LJSelectedProjectViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/4/21.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopScrollViewMenuView.h"
#import "LJProjectTitleModel.h"
#import "LJConsumptionViewController.h"
#import "LJReceptionListViewController.h"
#import "LJReceptionDetailModel.h"

@protocol HLSelectProjectDelegate <NSObject>

- (void) sendProject:(LJProjectModel *) dic;

- (void) sendBoxcd;

@end

@interface HLSelectedProjectViewController : UIViewController <topScrollViewMenuDelegate, CustomTopNavigationViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, UISearchBarDelegate>

@property (nonatomic, assign) id<HLSelectProjectDelegate> delegate;

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, strong) UIColor *navColor;

@property (nonatomic, strong) UICollectionView *myCollectionView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, assign) BOOL isConsumption;

@property (nonatomic, strong) LJProjectModel *selectedProject;

@property (nonatomic, strong) NSString *artificerCd;

@property (nonatomic, strong) NSString *startTime;

@property (nonatomic, strong) LJReceptionDetailModel *detailEntity;


@property (nonatomic, strong) UISearchBar *mySearchBar;

@property (nonatomic, strong) NSString *keyWords;

@property (nonatomic, strong) NSMutableArray *searchData;

@property (nonatomic, strong) NSMutableArray *allDatas;

@end
