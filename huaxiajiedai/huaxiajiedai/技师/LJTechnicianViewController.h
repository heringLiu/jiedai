//
//  LJTechnicianViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/4/13.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJTECTopMenu.h"

@interface LJTechnicianViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, TecTopScrollViewMenuDelegate>

@property (nonatomic, strong) UICollectionView *myCollectionView;

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (strong,nonatomic) NSMutableArray  *dataList;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *datas;

@end
