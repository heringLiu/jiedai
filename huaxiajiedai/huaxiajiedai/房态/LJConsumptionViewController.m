
//
//  LJConsumptionViewController.m
//  huaxiajiedai
//
//  Created by qm on 16/4/22.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJConsumptionViewController.h"
#import "LJHLGridView.h"
#import "LJAddClientViewController.h"
#import "LJWaitingAreaViewController.h"
#import "LJReceptionDetailModel.h"
#define gridViewWidth 100 *2 + 80 * 7 + 4 * 60

@interface LJConsumptionViewController () <GridViewDelegate,SelectRoomDelegate, UIActionSheetDelegate> {
    
    LJHLGridView *gridView;
    //    订单号
    UILabel *orderNumberLabel;
    //    当日波数
    UILabel *daysBoNumberLabel;
    //    人数
    UILabel *personCountLbel;
    
    UIScrollView *backView;
    
    UIButton *nextButton;
    
    NSArray *_tables;
    NSArray *_dataModels;
    NSArray *_rowExamples;
    
    NSInteger _stepperPreviousValue;
    
    UIScrollView *listScrollView;
    
    UIButton *leftBottomButton;
    
    UIButton *rightBottomButton;
    
    CGFloat keyboardSizeHeight;
    
    LJReceptionListRowView *firstReceptionView ;
    LJReceptionListRowView *secondReceptionView;
    LJReceptionListRowView *thirdReceptionView;
    
    UIView *firstLineView;
    
    CGFloat listHeight;
    
    UIView *lineView;

    NSArray *employeeTabs;
    NSArray *customTypeList;
    
    NSMutableArray *bianhaoArr;
    NSMutableArray *nameArr;
    NSMutableArray *typeArr;
    
//    转房间选中的客人的所有明细
    NSMutableArray *detailArr;
//    转房间未选中的客人的所有明细
    NSMutableArray *noSelectedArr;
    

}

@end

@implementation LJConsumptionViewController
@synthesize topView, rightMenuView, dataList, myControl, pickView;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}


- (void)layoutSubviews {
    listScrollView.contentSize = CGSizeMake(gridViewWidth, listScrollView.frame.size.height);
}

