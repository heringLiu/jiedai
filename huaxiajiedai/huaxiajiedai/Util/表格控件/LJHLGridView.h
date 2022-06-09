//
//  LJHLGridView.h
//  huaxiajiedai
//
//  Created by qm on 16/4/18.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJCollectionHeaderView.h"
#import "LJPickerView.h"
#import "LJReceptionDetailModel.h"
#import "ljsofalistviewcontroller.h"
#import "LJSelectedProjectViewController.h"
#import "LJSelectRoomViewController.h"
#import "LJSelectTechnicianViewController.h"
#import "LJProjectTitleModel.h"
#import "LJConsumptionViewController.h"

@protocol GridViewDelegate <NSObject>

- (void) showPickViewWithData:(NSMutableArray *) datas;

- (void) loadData;


@end

@interface LJHLGridView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, HeaderViewDelegate, UIActionSheetDelegate, SelectSofa, SelectTechnicianDelegate, UITextFieldDelegate, UIAlertViewDelegate, PickViewDelegate>

@property(nonatomic, strong) UICollectionView *myCollectionView;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSString *allSelected;

@property (nonatomic, strong) LJCollectionHeaderView *headerView; 
@property (nonatomic, strong) id<GridViewDelegate> delegate;

@property (nonatomic, strong) LJReceptionDetailModel *selectedEntity;

@property (nonatomic, strong) UIViewController *superVC;

@property (nonatomic, assign) BOOL isConsumption;

@property (nonatomic, strong) NSIndexPath *myIndexPath;

@property (nonatomic, strong) NSMutableArray *empListData;

- (void)selectedDone:(NSInteger)index;

//- (instancetype)initWithFrame:(CGRect)frame isConsumpton:( BOOL) isConsumption ;

@end
