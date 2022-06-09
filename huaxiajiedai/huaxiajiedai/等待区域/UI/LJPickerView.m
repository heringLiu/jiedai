//
//  LJPickerView.m
//  huaxiajiedai
//
//  Created by qm on 16/4/15.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJPickerView.h"

@implementation LJPickerView
@synthesize myPickView, doneButton;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        
        doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:doneButton];
        [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-20);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        doneButton.layer.borderColor = gray146.CGColor;
        doneButton.layer.borderWidth = 1;
        doneButton.layer.cornerRadius = 8;
        [doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setTitleColor:gray104 forState:UIControlStateNormal];
        
        myPickView = [[UIPickerView alloc] init];
        [self addSubview:myPickView];
        [myPickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.bottom.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(216);
        }];
        myPickView.delegate = self;
        myPickView.dataSource = self;
        myPickView.backgroundColor = WhiteColor;
        
        myPickView.showsSelectionIndicator = YES;
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        lineView.backgroundColor =  gray238;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(myPickView.mas_top);
            make.height.mas_equalTo(1);
        }];
    }
    
    return self;
}

- (void) doneButtonClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectedDone:)]) {
        [self.delegate selectedDone:[myPickView selectedRowInComponent:0]];
    }
    
    if ([self.delegate respondsToSelector:@selector(pickViewDone)]) {
        [self.delegate pickViewDone];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.datas.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel *myView = nil;
    
    if (component == 0) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [self.datas objectAtIndex:row];
        
        myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
        
    }else {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 180, 30)];
        
        myView.text = @"2";
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.font = [UIFont systemFontOfSize:14];
        
        myView.backgroundColor = [UIColor clearColor];
        
    }
    
    return myView;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = row;
    if ([self.delegate respondsToSelector:@selector(selectedDone:)]) {
        [self.delegate selectedDone:row];
    }
}

- (void)setDatas:(NSMutableArray *)datas {
    _datas = datas;
    [myPickView reloadAllComponents];
}

@end
