//
//  LJPickerView.h
//  huaxiajiedai
//
//  Created by qm on 16/4/15.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickViewDelegate <NSObject>

- (void)pickViewDone;

- (void) selectedDone:(NSInteger)index;

@end

@interface LJPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *myPickView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) id<PickViewDelegate> delegate;

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, assign) NSInteger selectedIndex;

@end
