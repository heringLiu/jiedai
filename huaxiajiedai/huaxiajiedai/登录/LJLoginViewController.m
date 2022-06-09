//
//  LJLoginViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/4/12.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJLoginViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "ShoppingMallTabBarViewController.h"
#import "MMDrawerController.h"
#import "LJLeftViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#define CC_MD5_DIGEST_LENGTH 16


@interface LJLoginViewController () {
    UITextField *memberNOTextfield;
    UITextField *IPTextfield;

    UITextField *passwordTextfield;
    UIButton *loginBtn;
    UIButton *scanButton;
    CGFloat keyboardSizeHeight;
    UIView *backView;
}

@end

@implementation LJLoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

+ (instancetype)shareLogin {
    static LJLoginViewController *login = nil;
    if (login == nil) {
        login = [[LJLoginViewController alloc] init];
    }
    
    return login;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self registerForKeyboardNotifications];
    
    //    背景图
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    backImageView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:backImageView];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    [self.view addSubview:backView];
    //    渐变色
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    
    gradient.colors = [NSArray arrayWithObjects:(id)(id)gray238.CGColor,(id)WhiteColor.CGColor,nil];
    
    [self.view.layer insertSublayer:gradient below:0];
    
    // 扫一扫按钮
    
    scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:scanButton];
    [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(50);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
        make.right.equalTo(self.view).mas_equalTo(-leftMargin);
    }];
//    scanButton.backgroundColor = LightBrownColor;
    [scanButton setImage:[UIImage imageNamed:@"saoyi_sao_org"] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    scanButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //    登录按钮
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView).offset(-60);
        make.height.mas_equalTo(60);
        make.left.equalTo(self.view).mas_equalTo(leftMargin);
        make.right.equalTo(self.view).mas_equalTo(-leftMargin);
    }];
    loginBtn.backgroundColor = LightBrownColor;
    loginBtn.layer.cornerRadius = 30;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //    密码下方下划线
    UIView *bottomLine = [UIView new];
    [backView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(leftMargin);
        make.right.equalTo(self.view).offset(-leftMargin);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(loginBtn.mas_top).offset(-25);
    }];
    bottomLine.backgroundColor = LightBrownColor;
    
    //    密码
    UILabel *passwordLabel = [UILabel new];
    [backView addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(leftMargin);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo([UIFont systemFontOfSize:17].pointSize*3);
        make.bottom.equalTo(bottomLine.mas_top).offset(-5);
    }];
    passwordLabel.text = @"密码";
    passwordLabel.textColor = LightBrownColor;
    passwordLabel.textAlignment = NSTextAlignmentLeft;
    //    passwordLabel.font = [UIFont systemFontOfSize:14];
    
    passwordTextfield = [[UITextField alloc] init];
    [backView addSubview:passwordTextfield];
    passwordTextfield.borderStyle = UITextBorderStyleNone;
    passwordTextfield.secureTextEntry = YES;
    [passwordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordLabel.mas_right).offset(5);
        make.right.equalTo(bottomLine.mas_right);
        make.centerY.equalTo(passwordLabel);
    }];
    passwordTextfield.delegate = self;
    
    
    //    工号
    UIView *topLineView = [UIView new];
    [backView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(passwordLabel.mas_top).offset(-20);
        make.left.equalTo(self.view).offset(leftMargin);
        make.right.equalTo(self.view).offset(-leftMargin);
        make.height.mas_equalTo(1);
    }];
    topLineView.backgroundColor = LightBrownColor;
    
    UILabel *memberNOLabel = [UILabel new];
    [backView addSubview:memberNOLabel];
    [memberNOLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(leftMargin);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(FONT17.pointSize*3);
        make.bottom.equalTo(topLineView.mas_top).offset(-5);
    }];
    memberNOLabel.text = @"工号";
    memberNOLabel.textColor = LightBrownColor;
    memberNOLabel.textAlignment = NSTextAlignmentLeft;
    
    memberNOTextfield = [UITextField new];
    [backView addSubview:memberNOTextfield];
    [memberNOTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(memberNOLabel.mas_right).offset(5);
        make.right.mas_equalTo(backView).offset(-leftMargin);
        make.centerY.equalTo(memberNOLabel);
    }];
    memberNOTextfield.delegate = self;
    
