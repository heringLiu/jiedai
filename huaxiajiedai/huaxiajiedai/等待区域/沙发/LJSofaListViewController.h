//
//  LJSofaListViewController.h
//  huaxia
//
//  Created by qm on 16/4/11.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SofaModel.h"

@protocol SelectSofa <NSObject>

- (void)sendSofa:(SofaModel *)entity;

@end

@interface LJSofaListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UICollectionView *myCollectionView;

@property (nonatomic, assign) id<SelectSofa> delegate;

@property (nonatomic, assign) BOOL isConsumption;

@property (nonatomic, strong) NSString *roomCd;

@property (nonatomic, strong) NSIndexPath *myIndexPath;

@property (nonatomic, strong) SofaModel *selectedEntity;

@end