- (void) loadData {
    if (self.orderCd.length) {
        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] GET:RECEPTIONEDITORDER parameters:@{@"orderCd":self.orderCd} success:^(AFHTTPRequestOperation *operation, id obj) {
            DISMISS
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
            
            if (ISSUCCESS) {
                self.dataDic = CONTENTOBJ;
                self.headerEntity = [[LJConsumptionHeaderModel alloc] init];
                [self.headerEntity setValuesForKeysWithDictionary:CONTENTOBJ];
                [self.headerEntity setValuesForKeysWithDictionary:[CONTENTOBJ objectForKey:@"receptionOrderHeadTab"]];
                [self createUI];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    } else {
        SHOWTEXTINWINDOW(@"缺少单号", 1);
    }
}
- (void)closePickView {
    [self pickViewDone];
}

- (void)selectedDone:(NSInteger)index {
    [gridView selectedDone:index];
    
}


- (void)pickViewDone {
    [UIView animateWithDuration:0.3 animations:^{
        myControl.hidden = YES;
        pickView.frame = CGRectMake(0, kappScreenHeight, kappScreenWidth, 260);
    }];
    
}

- (void) showPickViewWithData:(NSMutableArray *) datas {
    nameArr = datas;
    [self.view endEditing:YES];
    pickView.datas = datas;
    [UIView animateWithDuration:0.3 animations:^{
        myControl.hidden = NO;
        pickView.frame = CGRectMake(0, kappScreenHeight - 260, kappScreenWidth, 260);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"didAppear");
    backView.contentSize = CGSizeMake(kappScreenWidth, 50 + 70 * 1 + 50 + listHeight + 100 > kappScreenHeight - kTopScreenWidth ? 50 + 70 * 1 + 50 + listHeight + 100 : kappScreenHeight - kTopScreenWidth);
    
    listScrollView.contentSize = CGSizeMake(gridViewWidth, listScrollView.frame.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    listHeight = 300;
    [self loadData];
    
    [self registerForKeyboardNotifications];
    self.view.backgroundColor = gray238;
    topView = [[CustomTopNavigationView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, kTopScreenWidth)];
    [self.view addSubview:topView];
    topView.delegate = self;
    topView.backgroundColor = navLightBrownColor;
    topView.titleLabel.text = @"消费订单详情";
    [topView.leftButton setImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    [topView.rightButton setImage:[UIImage imageNamed:@"icon_Menu"] forState:UIControlStateNormal];
    topView.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
    
}


- (void)rightButtonPressed {
    NSLog(@"right %g", rightMenuView.frame.origin.x);
    if (rightMenuView.frame.origin.x == kappScreenWidth) {
        [self saveData];
        [UIView animateWithDuration:0.3 animations:^{
            rightMenuView.frame = CGRectMake(0, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth);
            [topView.rightButton setTitle:@"隐藏" forState:UIControlStateNormal];
            [topView.rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }];
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{
            rightMenuView.frame = CGRectMake(kappScreenWidth, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth);
            [topView.rightButton setTitle:@"" forState:UIControlStateNormal];
            [topView.rightButton setImage:[UIImage imageNamed:@"icon_Menu"] forState:UIControlStateNormal];
        }];
    }

}

- (void)leftButtonPressed {
    NSLog(@"right");
    
    if (rightMenuView && rightMenuView.frame.origin.x == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            rightMenuView.frame = CGRectMake(kappScreenWidth, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth);
            [topView.rightButton setTitle:@"" forState:UIControlStateNormal];
            [topView.rightButton setImage:[UIImage imageNamed:@"icon_Menu"] forState:UIControlStateNormal];
        }];
    } else {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LJWaitingAreaViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
    }
    
    
}

- (void)sendSelectedTag:(NSInteger)buttonTag {
    if (buttonTag == 1000) {
        // 增加客户
        LJAddClientViewController *next = [[LJAddClientViewController alloc] init];
        next.customerType = self.headerEntity.customerType;
        next.isConsumption = YES;
        next.roomCd = self.roomCd;
        next.orderCd = self.headerEntity.orderCd;
        next.bociString = self.headerEntity.customerTurnCd;
        [self rightButtonPressed];
        [self.navigationController pushViewController:next animated:YES];
    } else if (buttonTag == 1001) {
        // 删除客户
        if (self.pendingList) {
            [self.pendingList removeAllObjects];
        } else {
            self.pendingList = [NSMutableArray array];
        }
        for (int i = 0; i < self.dataList.count; i++) {
            LJReceptionDetailModel *entity = [self.dataList objectAtIndex:i];
            if (entity.isSelected) {
                if (![self.pendingList containsObject:entity.customerCd]) {
                    [self.pendingList addObject:entity.customerCd];
                }
            }
        }
        
        if (self.pendingList.count) {
            
            UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"技师原因", @"非技师原因", nil];
            as.tag = 5000;
            [as showInView:self.view];
            
        } else {
            SHOWTEXTINWINDOW(@"请至少选择一条", 1);
        }
    } else if (buttonTag == 1003) {
        //        增加明细
        if (self.orderDetailParamList) {
            [self.orderDetailParamList removeAllObjects];
        } else {
            self.orderDetailParamList = [NSMutableArray array];
        }
        
        for (int i = 0; i < self.dataList.count; i++) {
            LJReceptionDetailModel *entity = [self.dataList objectAtIndex:i];
            if (entity.isSelected) {
                BOOL flag = YES;
                for (LJReceptionDetailModel *model in self.orderDetailParamList) {
                    if ([model.customerCd isEqualToString:entity.customerCd]) {
                        flag = NO;
                        break;
                    }
                }
                if (flag) {
                    [self.orderDetailParamList addObject:entity];
                }
            }
        }
        
        if (self.orderDetailParamList.count) {
            NSMutableArray *arr = [NSMutableArray array];
            for (LJReceptionDetailModel *entity in self.orderDetailParamList) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (entity.customerCd.length) {
                    [dic setValue:entity.customerCd forKey:@"customerCd"];
                }
                
                if (entity.roomCd.length) {
                    [dic setValue:entity.roomCd forKey:@"roomCd"];
                }
                
                if (entity.customerTurnCd.length) {
                    [dic setValue:entity.customerTurnCd forKey:@"customerTurnCd"];
                }
                
                if (entity.sex.length) {
                    [dic setValue:entity.sex forKey:@"sex"];
                }
                [arr addObject:dic];
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            if (self.headerEntity.salemanCd.length) {
                [dic setValue:self.headerEntity.salemanCd forKey:@"saleManCd"];
            }
            if (self.headerEntity.orderCd.length) {
                [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
            }
            if (arr.count) {
                [dic setValue:arr forKey:@"orderDetil"];
            }
            if (self.headerEntity.customerTurnCd.length) {
                [dic setValue:self.headerEntity.customerTurnCd forKey:@"customerTurnCd"];
            }
            
            SHOWSTATUSCLEAR
            [[NetWorkingModel sharedInstance] POST:XIAOFEIADDDETIL parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                DISMISS
                if (ISSUCCESS) {
                    SHOWTEXTINWINDOW(@"操作成功", 1);
                    [self rightButtonPressed];
                    [self loadData];
                } else {
                    BADREQUEST
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
        } else {
            SHOWTEXTINWINDOW(@"请至少选择一位客户", 1);
        }
        
    } else if (buttonTag == 1004) {
        //        删除明细
        if (self.orderDetailParamList) {
            [self.orderDetailParamList removeAllObjects];
        } else {
            self.orderDetailParamList = [NSMutableArray array];
        }
        for (int i = 0; i < self.dataList.count; i++) {
            LJReceptionDetailModel *entity = [self.dataList objectAtIndex:i];
            if (entity.isSelected) {
                if (![self.orderDetailParamList containsObject:entity]) {
                    [self.orderDetailParamList addObject:entity];
                }
            }
        }
        if (self.orderDetailParamList.count) {
            
            UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"技师原因", @"非技师原因", nil];
            as.tag = 5001;
            [as showInView:self.view];
            
        } else {
            SHOWTEXTINWINDOW(@"请至少选择一条", 1);
        }
        
    } else if (buttonTag == 1005) {
        //        取消点钟
        detailArr = [NSMutableArray array];
        
        NSMutableArray *subArr = [NSMutableArray array];
        for (int i = 0; i < self.dataList.count; i++) {
            
            LJReceptionDetailModel *entity = [self.dataList objectAtIndex:i];
            if (entity.isSelected) {
                if (![detailArr containsObject:entity]) {
                    NSMutableDictionary *subDic = [NSMutableDictionary dictionary];
                    [detailArr addObject:entity];
                    if (entity.projectCd.length) {
                        [subDic setValue:entity.projectCd forKey:@"projectCd"];
                    }
                    
                    if (entity.customerCd.length) {
                        [subDic setValue:entity.customerCd forKey:@"customerCd"];
                    }
                    
                    if (entity.detailNo.length) {
                        [subDic setValue:entity.detailNo forKey:@"detailNo"];
                    }
                    if (entity.artificer1Cd.length && [entity.artificer1SelectType isEqualToString:@"callTime"]) {
                        [subDic setValue:entity.artificer1Cd forKey:@"artificer1Cd"];
                    }
                    if (entity.artificer2Cd.length && [entity.artificer2SelectType isEqualToString:@"callTime"]) {
                        [subDic setValue:entity.artificer2Cd forKey:@"artificer2Cd"];
                    }
                    
                    [subArr addObject:subDic];
                }
            }
        }
        
        if (!detailArr.count) {
            SHOWTEXTINWINDOW(@"请至少选择一条数据", 1);
            return;
        }
        
        LJReceptionDetailModel *entity = [detailArr firstObject];
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
        if (entity.orderCd.length) {
            [dic setValue:entity.orderCd forKey:@"orderCd"];
        }
        
        [dic setValue:subArr forKey:@"orderDetailParamList"];
        
        
        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] POST:CANCELCALL parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
            DISMISS
            if (ISSUCCESS) {
                [self rightButtonPressed];
                [self loadData];
                SHOWTEXTINWINDOW(@"操作成功", 1);
            } else {
                BADREQUEST
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        //        加钟
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
//        if (self.headerEntity.orderCd.length) {
//            [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
//        }
//
//        NSMutableArray *arr = [NSMutableArray array];
//        BOOL flag = NO;
//        for (LJReceptionDetailModel *entity in self.dataList) {
//            if (entity.isSelected) {
//                NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
//                if (entity.customerCd.length) {
//                    [mutDic setValue:entity.customerCd forKey:@"customerCd"];
//                }
//                if (entity.detailNo.length) {
//                    [mutDic setValue:entity.detailNo forKey:@"detailNo"];
//                }
//                if (entity.projectCd.length) {
//                    [mutDic setValue:entity.projectCd forKey:@"projectCd"];
//                }
//                if ([entity.serveStatus isEqualToString:@"overdue"] || [entity.serveStatus isEqualToString:@"wait"] || [entity.serveStatus isEqualToString:@"nothing"]) {
//                    SHOWTEXTINWINDOW(@"项目未起钟，不能加钟", 1);
//                    flag = YES;
//                    break;
//                }
//
//                if ([entity.serveStatus isEqualToString:@"downtime"]) {
//                    SHOWTEXTINWINDOW(@"项目已落钟，不能加钟", 1);
//                    flag = YES;
//                    break;
//                }
//
//                [arr addObject:mutDic];
//            }
//        }
//        if (flag) {
//            return;
//        }
//        if (arr.count) {
//            [dic setValue:arr forKey:@"orderDetailParamList"];
//        } else {
//            SHOWTEXTINWINDOW(@"请至少选择一条", 1);
//            return;
//        }
//
//        NSLog(@"dic = %@", dic);
//        SHOWSTATUSCLEAR
//        [[NetWorkingModel sharedInstance] POST:XIAOFEIPLUSTIME parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
//            DISMISS
//            if (ISSUCCESS) {
//                SHOWTEXTINWINDOW(@"操作成功", 1);
//                [self loadData];
//                [self rightButtonPressed];
//            } else {
//                if ([OBJMESSAGE isEqualToString:@"error_project"]) {
//                    SHOWTEXTINWINDOW(@"项目不能为空", 1);
//                } else if ([OBJMESSAGE isEqualToString:@"error_serve"]) {
//                    SHOWTEXTINWINDOW(@"只有正在上钟的项目才能加钟", 1);
//                } else if ([OBJMESSAGE isEqualToString:@"error_waiting"]) {
//                    SHOWTEXTINWINDOW(@"技师已经排班，暂时不能加钟。", 1);
//                } else {
//                    BADREQUEST
//                }
//
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        }];
//
    } else if (buttonTag == 1002) {
//        更改房间
        
        [[NetWorkingModel sharedInstance] GET:testUpdateRoom parameters:@{@"userId":[userDefaults objectForKey:USERID]} success:^(AFHTTPRequestOperation *operation, id obj) {
            
            if (ISSUCCESS) {
                if (self.pendingList) {
                    [self.pendingList removeAllObjects];
                } else {
                    self.pendingList = [NSMutableArray array];
                }
                //        保存选中的客人id
                for (int i = 0; i < self.dataList.count; i++) {
                    LJReceptionDetailModel *entity = [self.dataList objectAtIndex:i];
                    if (entity.isSelected) {
                        if (![self.pendingList containsObject:entity.customerCd]) {
                            [self.pendingList addObject:entity.customerCd];
                        }
                    }
                }
                //        选中客人的所有的明细添加进数组
                detailArr = [NSMutableArray array];
                noSelectedArr = [NSMutableArray array];
                for (NSString *str in self.pendingList) {
                    for (LJReceptionDetailModel *entity in self.dataList) {
                        if ([entity.customerCd isEqualToString:str] && ![detailArr containsObject:entity]) {
                            [detailArr addObject:entity];
                        }
                    }
                }
                
                if (!detailArr.count) {
                    SHOWTEXTINWINDOW(@"至少选择一条明细", 1);
                    return;
                }
                
                //        如果数组中有未落钟的项目则可以继续
                BOOL flag = YES;
                for (LJReceptionDetailModel *entity in detailArr) {
                    if (!entity.qtyUpdateFlg && ![entity.serveStatus isEqualToString:@"downtime"]) {
                        flag = NO;
                        break;
                    }
                }
                
                if (flag) {
                    SHOWTEXTINWINDOW(@"您选择的客户的项目都已落钟，不能进行更换房间", 1);
                    return;
                }
                
                LJSelectRoomViewController *next = [[LJSelectRoomViewController alloc] init];
                next.delegate = self;
                next.isConsumption = YES;
                next.navColor = NavBackColor;
                next.titleString = @"选择房间";
                next.view.backgroundColor = WhiteColor;
                
                [self.navigationController pushViewController:next animated:YES];
            } else {
                if ([OBJMESSAGE isEqualToString:@"error_Noauthority"]) {
                    SHOWTEXTINWINDOW(@"没有权限", 1);
                } else {
                    BADREQUEST
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    } else if (buttonTag == 1006) {
        //        打印
        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] GET:XIAOFEIPRINT parameters:@{@"orderCd":_headerEntity.orderCd,@"customerCd":@"", @"detailNo":@""} success:^(AFHTTPRequestOperation *operation, id obj) {
            DISMISS
            NSLog(@"obj = %@", obj);
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
            
            if (ISSUCCESS) {
                
                SHOWTEXTINWINDOW(@"打印成功", 1);
                [self rightButtonPressed];
            } else {
                SHOWTEXTINWINDOW(OBJMESSAGE, 2);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
    } else if (buttonTag == 1007) {
       
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 5000) {
        
        if (buttonIndex == 2) {
            return;
        } else if (buttonIndex == 1) {
            //            非技师原因
            self.deleReason = @"1";
        } else if (buttonIndex == 0) {
            //技师原因
            self.deleReason = @"2";
        }
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"确定删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        av.tag = 2000;
        [av show];
    } else if (actionSheet.tag == 5001) {
        if (buttonIndex == 2) {
            return;
        } else if (buttonIndex == 1) {
            //            非技师原因
            self.deleReason = @"1";
        } else if (buttonIndex == 0) {
            //技师原因
            self.deleReason = @"2";
        }
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"确定删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        av.tag = 2001;
        [av show];
    }
    
}


- (void)sendRoom:(LJRoomModel *)room {
//    NSInteger coustomerNum = 0;
//    for (NSString *str in self.pendingList) {
//        for (LJReceptionDetailModel *entity in self.dataList) {
//            if ([entity.customerCd isEqualToString:str] && !entity.qtyUpdateFlg && ![entity.serveStatus isEqualToString:@"downtime"]) {
//                coustomerNum++;
//                break;
//            }
//        }
//    }
    
    if (self.pendingList.count == [self.headerEntity.customerQty integerValue]) {
        //            全选的情况，转房间
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (self.headerEntity.orderCd.length) {
            [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
        }
        if (room.roomCd.length) {
            [dic setValue:room.roomCd forKey:@"roomCd"];
        }
        
//        [dic setValue:[NSNumber numberWithInt:coustomerNum] forKey:@"coustomerNum"];
        
        [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
        
        NSLog(@"dic = %@", dic);
        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] POST:XIAOFEICHANGEROOM parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
            DISMISS
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
            if (ISSUCCESS) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                if ([OBJMESSAGE isEqualToString:@"error_sofa"]) {
                    SHOWTEXTINWINDOW(@"该房间剩余沙发数量不足", 1);
                } else {
                    BADREQUEST
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    } else {
//        判断未选择的客人是否有未完成项目
//        如果有则拆
//        没有就转房间
        BOOL flag = YES;
        for (LJReceptionDetailModel *entity in detailArr) {
            if (!entity.qtyUpdateFlg && ![entity.serveStatus isEqualToString:@"downtime"]) {
                flag = NO;
                break;
            }
        }
        
        if (flag) {
//            剩余客人的项目都已经落钟，转房间
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (self.headerEntity.orderCd.length) {
                [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
            }
            if (room.roomCd.length) {
                [dic setValue:room.roomCd forKey:@"roomCd"];
            }
            
//            [dic setValue:[NSNumber numberWithInt:coustomerNum] forKey:@"coustomerNum"];
            
            [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
            
            NSLog(@"dic = %@", dic);
            SHOWSTATUSCLEAR
            [[NetWorkingModel sharedInstance] POST:XIAOFEICHANGEROOM parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                DISMISS
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", jsonString);
                if (ISSUCCESS) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    if ([OBJMESSAGE isEqualToString:@"error_sofa"]) {
                        SHOWTEXTINWINDOW(@"该房间剩余沙发数量不足", 1);
                    } else {
                        BADREQUEST
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
        } else {
            if (self.pendingList.count == 0) {
                
                return;
            }
//            剩余客人有未落钟项目，拆单
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (self.headerEntity.orderCd.length) {
                [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
            }
            if (room.roomCd.length) {
                [dic setValue:room.roomCd forKey:@"roomCd"];
            }
            
//            [dic setValue:[NSNumber numberWithInt:coustomerNum] forKey:@"coustomerNum"];
            
            [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
            
            [dic setValue:self.pendingList forKey:@"customerCds"];
            
            NSLog(@"dic = %@", dic);
            SHOWSTATUSCLEAR
            [[NetWorkingModel sharedInstance] POST:XIAOFEICHAIDAN parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                DISMISS
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", jsonString);
                if (ISSUCCESS) {
                    [self rightButtonPressed];
                    [self loadData];
                } else {
                    if ([OBJMESSAGE isEqualToString:@"error_sofa"]) {
                        SHOWTEXTINWINDOW(@"该房间剩余沙发数量不足", 1);
                    } else {
                        BADREQUEST
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2000) {
        // 删除客户
        if (buttonIndex == 1) {
            // 删除
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if ([[userDefaults objectForKey:USERID] length]) {
                [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
            }
            if (self.headerEntity.orderCd.length) {
                [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
            }
            if (self.pendingList.count) {
                [dic setValue:self.pendingList forKey:@"customerCds"];
            }
            if (self.deleReason.length) {
                [dic setValue:self.deleReason forKey:@"deleReason"];
            }
//            NSDictionary *dic = @{@"userId":[userDefaults objectForKey:USERID], @"orderCd":self.headerEntity.orderCd, @"customerCds":self.pendingList};
            SHOWSTATUSCLEAR
            [[NetWorkingModel sharedInstance] POST:RECEPTIONORDERHEADERDELETECUSTOMER parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                DISMISS
                if (ISSUCCESS) {
                    SHOWTEXTINWINDOW(@"删除成功", 1);
                    [self loadData];
                    [self rightButtonPressed];
                } else {
                    if ([OBJMESSAGE isEqualToString:@"error_deleted"]) {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"上钟、落钟的明细不能删除";
                        [hud hide:YES afterDelay:1];
                    } else if ([OBJMESSAGE isEqualToString:@"error_Noauthority"]) {
                        SHOWTEXTSELFVIEW(@"没有权限", 1);
                    } else {
                        BADREQUEST
                    }
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            
        }
    }else if (alertView.tag == 2001) {
        //        删除明细
        if (buttonIndex == 1) {
            NSMutableArray *arr = [NSMutableArray array];
            for (LJReceptionDetailModel *entity in self.orderDetailParamList) {
                NSDictionary *dic = @{@"projectCd":entity.projectCd, @"customerCd":entity.customerCd, @"detailNo":entity.detailNo};
                [arr addObject:dic];
            }
            
            NSDictionary *dic = @{@"userId":[userDefaults objectForKey:USERID], @"orderCd":self.headerEntity.orderCd, @"orderDetailParamList":arr,@"deleReason":self.deleReason};
            SHOWSTATUSCLEAR
            [[NetWorkingModel sharedInstance] POST:XIAOFEIDELETEDETIL parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                DISMISS
                if (ISSUCCESS) {
                    SHOWTEXTINWINDOW(@"删除成功", 1);
                    [self loadData];
                    [self rightButtonPressed];
                } else {
                    if ([OBJMESSAGE isEqualToString:@"error_deleted"]) {
//                        SHOWTEXTINWINDOW(@"上钟、落钟的明细不能删除", 1);
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"上钟、落钟的明细不能删除";
                        [hud hide:YES afterDelay:1];
                    }  else if ([OBJMESSAGE isEqualToString:@"error_Noauthority"]) {
                        SHOWTEXTSELFVIEW(@"没有权限", 1);
                    }  else if ([OBJMESSAGE isEqualToString:@"error_Noauthority"]) {
                        SHOWTEXTSELFVIEW(@"没有权限", 1);
                    } else {
                        BADREQUEST
                    }
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            
        }
        
    }
}

-  (void) createUI {
    if (dataList == nil) {
        dataList = [NSMutableArray array];
    } else {
        [dataList removeAllObjects];
    }
    
    
    for (NSDictionary *dic in [self.dataDic objectForKey:@"receptionOrderDetailTabList"]) {
        LJReceptionDetailModel *entity = [[LJReceptionDetailModel alloc] init];
        [entity setValuesForKeysWithDictionary:dic];
        entity.o_projectCd = entity.projectCd;
        [dataList addObject:entity];
    }
    
    if (dataList.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (backView == nil) {
        backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth)];
        [self.view addSubview:backView];
        backView.backgroundColor = gray238;
        backView.delegate = self;
    }
    NSInteger count = 5;
    
    if (kappScreenHeight == 568.0f) {
//        5
        count = 6;
    } else if (kappScreenHeight == 667.0f) {
//        6
        count = 7;
    } else if (kappScreenHeight == 736.0f) {
//        6 plus
        count = 8;
    }
    
    if (dataList.count < count) {
        listHeight = (dataList.count+1) * 50;
    } else {
        listHeight = 50 * count + 50;
    }
    NSLog(@"加载了数据");
    backView.contentSize = CGSizeMake(kappScreenWidth, 50 + 70 * 1 + 50 + listHeight + 100);
    
    // 第一行
    if (!firstLineView) {
        firstLineView = [[UIView alloc] init];
        [backView addSubview:firstLineView];
        [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kappScreenWidth);
            make.top.equalTo(backView);
            make.left.equalTo(self.view);
            make.height.mas_equalTo(50);
        }];
        firstLineView.backgroundColor = WhiteColor;
    }
    
    //    人数
    if (personCountLbel == nil) {
        personCountLbel = [UILabel new];
        [firstLineView addSubview:personCountLbel];
        [personCountLbel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(firstLineView.mas_right).offset(-20);
            make.centerY.equalTo(firstLineView.mas_centerY);
            make.top.equalTo(firstLineView);
        }];
        
        personCountLbel.textColor = gray104;
        personCountLbel.font = FONT12;
        personCountLbel.textAlignment = NSTextAlignmentRight;
    }
    
    //    波数
    if (daysBoNumberLabel == nil) {
        daysBoNumberLabel = [UILabel new];
        [firstLineView addSubview:daysBoNumberLabel];
        [daysBoNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (kappScreenWidth <= 320) {
                make.right.equalTo(personCountLbel.mas_left).offset(-3);
            } else {
                make.right.equalTo(personCountLbel.mas_left).offset(-10);
            }
            
            make.centerY.equalTo(firstLineView.mas_centerY);
            make.top.equalTo(firstLineView);
        }];
        daysBoNumberLabel.lineBreakMode = NSLineBreakByTruncatingHead;
        daysBoNumberLabel.textColor = gray104;
        daysBoNumberLabel.font = FONT12;
        daysBoNumberLabel.textAlignment = NSTextAlignmentRight;
    }
    
    //    订单号
    if (orderNumberLabel == nil) {
        orderNumberLabel = [UILabel new];
        [firstLineView addSubview:orderNumberLabel];
        [orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstLineView).offset(20);
            make.centerY.equalTo(firstLineView.mas_centerY);
            make.top.equalTo(firstLineView);
            if (kappScreenWidth <= 320) {
                make.right.equalTo(daysBoNumberLabel.mas_left).offset(-3);
            } else {
                make.right.equalTo(daysBoNumberLabel.mas_left).offset(-10);
            }
            
        }];
        orderNumberLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        orderNumberLabel.textColor = gray104;
        orderNumberLabel.font = FONT12;
    }
    
    
    // line
    if (!lineView) {
        lineView =  [UIView new];
        [firstLineView addSubview:lineView];
        lineView.backgroundColor = gray238;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstLineView);
            make.right.equalTo(firstLineView);
            make.bottom.equalTo(firstLineView);
            make.height.mas_equalTo(1);
        }];
    }
    
    // 接待  录入  变更
    CGFloat height = 70;
    if (kappScreenWidth == 320) {
        height = 70;
    }
    if (!firstReceptionView ) {
        firstReceptionView = [[LJReceptionListRowView alloc] init];
        [backView addSubview:firstReceptionView];
        [firstReceptionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstLineView);
            make.right.equalTo(firstLineView);
            make.top.equalTo(firstLineView.mas_bottom);
            make.height.mas_equalTo(height);
        }];
    }
    
//    if (!secondReceptionView) {
//        secondReceptionView = [[LJReceptionListRowView alloc] init];
//        [backView addSubview:secondReceptionView];
//        [secondReceptionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(firstLineView);
//            make.right.equalTo(firstLineView);
//            make.top.equalTo(firstReceptionView.mas_bottom);
//            make.height.mas_equalTo(height);
//        }];
//    }
//    
//    if (!thirdReceptionView) {
//        thirdReceptionView = [[LJReceptionListRowView alloc] init];
//        [backView addSubview:thirdReceptionView];
//        [thirdReceptionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(firstLineView);
//            make.right.equalTo(firstLineView);
//            make.top.equalTo(secondReceptionView.mas_bottom);
//            make.height.mas_equalTo(height);
//        }];
//        thirdReceptionView.bottomLineView.hidden = YES;
//    }
    if (!listScrollView) {
        listScrollView = [[UIScrollView alloc] init];
        listScrollView.backgroundColor = WhiteColor;
        listScrollView.bounces = NO;
        [backView addSubview:listScrollView];

    }
    listScrollView.frame = CGRectMake(0,  50 + 70 * 1 + 10, kappScreenWidth, listHeight);
//    listScrollView.frame = CGRectMake(0,  50 + 70 * 3 + 10, kappScreenWidth, listHeight);
    listScrollView.contentSize = CGSizeMake(gridViewWidth, listScrollView.frame.size.height);
    if (!gridView) {
        gridView = [[LJHLGridView alloc] init];
        gridView.isConsumption = YES;
        gridView.delegate = self;
        gridView.superVC = self;
        gridView.dataList = dataList;
        [listScrollView addSubview:gridView];
    }
    gridView.frame = CGRectMake(0, 0, gridViewWidth, listHeight);
    gridView.dataList = dataList;

    
    if (!rightBottomButton) {
        rightBottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backView addSubview:rightBottomButton];
        rightBottomButton.clipsToBounds = YES;
        [rightBottomButton setBackgroundImage:[LJColorImage imageWithColor:gray146] forState:UIControlStateSelected];
        
        [rightBottomButton setBackgroundImage:[LJColorImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        [rightBottomButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [rightBottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            if (kappScreenHeight - kTopScreenWidth - (50 + 3 * height + 10 + listHeight) > 110) {
                make.bottom.equalTo(self.view).offset(-30);
                make.left.equalTo(self.view).offset(30);
                make.right.equalTo(self.view).offset(-30);
                make.height.mas_equalTo(50);
            } else {
                make.top.equalTo(listScrollView.mas_bottom).offset(30);
                make.left.equalTo(self.view).offset(30);
                make.right.equalTo(self.view).offset(-30);
                make.height.mas_equalTo(50);
            }
        }];
        rightBottomButton.backgroundColor = LightBrownColor;
        [rightBottomButton setTitle:@"确定" forState:UIControlStateNormal];
        rightBottomButton.layer.cornerRadius = 25;
    }
    
    orderNumberLabel.text =[NSString stringWithFormat:@"单号:%@", [[self.dataDic objectForKey:@"receptionOrderHeadTab"]  objectForKey:@"orderCd"]];
    daysBoNumberLabel.text = [NSString stringWithFormat:@"当日波数:%@", [[self.dataDic objectForKey:@"receptionOrderHeadTab"]  objectForKey:@"customerTurnCd"]];
    personCountLbel.text = [NSString stringWithFormat:@"人数:%@", [[self.dataDic objectForKey:@"receptionOrderHeadTab"]  objectForKey:@"customerQty"]];
    
    firstReceptionView.nameLabel.text = [NSString stringWithFormat:@"接待员:%@",self.headerEntity.salemanName];
    firstReceptionView.numberLabel.text = [NSString stringWithFormat:@"编号:%@",self.headerEntity.salemanCd];
    firstReceptionView.dutyLabel.text = [NSString stringWithFormat:@"职务:%@",self.headerEntity.salemanPosition];
    firstReceptionView.timeLbael.text = [NSString stringWithFormat:@"接待时间:%@",self.headerEntity.createDate];
    
    
//    secondReceptionView.nameLabel.text = [NSString stringWithFormat:@"录入员:%@",self.headerEntity.createUserName];
//    secondReceptionView.numberLabel.text = [NSString stringWithFormat:@"编号:%@",self.headerEntity.createUser];
//    secondReceptionView.dutyLabel.text = [NSString stringWithFormat:@"职务:%@",self.headerEntity.createUserPosition];
//
//    secondReceptionView.timeLbael.text = [NSString stringWithFormat:@"录入时间:%@",self.headerEntity.createDate];
//    
//    
//    thirdReceptionView.nameLabel.text = [NSString stringWithFormat:@"变更员:%@",self.headerEntity.updateUserName];
//    thirdReceptionView.numberLabel.text = [NSString stringWithFormat:@"编号:%@",self.headerEntity.updateUser];
//    thirdReceptionView.dutyLabel.text = [NSString stringWithFormat:@"职务:%@",self.headerEntity.updateUserPosition];
//    
//    thirdReceptionView.timeLbael.text = [NSString stringWithFormat:@"变更时间:%@",self.headerEntity.updateDate];
    
    
    
    [self.view bringSubviewToFront:topView];
    
    rightMenuView = [[LJMenuView alloc] initWithFrame:CGRectMake(kappScreenWidth, kTopScreenWidth, kappScreenWidth, kappScreenHeight - kTopScreenWidth) isConsumption:YES];
    rightMenuView.delegate = self;
    listScrollView.contentSize = CGSizeMake(gridViewWidth, listScrollView.frame.size.height);
    [self.view addSubview:rightMenuView];
    
    myControl = [[UIControl alloc] init];
    myControl.frame = CGRectMake(0, 0, kappScreenWidth, kappScreenHeight);
    myControl.backgroundColor = [UIColor blackColor];
    myControl.alpha = 0.4;
    [myControl addTarget:self action:@selector(closePickView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myControl];
    myControl.hidden = YES;
    
    pickView = [[LJPickerView alloc] init];
    pickView.delegate = self;
    pickView.frame = CGRectMake(0, kappScreenHeight, kappScreenWidth, 260);
    [self.view addSubview:pickView];
    pickView.backgroundColor = WhiteColor;

    
    listScrollView.contentSize = CGSizeMake(gridViewWidth, listScrollView.frame.size.height);
}

//键盘控制
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}
- (void) keyboardWasShown:(NSNotification *) notif
{
    //    NSDictionary *info = [notif userInfo];
    //    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    //    CGSize keyboardSize = [value CGRectValue].size;
    //
    //    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    //    keyboardSizeHeight = keyboardSize.height;
    //    [UIView animateWithDuration:0.3 animations:^{
    //        backView.frame = CGRectMake(0.0f, 50-keyboardSizeHeight, self.view.frame.size.width, self.view.frame.size.height);
    //    }];
    
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
        backView.frame = CGRectMake(0.0f, -70, self.view.frame.size.width, backView.frame.size.height);
    }];
    //输入框位置动画加载
    //    [self begainMoveUpAnimation:keyboardhight];
    
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    keyboardSizeHeight = keyboardSize.height;
    [UIView animateWithDuration:0.1 animations:^{
        backView.frame = CGRectMake(0.0f, kTopScreenWidth, backView.frame.size.width, backView.frame.size.height);
    }];
    
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (backView.frame.size.height - keyboardSizeHeight);//键盘高度216 或者 253
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0) {
        //        backView.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [UIView commitAnimations];
}

- (void) buttonPressed:(UIButton *) sender {
    if (sender == rightBottomButton) {
//        确定
        if (sender.isSelected) {
            return;
        }
        [sender setSelected:YES];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
        [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
        NSMutableArray *arr = [NSMutableArray array];
        for (LJReceptionDetailModel *entity in self.dataList) {
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
            
            
            if (entity.orderCd.length) {
                [mutDic setValue:entity.orderCd forKey:@"orderCd"];
            }
            
            if (entity.customerCd.length) {
                [mutDic setValue:entity.customerCd forKey:@"customerCd"];
            }
            
            if (entity.projectCd.length) {
                [mutDic setValue:entity.projectCd forKey:@"projectCd"];
            }
            
            if (entity.detailNo.length) {
                [mutDic setValue:entity.detailNo forKey:@"detailNo"];
            }
            
            if (entity.sex.length) {
                [mutDic setValue:entity.sex forKey:@"sex"];
            }
            
//            if (entity.artificer1Cd.length) {
//                [mutDic setValue:entity.artificer1Cd forKey:@"artificer1Cd"];
//            }
//            if (entity.artificer1SelectType.length) {
//                [mutDic setValue:entity.artificer1SelectType forKey:@"artificer1SelectType"];
//            }
//            if (entity.artificer2Cd.length) {
//                [mutDic setValue:entity.artificer2Cd forKey:@"artificer2Cd"];
//            }
//            if (entity.artificer2SelectType.length) {
//                [mutDic setValue:entity.artificer2SelectType forKey:@"artificer2SelectType"];
//            }
//            if (entity.artificer3Cd.length) {
//                [mutDic setValue:entity.artificer3Cd forKey:@"artificer3Cd"];
//            }
//            if (entity.artificer3SelectType.length) {
//                [mutDic setValue:entity.artificer3SelectType forKey:@"artificer3SelectType"];
//            }
//            if (entity.artificer4Cd.length) {
//                [mutDic setValue:entity.artificer4Cd forKey:@"artificer4Cd"];
//            }
//            if (entity.artificer4SelectType.length) {
//                [mutDic setValue:entity.artificer4SelectType forKey:@"artificer4SelectType"];
//            }

            
            if (entity.projectNum.length) {
                [mutDic setValue:entity.projectNum forKey:@"projectNum"];
            }
            
//            if (entity.sofaNo1.length ) {
//                [mutDic setValue:entity.sofaNo1 forKey:@"sofaNo1"];
//            }
            
//            if (entity.roomCd.length) {
//                [mutDic setValue:entity.roomCd forKey:@"roomCd"];
//            }
            
//            if (entity.sofaNo.length) {
//                [mutDic setValue:entity.sofaNo forKey:@"sofaNo"];
//            }
            
            if (entity.serviceHeadcount.length) {
                [mutDic setValue:entity.serviceHeadcount forKey:@"serviceHeadcount"];
            }
            
            if (entity.salemanName.length) {
                [mutDic setValue:entity.salemanName forKey:@"salemanName"];
            }
            if (entity.salemanCd.length) {
                [mutDic setValue:entity.salemanCd forKey:@"salemanCd"];
            }
            
//            if (entity.starTime.length) {
//                [mutDic setValue:entity.starTime forKey:@"starTime"];
//            }
            
//            if (entity.price.length) {
//                [mutDic setValue:[NSNumber numberWithDouble:[entity.price doubleValue] * [entity.projectNum integerValue]] forKey:@"price"];
//            }
            
//            if (entity.projectStatus.length) {
//                [mutDic setValue:entity.projectStatus forKey:@"projectStatus"];
//            }
            
            [mutDic setValue:[userDefaults objectForKey:USERID] forKey:@"updateUser"];
            
            
            [arr addObject:mutDic];
        }
        [dic setValue:arr forKey:@"detailList"];
        
        NSLog(@"dic %@", dic);
        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] POST:XIAOFEIUPDATE parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", jsonString);
            DISMISS
            if (ISSUCCESS) {
                SHOWTEXTINWINDOW(@"保存成功", 1);
//                [self loadData];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                BADREQUEST
            }
            
            [sender setSelected:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [sender setSelected:NO];
        }];
        
    } else if (sender == leftBottomButton) {
        
    }
}

- (void) saveData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.headerEntity.orderCd forKey:@"orderCd"];
    [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
    NSMutableArray *arr = [NSMutableArray array];
    for (LJReceptionDetailModel *entity in self.dataList) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
        
        
        if (entity.orderCd.length) {
            [mutDic setValue:entity.orderCd forKey:@"orderCd"];
        }
        
        if (entity.customerCd.length) {
            [mutDic setValue:entity.customerCd forKey:@"customerCd"];
        }
        
        if (entity.projectCd.length) {
            [mutDic setValue:entity.projectCd forKey:@"projectCd"];
        }
        
        if (entity.detailNo.length) {
            [mutDic setValue:entity.detailNo forKey:@"detailNo"];
        }
        
        if (entity.sex.length) {
            [mutDic setValue:entity.sex forKey:@"sex"];
        }
        
//        if (entity.artificer1Cd.length) {
//            [mutDic setValue:entity.artificer1Cd forKey:@"artificer1Cd"];
//        }
//        if (entity.artificer1SelectType.length) {
//            [mutDic setValue:entity.artificer1SelectType forKey:@"artificer1SelectType"];
//        }
//        if (entity.artificer2Cd.length) {
//            [mutDic setValue:entity.artificer2Cd forKey:@"artificer2Cd"];
//        }
//        if (entity.artificer2SelectType.length) {
//            [mutDic setValue:entity.artificer2SelectType forKey:@"artificer2SelectType"];
//        }
//        if (entity.artificer3Cd.length) {
//            [mutDic setValue:entity.artificer3Cd forKey:@"artificer3Cd"];
//        }
//        if (entity.artificer3SelectType.length) {
//            [mutDic setValue:entity.artificer3SelectType forKey:@"artificer3SelectType"];
//        }
//        if (entity.artificer4Cd.length) {
//            [mutDic setValue:entity.artificer4Cd forKey:@"artificer4Cd"];
//        }
//        if (entity.artificer4SelectType.length) {
//            [mutDic setValue:entity.artificer4SelectType forKey:@"artificer4SelectType"];
//        }
        
//        if (entity.sofaNo1.length) {
//            [mutDic setValue:entity.sofaNo1 forKey:@"sofaNo1"];
//        }
        
        if (entity.projectNum.length) {
            [mutDic setValue:entity.projectNum forKey:@"projectNum"];
        }
        
//        if (entity.roomCd.length) {
//            [mutDic setValue:entity.roomCd forKey:@"roomCd"];
//        }
        
//        if (entity.sofaNo.length) {
//            [mutDic setValue:entity.sofaNo forKey:@"sofaNo"];
//        }
        
        if (entity.serviceHeadcount.length) {
            [mutDic setValue:entity.serviceHeadcount forKey:@"serviceHeadcount"];
        }
        
        //            if (entity.starTime.length) {
        //                [mutDic setValue:entity.starTime forKey:@"starTime"];
        //            }
        
//        if (entity.price.length) {
//            [mutDic setValue:[NSNumber numberWithDouble:[entity.price doubleValue] * [entity.projectNum integerValue]] forKey:@"price"];
//        }
        
//        if (entity.projectStatus.length) {
//            [mutDic setValue:entity.projectStatus forKey:@"projectStatus"];
//        }
        if (entity.salemanName.length) {
            [mutDic setValue:entity.salemanName forKey:@"salemanName"];
        }
        if (entity.salemanCd.length) {
            [mutDic setValue:entity.salemanCd forKey:@"salemanCd"];
        }
        [mutDic setValue:[userDefaults objectForKey:USERID] forKey:@"updateUser"];
        
        
        [arr addObject:mutDic];
    }
    [dic setValue:arr forKey:@"detailList"];
    
    NSLog(@"dic %@", dic);
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:XIAOFEIUPDATE parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
        DISMISS
        if (ISSUCCESS) {
            
        } else {
            BADREQUEST
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
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
