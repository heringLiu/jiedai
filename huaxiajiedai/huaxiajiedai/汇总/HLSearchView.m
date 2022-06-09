//
//  HLSearchView.m
//  huaxiajishi
//
//  Created by gjhgj on 2017/9/25.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "HLSearchView.h"

@implementation HLSearchView{
    NSDate *startDate;
    NSDate *endDate;
    UIView *_lineView ;
    UIView *_lineView2 ;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = gray238;
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        interval = 0;
        
        NSDate *nowDate = [date dateByAddingTimeInterval: interval];
        endDate = nowDate;
        NSLog(@"nowdate   %@", nowDate);
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"YYYY-MM-dd hh:mm:ss";
        startDate = [[self zeroOfDate:nowDate] dateByAddingTimeInterval:interval];
        NSLog(@"%@", startDate);
        
        self.startDateText = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_startDateText];
        //        [_startDateText addTarget:self action:@selector(startDateClick) forControlEvents:UIControlEventAllTouchEvents];
        [_startDateText addTarget:self action:@selector(startDateClick) forControlEvents:UIControlEventTouchUpInside];
        [self.startDateText setTitle:@"选择开始营业日" forState:UIControlStateNormal];
        [self.startDateText setTitleColor:gray104 forState:UIControlStateNormal];
        //        self.startDateText.placeholder = @"选择开始营业日";
        self.startDateText.layer.cornerRadius = 6;
        self.startDateText.layer.borderColor = gray191.CGColor;
        //        self.startDateText.layer.borderWidth = 0.5;
        //        self.startDateText.textAlignment = NSTextAlignmentCenter;
        
        [self.startDateText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(30 * (kappScreenWidth / 320.0f));
        }];
        
        _lineView= [[UIView alloc] init];
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.left.equalTo(self.startDateText);
            make.right.equalTo(self.startDateText);
            make.top.equalTo(self.startDateText.mas_bottom).offset(5);
            make.height.mas_equalTo(1);
        }];
        _lineView.backgroundColor = WhiteColor;
        
        self.endDateText = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.endDateText];
        //        [self.endDateText addTarget:self action:@selector(endDateClick) forControlEvents:UIControlEventAllTouchEvents];
        [self.endDateText addTarget:self action:@selector(endDateClick) forControlEvents:UIControlEventTouchUpInside];
        [self.endDateText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.startDateText.mas_bottom).offset(20);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(30 * (kappScreenWidth / 320.0f));
        }];
        
        [self.endDateText setTitle:@"选择结束营业日" forState:UIControlStateNormal];
        [self.endDateText setTitleColor:gray104 forState:UIControlStateNormal];
        
        //        self.endDateText.placeholder = @"选择结束营业日";
        //        self.endDateText.textAlignment = NSTextAlignmentCenter;
        self.endDateText.layer.cornerRadius = 6;
        self.endDateText.layer.borderColor = gray191.CGColor;
        //        self.endDateText.layer.borderWidth = 0.5;
        _lineView2= [[UIView alloc] init];
        [self addSubview:_lineView2];
        [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.left.equalTo(self.endDateText);
            make.right.equalTo(self.endDateText);
            make.top.equalTo(self.endDateText.mas_bottom).offset(5);
            make.height.mas_equalTo(1);
        }];
        _lineView2.backgroundColor = WhiteColor;
        
        
        self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.searchBtn];
        self.searchBtn.layer.cornerRadius = 6;
        [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30 * (kappScreenWidth / 320.0f));
            make.top.equalTo(self.endDateText.mas_bottom).offset(20);
        }];
        [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [self.searchBtn setTitleColor:gray104 forState:UIControlStateNormal];
        //        self.searchBtn.layer.borderWidth = 0.5;
        //        self.searchBtn.layer.borderColor = gray191.CGColor;
        self.searchBtn.backgroundColor = LightBrownColor;
        [self.searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self loadBusinessDate];
        
    }
    
    
    return self;
}
- (NSDate *)zeroOfDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:ts];
}
- (void) searchBtnClick{
    
    if (!self.startStr.length) {
        SHOWTEXTINWINDOW(@"请选择开始日期", 1.5);
        return;
    }
    if (!self.endStr.length) {
        SHOWTEXTINWINDOW(@"请选择结束日期", 1.5);
        return;
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"YYYY-MM-dd";
    NSDate *date = [df dateFromString:self.businessDate];
    
    if ([df dateFromString:self.startStr] > date) {
        SHOWTEXTINWINDOW(@"开始日期不能大于营业日", 1.5);
        return;
    }
    
    if ([df dateFromString:self.startStr] > [df dateFromString:self.endStr]) {
        SHOWTEXTINWINDOW(@"开始日期不能大于结束日期", 1.5);
        return;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(beginSearchWithStart:end:)]) {
        [self.delegate beginSearchWithStart:self.startStr end:self.endStr];
    }
}