//    ip
    UIView *toptopLineView = [UIView new];
    [backView addSubview:toptopLineView];
    [toptopLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(memberNOTextfield.mas_top).offset(-20);
        make.left.equalTo(self.view).offset(leftMargin);
        make.right.equalTo(self.view).offset(-leftMargin);
        make.height.mas_equalTo(1);
    }];
    toptopLineView.backgroundColor = LightBrownColor;
    
    UILabel *ipLabel = [UILabel new];
    [backView addSubview:ipLabel];
    [ipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(leftMargin);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(FONT17.pointSize*3);
        make.bottom.equalTo(toptopLineView.mas_top).offset(-5);
    }];
    ipLabel.text = @"IP地址";
    ipLabel.textColor = LightBrownColor;
    ipLabel.textAlignment = NSTextAlignmentLeft;
    
    IPTextfield = [UITextField new];
    [backView addSubview:IPTextfield];
    [IPTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ipLabel.mas_right).offset(5);
        make.right.mas_equalTo(backView).offset(-leftMargin);
        make.centerY.equalTo(ipLabel);
    }];
    if ([[userDefaults objectForKey:IPADD] length]) {
        IPTextfield.text = [userDefaults objectForKey:IPADD];
    }
    if ([[userDefaults objectForKey:USERID] length]) {
        memberNOTextfield.text = [userDefaults objectForKey:UUID];
    }
    IPTextfield.delegate = self;
}

- (void)scan: (UIButton *) sender {
    WQCodeScanner *scanner = [[WQCodeScanner alloc] init];
    [self presentViewController:scanner animated:YES completion:nil];
    scanner.resultBlock = ^(NSString *value) {
        IPTextfield.text = value;
    };
}

