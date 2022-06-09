//
//  LJIPSettingViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/5/26.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJIPSettingViewController.h"

@interface LJIPSettingViewController () {
    UITextField *ipText;
}

@end

@implementation LJIPSettingViewController
@synthesize topView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WhiteColor;
    
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    topView.titleLabel.text = @"更换IP地址";
    topView.delegate = self;
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    [topView.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.view addSubview:topView];
    
    ipText = [[UITextField alloc] init];
    [self.view addSubview:ipText];
    ipText.placeholder = @"请输入IP地址";
    [ipText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(topView.mas_bottom).offset(30);
        make.height.mas_equalTo(50);
    }];
    ipText.borderStyle = UITextBorderStyleRoundedRect;
    if ([[userDefaults objectForKey:IPADD] length]) {
        ipText.text = [userDefaults objectForKey:IPADD];
    }
    [ipText becomeFirstResponder];
}

- (void)leftButtonPressed {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)rightButtonPressed {
    if (kappScreenHeight <= 480) {
        [ipText endEditing:YES];
    }
    NSArray *arr = [ipText.text componentsSeparatedByString:@"."];
    if (arr.count != 4) {
        SHOWTEXTINWINDOW(@"请输入正确的IP地址", 1);
        return;
    }
    
    for (NSString *str in arr) {
        if ([str integerValue] > 255 || [str integerValue] < 0) {
            SHOWTEXTINWINDOW(@"请输入正确的IP地址", 1);
            return;
        }
    }
    [userDefaults setObject:ipText.text forKey:IPADD];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    NSString *regex = @"^(d{1,2}|1dd|2[0-4]d|25[0-5]).(d{1,2}|1dd|2[0-4]d|25[0-5]).(d{1,2}|1dd|2[0-4]d|25[0-5]).(d{1,2}|1dd|2[0-4]d|25[0-5])$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if ([pred evaluateWithObject:ipText.text]) {
//        [userDefaults setObject:ipText.text forKey:IPADD];
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    } else {
//        SHOWTEXTINWINDOW(@"请输入正确的IP地址", 1);
//        return;
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