- (void) startDateClick {
    if (self.endDatePicker) {
        [self.endDatePicker removeFromSuperview];
        self.endDatePicker = nil;
    }
    
    if (!self.backCon) {
        self.backCon = [[UIControl alloc] initWithFrame:CGRectMake(0, 230, kappScreenWidth, kappScreenHeight -230)];
        [self.backCon addTarget:self action:@selector(hideCon) forControlEvents:UIControlEventAllTouchEvents];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.backCon];
    } else {
        if (self.backCon.frame.origin.y > 0) {
            self.backCon.frame = CGRectMake(0, 230, kappScreenWidth, kappScreenHeight - 230);
        }
    }
    if (!self.startDatePicker) {
        self.startDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kappScreenHeight - 216 - 230, kappScreenWidth, 216)];
        self.startDatePicker.datePickerMode = UIDatePickerModeDate;
        //        self.backCon.backgroundColor = WhiteColor;
        self.alpha = 1;
        [self.startDatePicker setDate:startDate];
        //        self.startDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.startDatePicker.backgroundColor = WhiteColor;
        [self.backCon addSubview:self.startDatePicker];
        [self.startDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    }
    
    
    
    [self.backCon bringSubviewToFront:self.startDatePicker];
    
    [self sendSubviewToBack:self.backCon];
    self.startDatePicker.maximumDate = endDate;
    
}


- (void) endDateClick {
    if (self.startDatePicker) {
        [self.startDatePicker removeFromSuperview];
        self.startDatePicker = nil;
    }
    if (!self.backCon) {
        self.backCon = [[UIControl alloc] initWithFrame:CGRectMake(0, 230, kappScreenWidth, kappScreenHeight - 230)];
        [self.backCon addTarget:self action:@selector(hideCon) forControlEvents:UIControlEventAllTouchEvents];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.backCon];
    } else {
        if (self.backCon.frame.origin.y > 0) {
            self.backCon.frame = CGRectMake(0, 230, kappScreenWidth, kappScreenHeight -230);
        }
    }
    if (!self.endDatePicker) {
        self.endDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kappScreenHeight - 216 -230, kappScreenWidth, 216)];
        self.endDatePicker.datePickerMode = UIDatePickerModeDate;
        self.endDatePicker.backgroundColor = WhiteColor;
        [self.backCon addSubview:self.endDatePicker];
        [self.endDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"YYYY-MM-dd";
        if (self.businessDate.length) {
            self.endDatePicker.maximumDate = [df dateFromString:self.businessDate];
        }
    }
    
    [self.backCon bringSubviewToFront:self.endDatePicker];
    [self sendSubviewToBack:self.backCon];
    //    self.endDatePicker.maximumDate = [NSDate date];
}

- (void) hideCon {
    [UIView animateWithDuration:0.3 animations:^{
        self.backCon.frame = CGRectMake(0, kappScreenHeight, kappScreenWidth, kappScreenHeight - 230);
    }];
    
}

-(void)dateChanged:(UIDatePicker *)sender{
    NSDate *date = sender.date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"YYYY-MM-dd";
    if (sender == self.startDatePicker) {
        [self.startDateText setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        startDate = date;
        self.startStr = [df stringFromDate:date];
    } else if (sender == self.endDatePicker) {
        [self.endDateText setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        endDate = date;
        
        NSLog(@"%@", self.businessDate);
        if (self.businessDate.length > 0 && endDate > [df dateFromString:self.businessDate]) {
            [self.endDatePicker setDate:[df dateFromString:self.businessDate]];
            [self.endDateText setTitle:self.businessDate forState:UIControlStateNormal];
        }
        
        //        if (endDate < startDate) {
        //            self.startStr = [df stringFromDate:date];
        //            [self.startDateText setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        //        }
        self.endStr = [df stringFromDate:date];
    }
}

- (void) loadBusinessDate {
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:BUSINESSDATE parameters:@{} success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", jsonString);
        
        if (ISSUCCESS) {
            NSString *dateStr = [CONTENTOBJ objectForKey:@"BusinessDate"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateFormat = @"YYYY-MM-dd";
            NSDate *date = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:[df dateFromString:dateStr]];
            self.businessDate = [df stringFromDate:date];
            
            self.endDatePicker.maximumDate = [df dateFromString:self.businessDate];
            self.endStr = self.businessDate;
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DISMISS
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"YYYY-MM-dd";
        NSDate *date = [NSDate date];
        self.businessDate = [df stringFromDate:date];
        
        self.endDatePicker.maximumDate = [df dateFromString:self.businessDate];
        self.endStr = self.businessDate;
        
    }];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
