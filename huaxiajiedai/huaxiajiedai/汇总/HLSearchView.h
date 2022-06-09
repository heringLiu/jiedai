//
//  HLSearchView.h
//  huaxiajishi
//
//  Created by gjhgj on 2017/9/25.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HLSearchViewDelegate <NSObject>

- (void) HLsearchProject;

- (void) beginSearchWithStart:(NSString *) startStr end:(NSString *)endStr;

@end

@interface HLSearchView : UIView

@property (nonatomic, assign) id<HLSearchViewDelegate> delegate;

@property (nonatomic, strong) UIDatePicker *startDatePicker;

@property (nonatomic, strong) UIDatePicker *endDatePicker;

@property (nonatomic, strong) UIButton *startDateText;

@property (nonatomic, strong) UIButton *endDateText;

@property (nonatomic, strong) UIControl *backCon;

@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) NSString *startStr;
@property (nonatomic, strong) NSString *endStr;

@property (nonatomic, strong) NSString *businessDate;


- (void) hideCon;
@end
