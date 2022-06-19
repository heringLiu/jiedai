//
//  HLShouPaiViewController.h
//  huaxiajiedai
//
//  Created by 刘慧林 on 2022/6/10.
//  Copyright © 2022 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJTECTopMenu.h"
#import "ShoppingMallTabBarViewController.h"

@class LJSelectShoupaiViewController;

@protocol SelectShoupaiDelegate <NSObject>

- (void) sendShouPai:(NSString *_Nullable) handCd andSex:(NSString *) sex;

@end
NS_ASSUME_NONNULL_BEGIN


@interface LJSelectShoupaiViewController  : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, CustomTopNavigationViewDelegate, UISearchBarDelegate, UITextFieldDelegate>
@property (nonatomic, assign) id<SelectShoupaiDelegate>delegate;
@property (nonatomic, strong) UICollectionView *myCollectionView;

@property (nonatomic, strong) CustomTopNavigationView *topView;

@property (nonatomic, strong) UISearchBar *mySearchBar;

@property (strong,nonatomic) NSMutableArray  *dataList;
@property (nonatomic, assign) NSInteger page;

//@property (nonatomic, strong) LJConsumptionHeaderModel *headerEntity;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) NSString *handCd;

@end

NS_ASSUME_NONNULL_END
