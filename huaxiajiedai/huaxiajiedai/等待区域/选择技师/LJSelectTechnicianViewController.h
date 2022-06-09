//
//  LJSelectTechnicianViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/4/21.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJTECTopMenu.h"
#import "LJTechnicianButton.h"
#import "LJArtModel.h"
#import "LJReceptionDetailModel.h"
#import "LJPickerView.h"

@class LJSelectTechnicianViewController;

@protocol SelectTechnicianDelegate <NSObject>

- (void) sendTechnician:(LJSelectTechnicianViewController *) entity;

@end


@interface LJSelectTechnicianViewController : UIViewController  <TecTopScrollViewMenuDelegate, CustomTopNavigationViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, TButtonDelegate, UISearchBarDelegate, PickViewDelegate, UIActionSheetDelegate>

@property (nonatomic, assign) id<SelectTechnicianDelegate> delegate;

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (nonatomic, strong) UIControl *myControl;

@property (nonatomic, strong) LJPickerView *pickView;

@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, strong) UIColor *navColor;

@property (nonatomic, strong) UICollectionView *myCollectionView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL isConsumption;

@property (nonatomic, assign) NSInteger technicianCount;

@property (nonatomic, strong) NSString *projectCd;

// 技师1编号
@property (nonatomic, strong) NSString *artificer1Cd;

// 技师1选择方式   0：轮钟  1：点钟
@property (nonatomic, strong) NSString *artificer1SelectType;

// 技师2编号
@property (nonatomic, strong) NSString *artificer2Cd;

// 技师2选择方式   0：轮钟  1：点钟
@property (nonatomic, strong) NSString *artificer2SelectType;

// 技师3编号
@property (nonatomic, strong) NSString *artificer3Cd;

// 技师3选择方式   0：轮钟  1：点钟
@property (nonatomic, strong) NSString *artificer3SelectType;


// 技师4编号
@property (nonatomic, strong) NSString *artificer4Cd;

// 技师4选择方式   0：轮钟  1：点钟
@property (nonatomic, strong) NSString *artificer4SelectType;


@property(nonatomic, strong) LJTechnicianButton *selectedButton;

@property (nonatomic, strong) LJArtModel *selectedEntity;

// 选择了技师的模型 只能显示该技师的信息
@property (nonatomic, strong) LJReceptionDetailModel *artRecModel;

@property (nonatomic, strong) LJReceptionDetailModel *detailEntity;

@property (nonatomic, strong) LJReceptionDetailModel *doubleEntity;

@property (nonatomic, strong) NSString *startTime;

@property (nonatomic, strong) UISearchBar *mySearchBar;

@property (nonatomic, strong) NSString *keyWords;

@property (nonatomic, strong) NSString *selectSex;

@property (nonatomic, strong) NSMutableArray *searchData;

@property (nonatomic, assign) BOOL canLunFlag;

@property (nonatomic, assign) BOOL canSelectNotFree;

@property (nonatomic, strong) NSString *changeStr;

@end
