//
//  ShoppingMallViewController.m
//  LianjunApp
//
//  Created by qm on 15/4/23.
//  Copyright (c) 2015年 qm. All rights reserved.
//

#import "ShoppingMallTabBarViewController.h"
#import "LJAddClientViewController.h"


@interface ShoppingMallTabBarViewController ()<CustomTabBarDelegate, UIGestureRecognizerDelegate>


@property (nonatomic,strong) LJRoomStateViewController *roomViewController;
@property (nonatomic,strong) LJWaitingAreaViewController *waitingViewController;
@property (nonatomic,strong) LJTechnicianViewController *technicianViewController;

@end

@implementation ShoppingMallTabBarViewController
@synthesize waitingViewController,technicianViewController,roomViewController,bottomTabBarView,homeButton;
- (id)init{
    static ShoppingMallTabBarViewController *tab = nil;
    if (!tab) {
        tab = [super init];
    }
    self = tab;
    
    if (self) {
        
        self.view.backgroundColor = gray238;
        
        self.roomViewController = [[LJRoomStateViewController alloc] init];
        
        UINavigationController *roomNavController = [[UINavigationController alloc] initWithRootViewController:self.roomViewController];
        roomNavController.navigationBarHidden = YES;
        
        self.waitingViewController = [[LJWaitingAreaViewController alloc] init];
        UINavigationController *waitingNavController = [[UINavigationController alloc] initWithRootViewController:self.waitingViewController];
        waitingNavController.navigationBarHidden = YES;
        
        technicianViewController = [[LJTechnicianViewController alloc] init];
        UINavigationController *technicianNavController = [[UINavigationController alloc] initWithRootViewController:self.technicianViewController];
        technicianNavController.navigationBarHidden = YES;
        
        HLShouPaiViewController *shoupaiViewController= [[HLShouPaiViewController alloc] init];
        UINavigationController *shoupaiNav = [[UINavigationController alloc] initWithRootViewController:shoupaiViewController];
        shoupaiNav.navigationBarHidden = YES;
        
//        UIViewController *vc = [[UIViewController alloc] init];
        UIViewController *vc2 = [[UIViewController alloc] init];
        
        NSArray *controllsersArray = [NSArray arrayWithObjects:roomNavController,waitingNavController, technicianNavController, shoupaiNav,vc2, nil];
        [self.tabBar setHidden:YES];
        
        [self setViewControllers:controllsersArray];
        
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;

    }
    
    return self;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    } else {
        return YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 29.0f;
    bottomTabBarView = [[CustomTabBarView alloc] initWithFrame:CGRectMake(0, kappScreenHeight-barHeight, kappScreenWidth, barHeight)];
    [bottomTabBarView setDelegate:self];
    [bottomTabBarView setBackgroundColor:[[UIColor alloc] initWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
    [self.view addSubview:bottomTabBarView];
//#define kSafeHeight [[UIApplication sharedApplication] statusBarFrame].size.height - 20
//#define kTabBarHeight kSafeHeight ? kSafeHeight + 20.0f : 49.0f
    NSLog(@"%F", [[UIApplication sharedApplication] statusBarFrame].size.height);
    NSLog(@"%F", barHeight);
}
- (void)hideTabBar:(BOOL)boo{
    CGFloat barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 29.0f;
    if (boo) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.bottomTabBarView.frame = CGRectMake(0, kappScreenHeight, kappScreenWidth, barHeight);
//            self.bottomTabBarView.hidden = YES;
//            homeButton.hidden = YES;
            
        }];
        

    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.bottomTabBarView.frame = CGRectMake(0, kappScreenHeight-barHeight, kappScreenWidth, barHeight);
//            self.bottomTabBarView.hidden = NO;
//            homeButton.hidden = NO;

        }];
        
        
    }
    
    

}
- (void)gohome{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)tabBarItemSelectedWithIndex:(int)index{
    if (index == 101) {
        SHOWTEXTINWINDOW(@"暂未开放", 1.5);
        return;
    }

    if (index == 109) {
        SHOWTEXTINWINDOW(@"暂未开放", 1.5);
        return;
        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] POST:BUSINESSDATE parameters:@{} success:^(AFHTTPRequestOperation *operation, id obj) {
            DISMISS
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@", jsonString);
            
            if (ISSUCCESS) {
                NSString *dateStr = [CONTENTOBJ objectForKey:@"BusinessDate"];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                df.dateFormat = @"YYYY-MM-dd";
                NSDate *date = [df dateFromString:dateStr];
                date = [self getNowDateFromatAnDate:date];
                
                NSCalendar *calendar = [NSCalendar currentCalendar];
                
                NSDate *nowDate = [NSDate date];
                
                NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nowDate];
                nowDate = [calendar dateFromComponents:components];
                nowDate = [self getNowDateFromatAnDate:nowDate];
                
                NSLog(@"date = %@, nowdate = %@", date, nowDate);
                NSTimeInterval business = [date timeIntervalSince1970];
                NSTimeInterval now = [nowDate timeIntervalSince1970];
                
                if (business > now) {
                    //NSLog(@"Date1  is in the future");
                    NSLog(@"大");
                } else if (business < now){
                    //NSLog(@"Date1 is in the past");
                    NSLog(@"小");
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
                    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
                    int hour = (int) [dateComponent hour];
                    if (hour >= 7) {
                        SHOWTEXTINWINDOW(@"还未日结，请日结后开单", 1);
                        return ;
                    }
                } else  {
                    NSLog(@"相等");
                }
                
                
                LJAddClientViewController *add = [[LJAddClientViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:add];
                nav.navigationBarHidden = YES;
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DISMISS
            SHOWTEXTINWINDOW(@"获取营业日失败", 1);
            
        }];
        
        
        return;
    } else if (index == 104) {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"请选择菜单" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"开单", @"开单明细", @"销售业绩", @"等待区域", nil];
        [as showInView:self.view];
        return;
    }
    
    [self setSelectedIndex:index-100];
    
}
//把国际时间转换为当前系统时间
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] POST:BUSINESSDATE parameters:@{} success:^(AFHTTPRequestOperation *operation, id obj) {
            DISMISS
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@", jsonString);
            
            if (ISSUCCESS) {
                NSString *dateStr = [CONTENTOBJ objectForKey:@"BusinessDate"];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                df.dateFormat = @"YYYY-MM-dd";
                NSDate *date = [df dateFromString:dateStr];
                date = [self getNowDateFromatAnDate:date];
                
                NSCalendar *calendar = [NSCalendar currentCalendar];
                
                NSDate *nowDate = [NSDate date];
                
                NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nowDate];
                nowDate = [calendar dateFromComponents:components];
                nowDate = [self getNowDateFromatAnDate:nowDate];
                
                NSLog(@"date = %@, nowdate = %@", date, nowDate);
                NSTimeInterval business = [date timeIntervalSince1970];
                NSTimeInterval now = [nowDate timeIntervalSince1970];
                
                if (business > now) {
                    //NSLog(@"Date1  is in the future");
                    NSLog(@"大");
                } else if (business < now){
                    //NSLog(@"Date1 is in the past");
                    NSLog(@"小");
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
                    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
                    int hour = (int) [dateComponent hour];
                    if (hour >= 7) {
                        SHOWTEXTINWINDOW(@"还未日结，请日结后开单", 1);
                        return ;
                    }
                } else  {
                    NSLog(@"相等");
                }
                
                
                LJAddClientViewController *add = [[LJAddClientViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:add];
                nav.navigationBarHidden = YES;
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DISMISS
            SHOWTEXTINWINDOW(@"获取营业日失败", 1);
            
        }];
        
        
        
    } else if (buttonIndex == 1) {
        NSLog(@"开单明细");
        LJCollectViewController *next = [[LJCollectViewController alloc] init];
        next.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:next animated:YES completion:^{
            
        }];
        
    } else if (buttonIndex == 2) {
        NSLog(@"销售业绩");
        HLTotalViewController *totalViewController = [[HLTotalViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:totalViewController];
        [nav setNavigationBarHidden:YES];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    } else if (buttonIndex == 3) {
        NSLog(@"等待区域");
        UINavigationController *waitingNavController = [[UINavigationController alloc] initWithRootViewController:self.waitingViewController];
        waitingNavController.navigationBarHidden = YES;
//        waitingNavController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:waitingNavController animated:YES completion:^{
            
        }];
    }
}

// called when keyboard search button pressed

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