- (void)loginBtnClick:(UIButton *) sender {
    NSString *ipStr = [IPTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![ipStr containsString:@":"]) {
        SHOWTEXTINWINDOW(@"请输入正确的IP地址", 1);
        return;
    } else {
        ipStr = [ipStr substringToIndex:[ipStr rangeOfString:@":"].location];
    }
    
    NSArray *arr = [ipStr componentsSeparatedByString:@"."];
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
    [userDefaults setObject:IPTextfield.text forKey:IPADD];
    NSString *userId = [memberNOTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [passwordTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!userId.length) {
        SHOWTEXTINWINDOW(@"工号不能为空", 1);
        return;
    }
    
    if (!password.length) {
        SHOWTEXTINWINDOW(@"密码不能为空", 1);
        return;
    } else {
//        NSLog([self md532BitLower:password]);
        password = [[self md532BitLower:password] substringWithRange:NSMakeRange(6, 16)];
    }
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:RECEPRIONLOGIN parameters:@{@"userId":userId, @"password":password} success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        
        if (ISSUCCESS) {
            NSDictionary *empMpa = [CONTENTOBJ objectForKey:@"empMpa"];
            [userDefaults setObject:@"yes" forKey:ISLOGIN];
            [userDefaults setObject:userId forKey:UUID];
            [userDefaults setObject:[[empMpa objectForKey:@"position"] length] ? [empMpa objectForKey:@"e_EMPLOYEE_ID"] : @"" forKey:USERID];
            [userDefaults setObject:[[empMpa objectForKey:@"position"] length] ? [empMpa objectForKey:@"position"] : @"" forKey:POSITON];
            [userDefaults setObject:[[empMpa objectForKey:@"e_STORE_CD"] length] ? [empMpa objectForKey:@"e_STORE_CD"] : @"" forKey:STORECD];
            [userDefaults setObject:[[empMpa objectForKey:@"e_NAME"] length] ? [empMpa objectForKey:@"e_NAME"] : @"" forKey:USERNAME];
            [userDefaults setObject:[CONTENTOBJ objectForKey:@"RoleId"] forKey:RoleId];
//            no(0),
            /**
             * 管理员
             */
//            Administrator(1),
            /**
             * 接待部长
             */
//            reception(2),
            /**
             * 管理部长
             */
//            manager(3),
            /**
             * 派工部长
             */
//            tasking(4),
            /**
             * 经理
             */
//            amaldar(5),
            /**
             * 技师
             */
//            artificer(6),
            /**
             * 其他
             */
//            other(7);
            dispatch_async(dispatch_get_main_queue(), ^{
//                ShoppingMallTabBarViewController *tabBarController = [[ShoppingMallTabBarViewController alloc] init];
//                
//                LJLeftViewController *leftViewController = [[LJLeftViewController alloc] init];
//                
//                MMDrawerController *rooVC = [[MMDrawerController alloc] initWithCenterViewController:tabBarController leftDrawerViewController:leftViewController rightDrawerViewController:nil];
//                
//                //测了门的宽度
//                [rooVC setMaximumLeftDrawerWidth:kappScreenWidth * 0.8];
//                //设置侧拉门开与关的动画
//                [rooVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//                [rooVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//                //侧开内容展示效果
//                //设置向左滑动打开右侧栏
//                [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:MMDrawerAnimationTypeSlideAndScale];
//                //设置向右滑动打开左侧栏
//                [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeSlideAndScale];
//                
//                //
//                [rooVC setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
//                    MMDrawerControllerDrawerVisualStateBlock block;
//                    block = [[MMExampleDrawerVisualStateManager sharedManager]
//                             drawerVisualStateBlockForDrawerSide:drawerSide];
//                    if(block){
//                        block(drawerController, drawerSide, percentVisible);
//                    }  
//                    
//                }];

//                MMDrawerController * rootVC =[MMDrawerController shareRootVC];
                
//                [self presentViewController:rootVC animated:YES completion:nil];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            });
        } else {
            if ([OBJMESSAGE isEqualToString:@"password_validate"]) {
                SHOWTEXTINWINDOW(@"密码错误", 1);
            } else if ([OBJMESSAGE isEqualToString:@"notExist"]) {
                SHOWTEXTINWINDOW(@"用户不存在", 1);
            } else if ([OBJMESSAGE isEqualToString:@"pwd_validate_error"]) {
                SHOWTEXTINWINDOW(@"密码错误", 1);
            }else {
                BADREQUEST
            }
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//键盘控制
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}
- (void) keyboardWasShown:(NSNotification *) notif
{

    
    NSDictionary* info = [notif userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    if(kbSize.height == 216)
    {
        keyboardSizeHeight = kbSize.height;
    }
    else
    {
        keyboardSizeHeight = kbSize.height;   //252 - 216 系统键盘的两个不同高度
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        if (kappScreenHeight <= 480) {
            backView.frame = CGRectMake(0.0f, 100-keyboardSizeHeight, self.view.frame.size.width, self.view.frame.size.height);
        } else {
            backView.frame = CGRectMake(0.0f, 50-keyboardSizeHeight, self.view.frame.size.width, self.view.frame.size.height);
        }
        
    }];
    
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    keyboardSizeHeight = keyboardSize.height;
    [UIView animateWithDuration:0.1 animations:^{
        backView.frame = CGRectMake(0.0f, 0, backView.frame.size.width, backView.frame.size.height);
    }];
    
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (backView.frame.size.height - keyboardSizeHeight == 0 ? 216 : keyboardSizeHeight);//键盘高度216 或者 253
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0) {
        //        backView.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    [UIView animateWithDuration:0.3 animations:^{
    //        backView.frame = CGRectMake(0.0f, 0, backView.frame.size.width, backView.frame.size.height);
    //    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)md532BitLower:(NSString *) str
{
    const char *cStr = [str UTF8String];

    unsigned char result[16];

    

    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];

    CC_MD5( cStr,[num intValue], result );

    

    return [[NSString stringWithFormat:

             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",

             result[0], result[1], result[2], result[3],

             result[4], result[5], result[6], result[7],

             result[8], result[9], result[10], result[11],

             result[12], result[13], result[14], result[15]

             ] lowercaseString];
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
