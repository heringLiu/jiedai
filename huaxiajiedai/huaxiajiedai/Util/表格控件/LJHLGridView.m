//
//  LJHLGridView.m
//  huaxiajiedai
//
//  Created by qm on 16/4/18.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJHLGridView.h"
#import "LJHLGridViewCollectionViewCell.h"
#import "LJProjectListViewController.h"

@interface LJHLGridView () <SelectRoomDelegate, SelectProjectDelegate>{
    NSArray *employeeTabs;
    NSArray *customTypeList;
    
    NSMutableArray *bianhaoArr;
    NSMutableArray *nameArr;
    NSMutableArray *typeArr;
}

@end

@implementation LJHLGridView
@synthesize myCollectionView, headerView, selectedEntity, superVC;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
       
    }
    
    return self;
}

- (void)setIsConsumption:(BOOL)isConsumption {
    [self loadData];
    _isConsumption = isConsumption;
    
    headerView = [[LJCollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50) isConsumpton:isConsumption isAll:self.isAll];
    [self addSubview:headerView];
    headerView.delegate = self;

    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //        flowLayout.itemSize = CGSizeMake(80, 50);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 设置最小行间距
    flowLayout.minimumLineSpacing = 0;
    // 设置垂直间距
    flowLayout.minimumInteritemSpacing = 0;
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
    
    [self addSubview:myCollectionView];
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    myCollectionView.backgroundColor = WhiteColor;
    
    
    [myCollectionView registerClass:[LJHLGridViewCollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
    [myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self).offset(50);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 50);
    btn.backgroundColor = [UIColor clearColor];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(buttonP:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.selectedAllBtn addTarget:self action:@selector(buttonP:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)selectedDone:(NSInteger)index {
    if (index < nameArr.count) {
        selectedEntity.salemanName = [[employeeTabs objectAtIndex:index] objectForKey:@"name"];
        selectedEntity.salemanCd = [[employeeTabs objectAtIndex:index] objectForKey:@"employeeId"];
        selectedEntity.salemanName = [[employeeTabs objectAtIndex:index] objectForKey:@"name"];
        [myCollectionView reloadData];
    }
    
}

- (void) loadData {
    NSString *url = SALESMANLIST;
    
    [[NetWorkingModel sharedInstance] GET:url parameters:@{@"storeCd":STORCDSTRING} success:^(AFHTTPRequestOperation *operation, id obj) {
        bianhaoArr = [NSMutableArray array];
        nameArr = [NSMutableArray array];
        typeArr = [NSMutableArray array];
        if (ISSUCCESS) {
            
            employeeTabs = [CONTENTOBJ objectForKey:@"empList"];
            customTypeList = [CONTENTOBJ objectForKey:@"customTypeList"];
            
            for (NSDictionary *dic in employeeTabs) {
                [bianhaoArr addObject:[dic objectForKey:@"employeeId"]];
                [nameArr addObject:[dic objectForKey:@"name"]];
            }
            
            for (NSDictionary *dic  in customTypeList) {
                [typeArr addObject:[dic objectForKey:@"charValue1"]];
            }
        } else {
//            BADREQUEST
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void) buttonP:(UIButton *) sender {
    [self selectedAll:headerView.selectedAllBtn];
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isConsumption) {
        if (self.isAll) {
            if (indexPath.row == 7 || indexPath.row == 4) {
                return CGSizeMake(100, 50);
            } else if (indexPath.row == 9 || indexPath.row == 5 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 || indexPath.row == 13 || indexPath.row == 2) {
                return CGSizeMake(80, 50);
            } else if (indexPath.row == 1) {
                return CGSizeMake(160, 50);
            }
        } else {
            if (indexPath.row == 6 || indexPath.row == 3) {
                return CGSizeMake(100, 50);
            } else if (indexPath.row == 8 || indexPath.row == 4 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 || indexPath.row == 1) {
                return CGSizeMake(80, 50);
            }
        }
       
        return CGSizeMake(60, 50);
    } else {
        if (indexPath.row == 3) {
            return CGSizeMake(100, 50);
        } else if (indexPath.row == 8 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 1 || indexPath.row == 6) {
            return CGSizeMake(80, 50);
        }
        return CGSizeMake(60, 50);
    }
    
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isConsumption) {
        if (self.isAll) {
            return 14;
        } else {
            return 13;
        }
    }
    return 9;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return self.dataList.count + 1;
    return self.dataList.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJHLGridViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];

    cell.backgroundColor = WhiteColor;
    
    UIView *aView = [cell viewWithTag:9004];
    if (aView) {
        [aView removeFromSuperview];
    }
    
    LJReceptionDetailModel *entity = [self.dataList objectAtIndex:indexPath.section];
    LJReceptionDetailModel * lastEntity;
    if (indexPath.section > 0) {
        lastEntity = [self.dataList objectAtIndex:indexPath.section - 1];
    }
    
    if (indexPath.section %2 == 0) {
        cell.leftView.alpha = 1;
        cell.cornerImage.alpha = 1;
    } else {
        cell.leftView.alpha = 0.6;
        cell.cornerImage.alpha = 0.6;
    }
    if (self.isConsumption) {
        if (self.isAll) {
            // 全消费订单
            if (indexPath.row == 0) {
    //            复选框
                [cell isShowButton:YES];
                [cell.selectedBtn setSelected:entity.isSelected];
                cell.cornerImage.hidden = YES;
                
            } else if (indexPath.row == 2) {
    //            客人编号
                [cell setCellWithTitle:entity.customerCd];
                cell.cornerImage.hidden = YES;
                [cell isShowButton:NO];
                
                if (lastEntity) {
                    if ([lastEntity.customerCd isEqualToString:entity.customerCd]) {
                        cell.titleLabel.hidden = YES;
                    }
                }
                
            } else if (indexPath.row == 3) {
    //            性别
                if ([entity.sex isEqualToString:@"man"]) {
                    [cell setCellWithTitle:@"男"];
                } else if ([entity.sex isEqualToString:@"woman"]) {
                    [cell setCellWithTitle:@"女"];
                }  else {
                    [cell setCellWithTitle:@""];
                }
                
                cell.cornerImage.hidden = NO;
                [cell isShowButton:NO];
                
                if (lastEntity) {
                    if ([lastEntity.customerCd isEqualToString:entity.customerCd]) {
                        cell.titleLabel.hidden = YES;
                    }
                }
                
                cell.backgroundColor = gray250;
            } else if (indexPath.row == 6) {
    //            沙发号
                [cell isShowButton:NO];
                [cell setCellWithTitle:entity.sofaNo];
                cell.cornerImage.hidden = YES;
            } else if (indexPath.row == 4) {
    //            项目名称
                [cell isShowButton:NO];
                [cell setCellWithTitle:entity.projectName];
                cell.cornerImage.hidden = NO;
                
            } else if (indexPath.row == 5) {
    //            技师  2.0.7 修改为跑马灯效果。
                
                if (entity.artificerList.count) {
                    NSString *str = @"";
                    for (int i = 0;i < entity.artificerList.count; i++) {
                        NSDictionary *dic = [entity.artificerList objectAtIndex:i];
                        if(i == entity.artificerList.count -1) {
                            if([[dic objectForKey:@"selectType"] isEqual:@"callTime"]) {
                                str = [NSString stringWithFormat:@"%@ %@ (%@)", str, [dic objectForKey:@"artificerName"], [dic objectForKey:@"artificerCd"]];
                            } else {
                                str = [NSString stringWithFormat:@"%@ %@ %@", str, [dic objectForKey:@"artificerName"], [dic objectForKey:@"artificerCd"]];
                            }
                        } else {
                            if([[dic objectForKey:@"selectType"] isEqual:@"callTime"]) {
                                str = [NSString stringWithFormat:@"%@ %@ (%@)，", str, [dic objectForKey:@"artificerName"], [dic objectForKey:@"artificerCd"]];
                            } else {
                                str = [NSString stringWithFormat:@"%@ %@ %@，", str, [dic objectForKey:@"artificerName"], [dic objectForKey:@"artificerCd"]];
                            }
                        }
                        
                    }
                    [cell setCellWithTitle:@""];
                    cell.clipsToBounds = YES;
    //                cell.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //                cell.titleLabel.numberOfLines = 0;
    //                [cell.titleLabel sizeToFit];
                    UILabel *label = [[UILabel alloc] init];
                    [cell addSubview:label];
                    
                    label.tag = 9004;
                    [label setText:str];
                    [label sizeToFit];
                    CGRect frame = label.frame;
                    frame.origin.x = cell.bounds.size.width;
                    frame.size.height = cell.bounds.size.height;
                    label.frame = frame;
                    [UIView beginAnimations:@"scrollLabelTest" context:NULL];
                    [UIView setAnimationDuration:3.0f];
                    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationRepeatAutoreverses:NO];
                    [UIView setAnimationRepeatCount:100];
                    frame = label.frame;
                    frame.origin.x = -frame.size.width;
                    label.frame = frame;
                    [UIView commitAnimations];
                    
                } else {
                    [cell setCellWithTitle:@""];
                }
                cell.backgroundColor = gray250;
                cell.cornerImage.hidden = NO;
            } else if (indexPath.row == 7) {
                // 房间
                [cell setCellWithTitle:[NSString stringWithFormat:@"%@(%@)", entity.roomName, entity.roomCd]];
                cell.cornerImage.hidden = NO;
                cell.backgroundColor = gray250;
            } else if (indexPath.row == 8) {
                // 数量
                [cell setCellWithTitle:entity.projectNum];
                cell.cornerImage.hidden = YES;
            } else if (indexPath.row == 9) {
    //            金额
                NSString *str = @"";
                if ([entity.projectNum integerValue] > 0) {
                    str = [NSString stringWithFormat:@"%.2f", [entity.projectNum integerValue] * [entity.price doubleValue]];
                }
    //            entity.price = str;
                [cell setCellWithTitle:str];
                cell.cornerImage.hidden = YES;
                cell.backgroundColor = gray250;
            } else if (indexPath.row == 10) {
    //            项目状态
                if ([entity.projectStatus isEqualToString:@"addtime"]) {
                    [cell setCellWithTitle:@"加钟"];
                } else if ([entity.projectStatus isEqualToString:@"normal"]) {
                    [cell setCellWithTitle:@"正常"];
                }  else if ([entity.projectStatus isEqualToString:@"onClock"]) {
                    [cell setCellWithTitle:@"上钟"];
                }  else if ([entity.projectStatus isEqualToString:@"downClock"]) {
                    [cell setCellWithTitle:@"下钟"];
                } else {
                    [cell setCellWithTitle:@""];
                }
                cell.cornerImage.hidden = YES;
            } else if (indexPath.row == 11) {
    //            服务状态
                NSString *str = @"";
                if ([entity.serveStatus isEqualToString:@"overdue"]) {
                    str = @"未到";
                } else if ([entity.serveStatus isEqualToString:@"uptime"]) {
                    str = @"上钟";
                } else if ([entity.serveStatus isEqualToString:@"suspend"]) {
                    str = @"暂停";
                } else if ([entity.serveStatus isEqualToString:@"wait"]) {
                    str = @"等待";
                } else if ([entity.serveStatus isEqualToString:@"downtime"]) {
                    str = @"下钟";
                }
                [cell setCellWithTitle:str];
                cell.backgroundColor = gray250;
                cell.cornerImage.hidden = YES;
            } else if (indexPath.row == 12) {
    //            结算状态
                NSString *str = @"";
                if ([entity.settlementStatus isEqualToString:@"appointment"]) {
                    str = @"预结";
                } else if ([entity.settlementStatus isEqualToString:@"Unsettlement"]) {
                    str = @"未结";
                } else if ([entity.settlementStatus isEqualToString:@"abandon"]) {
                    str = @"预结废弃";
                } else if ([entity.settlementStatus isEqualToString:@"settleing"]) {
                    str = @"结算中";
                }
                [cell setCellWithTitle:str];
                cell.cornerImage.hidden = YES;
            } else if (indexPath.row == 13) {
    //            推销员
                [cell setCellWithTitle:entity.salemanName];
                cell.cornerImage.hidden = YES;
                cell.backgroundColor = gray250;
            } else if (indexPath.row == 1) {
                // 订单编号
                [cell setCellWithTitle:entity.orderCd];
                cell.cornerImage.hidden = YES;
                cell.backgroundColor = gray250;
            }
        } else {
            // 旧消费订单
            if (indexPath.row == 0) {
    //            复选框
                [cell isShowButton:YES];
                [cell.selectedBtn setSelected:entity.isSelected];
                cell.cornerImage.hidden = YES;
                
            } else if (indexPath.row == 1) {
    //            客人编号
                [cell setCellWithTitle:entity.customerCd];
                cell.cornerImage.hidden = YES;
                [cell isShowButton:NO];
                
                if (lastEntity) {
                    if ([lastEntity.customerCd isEqualToString:entity.customerCd]) {
                        cell.titleLabel.hidden = YES;
                    }
                }
                
            } else if (indexPath.row == 2) {
    //            性别
                if ([entity.sex isEqualToString:@"man"]) {
                    [cell setCellWithTitle:@"男"];
                } else if ([entity.sex isEqualToString:@"woman"]) {
                    [cell setCellWithTitle:@"女"];
                }  else {
                    [cell setCellWithTitle:@""];
                }
                
                cell.cornerImage.hidden = NO;
                [cell isShowButton:NO];
                
                if (lastEntity) {
                    if ([lastEntity.customerCd isEqualToString:entity.customerCd]) {
                        cell.titleLabel.hidden = YES;
                    }
                }
                
                cell.backgroundColor = gray250;
            } else if (indexPath.row == 5) {
    //            沙发号
                [cell isShowButton:NO];
                [cell setCellWithTitle:entity.sofaNo];
                cell.cornerImage.hidden = YES;
            } else if (indexPath.row == 3) {
    //            项目名称
                [cell isShowButton:NO];
                [cell setCellWithTitle:entity.projectName];
                cell.cornerImage.hidden = NO;
                
            } else if (indexPath.row == 4) {
    //            技师  2.0.7 修改为跑马灯效果。
                
                if (entity.artificerList.count) {
                    NSString *str = @"";
                    for (int i = 0;i < entity.artificerList.count; i++) {
                        NSDictionary *dic = [entity.artificerList objectAtIndex:i];
                        if(i == entity.artificerList.count -1) {
                            if([[dic objectForKey:@"selectType"] isEqual:@"callTime"]) {
                                str = [NSString stringWithFormat:@"%@ %@ (%@)", str, [dic objectForKey:@"artificerName"], [dic objectForKey:@"artificerCd"]];
                            } else {
                                str = [NSString stringWithFormat:@"%@ %@ %@", str, [dic objectForKey:@"artificerName"], [dic objectForKey:@"artificerCd"]];
                            }
                        } else {
                            if([[dic objectForKey:@"selectType"] isEqual:@"callTime"]) {
                                str = [NSString stringWithFormat:@"%@ %@ (%@)，", str, [dic objectForKey:@"artificerName"], [dic objectForKey:@"artificerCd"]];
                            } else {
                                str = [NSString stringWithFormat:@"%@ %@ %@，", str, [dic objectForKey:@"artificerName"], [dic objectForKey:@"artificerCd"]];
                            }
                        }
                        
                    }
                    [cell setCellWithTitle:@""];
                    cell.clipsToBounds = YES;
    //                cell.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //                cell.titleLabel.numberOfLines = 0;
    //                [cell.titleLabel sizeToFit];
                    UILabel *label = [[UILabel alloc] init];
                    [cell addSubview:label];
                    
                    label.tag = 9004;
                    [label setText:str];
                    [label sizeToFit];
                    CGRect frame = label.frame;
                    frame.origin.x = cell.bounds.size.width;
                    frame.size.height = cell.bounds.size.height;
                    label.frame = frame;
                    [UIView beginAnimations:@"scrollLabelTest" context:NULL];
                    [UIView setAnimationDuration:3.0f];
                    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationRepeatAutoreverses:NO];
                    [UIView setAnimationRepeatCount:100];
                    frame = label.frame;
                    frame.origin.x = -frame.size.width;
                    label.frame = frame;
                    [UIView commitAnimations];
                    
                } else {
                    [cell setCellWithTitle:@""];
                }
                cell.backgroundColor = gray250;
                cell.cornerImage.hidden = NO;
            } else if (indexPath.row == 6) {
                // 房间
                [cell setCellWithTitle:[NSString stringWithFormat:@"%@(%@)", entity.roomName, entity.roomCd]];
                cell.cornerImage.hidden = NO;
                cell.backgroundColor = gray250;
            } else if (indexPath.row == 7) {
                // 数量
                [cell setCellWithTitle:entity.projectNum];
                cell.cornerImage.hidden = YES;
            } else if (indexPath.row == 8) {
    //            金额
                NSString *str = @"";
                if ([entity.projectNum integerValue] > 0) {
                    str = [NSString stringWithFormat:@"%.2f", [entity.projectNum integerValue] * [entity.price doubleValue]];
                }
    //            entity.price = str;
                [cell setCellWithTitle:str];
                cell.cornerImage.hidden = YES;
                cell.backgroundColor = gray250;
            } else if (indexPath.row == 9) {
    //            项目状态
                if ([entity.projectStatus isEqualToString:@"addtime"]) {
                    [cell setCellWithTitle:@"加钟"];
                } else if ([entity.projectStatus isEqualToString:@"normal"]) {
                    [cell setCellWithTitle:@"正常"];
                }  else if ([entity.projectStatus isEqualToString:@"onClock"]) {
                    [cell setCellWithTitle:@"上钟"];
                }  else if ([entity.projectStatus isEqualToString:@"downClock"]) {
                    [cell setCellWithTitle:@"下钟"];
                } else {
                    [cell setCellWithTitle:@""];
                }
                cell.cornerImage.hidden = YES;
            } else if (indexPath.row == 10) {
    //            服务状态
                NSString *str = @"";
                if ([entity.serveStatus isEqualToString:@"overdue"]) {
                    str = @"未到";
                } else if ([entity.serveStatus isEqualToString:@"uptime"]) {
                    str = @"上钟";
                } else if ([entity.serveStatus isEqualToString:@"suspend"]) {
                    str = @"暂停";
                } else if ([entity.serveStatus isEqualToString:@"wait"]) {
                    str = @"等待";
                } else if ([entity.serveStatus isEqualToString:@"downtime"]) {
                    str = @"下钟";
                }
                [cell setCellWithTitle:str];
                cell.backgroundColor = gray250;
                cell.cornerImage.hidden = YES;
            } else if (indexPath.row == 11) {
    //            结算状态
                NSString *str = @"";
                if ([entity.settlementStatus isEqualToString:@"appointment"]) {
                    str = @"预结";
                } else if ([entity.settlementStatus isEqualToString:@"Unsettlement"]) {
                    str = @"未结";
                } else if ([entity.settlementStatus isEqualToString:@"abandon"]) {
                    str = @"预结废弃";
                } else if ([entity.settlementStatus isEqualToString:@"settleing"]) {
                    str = @"结算中";
                }
                [cell setCellWithTitle:str];
                cell.cornerImage.hidden = YES;
            } else if (indexPath.row == 12) {
    //            推销员
                [cell setCellWithTitle:entity.salemanName];
                cell.cornerImage.hidden = YES;
                cell.backgroundColor = gray250;
            }
        }
//        消费单
        
    } else {
//        接待单
        if (indexPath.row == 0) {
            
            [cell isShowButton:YES];
            [cell.selectedBtn setSelected:entity.isSelected];
            cell.cornerImage.hidden = YES;
            
        } else if (indexPath.row == 1) {
            [cell setCellWithTitle:entity.customerCd];
            cell.cornerImage.hidden = YES;
            [cell isShowButton:NO];
            
            if (lastEntity) {
                if ([lastEntity.customerCd isEqualToString:entity.customerCd]) {
                    cell.titleLabel.hidden = YES;
                }
            }
            
        } else if (indexPath.row == 2) {
            if ([entity.sex isEqualToString:@"man"]) {
                [cell setCellWithTitle:@"男"];
            } else if ([entity.sex isEqualToString:@"woman"]) {
                [cell setCellWithTitle:@"女"];
            }  else {
                [cell setCellWithTitle:@""];
            }
            cell.cornerImage.hidden = NO;
            [cell isShowButton:NO];
            
            if (lastEntity) {
                if ([lastEntity.customerCd isEqualToString:entity.customerCd]) {
                    cell.titleLabel.hidden = YES;
                }
            }
            
            cell.backgroundColor = gray250;
        } else if (indexPath.row == 3) {
            [cell isShowButton:NO];
            [cell setCellWithTitle:entity.projectName];
            cell.cornerImage.hidden = YES;
           
        } else if (indexPath.row == 4) {
            if (entity.artificer1Cd.length) {
                NSString *str = @"";
                if (entity.artificer1Cd.length) {
                    if ([entity.artificer1SelectType isEqualToString:@"wheelTime"]) {
                        //                        轮钟
                        str = [NSString stringWithFormat:@"%@", entity.artificer1Cd];
                    } else {
                        //                        点钟
                        str = [NSString stringWithFormat:@"(%@)", entity.artificer1Cd];
                    }
                    
                    if (entity.artificer2Cd.length) {
                        if ([entity.artificer2SelectType isEqualToString:@"wheelTime"]) {
                            //                        轮钟
                            str = [NSString stringWithFormat:@"%@、%@", str, entity.artificer2Cd];
                        } else {
                            //                        点钟
                            str = [NSString stringWithFormat:@"%@、(%@)", str, entity.artificer2Cd];
                        }
                        
                        if (entity.artificer3Cd.length) {
                            if ([entity.artificer3SelectType isEqualToString:@"wheelTime"]) {
                                //                        轮钟
                                str = [NSString stringWithFormat:@"%@、%@", str, entity.artificer3Cd];
                            } else {
                                //                        点钟
                                str = [NSString stringWithFormat:@"%@、(%@)", str, entity.artificer3Cd];
                            }
                            
                            if (entity.artificer4Cd.length) {
                                if ([entity.artificer4SelectType isEqualToString:@"wheelTime"]) {
                                    //                        轮钟
                                    str = [NSString stringWithFormat:@"%@、%@", str, entity.artificer4Cd];
                                } else {
                                    //                        点钟
                                    str = [NSString stringWithFormat:@"%@、(%@)", str, entity.artificer4Cd];
                                }
                            }
                        }
                    }
                }
                [cell setCellWithTitle:str];
            } else {
                [cell setCellWithTitle:@""];
            }
            cell.backgroundColor = gray250;
            cell.cornerImage.hidden = NO;
        } else if (indexPath.row == 5) {
            [cell setCellWithTitle:entity.projectNum];
            cell.cornerImage.hidden = YES;
        } else if (indexPath.row == 6) {
            NSString *str = @"";
            if ([entity.projectNum integerValue] > 0) {
                str = [NSString stringWithFormat:@"%.2f", [entity.projectNum integerValue] * [entity.price doubleValue]];
            }
//            entity.price = str;
            [cell setCellWithTitle:str];
            cell.cornerImage.hidden = YES;
            cell.backgroundColor = gray250;
        } else if (indexPath.row == 7) {
            if ([entity.projectStatus isEqualToString:@"addtime"]) {
                [cell setCellWithTitle:@"加钟"];
            } else if ([entity.projectStatus isEqualToString:@"normal"]) {
                [cell setCellWithTitle:@"正常"];
            }  else if ([entity.projectStatus isEqualToString:@"onClock"]) {
                [cell setCellWithTitle:@"上钟"];
            }  else if ([entity.projectStatus isEqualToString:@"downClock"]) {
                [cell setCellWithTitle:@"下钟"];
            } else {
                [cell setCellWithTitle:@""];
            }
            
            cell.cornerImage.hidden = YES;
 
        } else if (indexPath.row == 8) {
            [cell setCellWithTitle:entity.salemanName];
            cell.cornerImage.hidden = YES;
//            NSString *str = @"";
//            if ([entity.settlementStatus isEqualToString:@"appointment"]) {
//                str = @"预结";
//            } else if ([entity.settlementStatus isEqualToString:@"Unsettlement"]) {
//                str = @"未结";
//            } else if ([entity.settlementStatus isEqualToString:@"abandon"]) {
//                str = @"预结废弃";
//            }
//            [cell setCellWithTitle:str];
//            cell.backgroundColor = gray250;
//            cell.cornerImage.hidden = YES;
        } else if (indexPath.row == 9) {
            [cell setCellWithTitle:entity.salemanName];
            cell.cornerImage.hidden = YES;
        }
    }
    
    cell.isConsumption = self.isConsumption;
    
    return cell;
 
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    SHOWSTATUSCLEAR
    selectedEntity = [self.dataList objectAtIndex:indexPath.section];
    LJHLGridViewCollectionViewCell *cell = (LJHLGridViewCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        //            选中
        LJReceptionDetailModel *entity = [self.dataList objectAtIndex:indexPath.section];
        entity.isSelected = !entity.isSelected;
        
        NSInteger selCount = 0;
        NSInteger unSelCount = 0;
        for (LJReceptionDetailModel *model in self.dataList) {
            if (model.isSelected) {
                selCount ++;
            } else {
                unSelCount ++;
            }
        }
        
        if (selCount == 0) {
            [headerView.selectedAllBtn setSelected:NO];
        } else if (unSelCount == 0) {
            [headerView.selectedAllBtn setSelected:YES];
        }
        
        
        [myCollectionView reloadData];
    }
    if (self.isConsumption) {
        if (self.isAll) {
            // 全消费订单
            self.myIndexPath = indexPath;
            if (indexPath.row == 11) {
                // 服务状态
                if ([selectedEntity.serveStatus isEqualToString:@"nothing"]) {
                    DISMISS
                    return;
                }
                
                if ([selectedEntity.serveStatus isEqualToString:@"overdue"] || [selectedEntity.serveStatus isEqualToString:@"uptime"]) {
    //                起钟落钟
                    NSString *str = @"技师编号：";
                    if (selectedEntity.artificerList.count) {
                        for (int i = 0; i < selectedEntity.artificerList.count; i++) {
                            NSDictionary *dic = [selectedEntity.artificerList objectAtIndex:i];
                            NSString *jishi = [dic objectForKey:@"artificerCd"];
                            if(i == selectedEntity.artificerList.count -1) {
                                // 最后一位，不加逗号
                                if ([[dic objectForKey:@"selectType"] isEqual:@"wheelTime"]){
                                    // 轮钟技师
                                    str = [NSString stringWithFormat:@"%@(%@)", str, jishi];
                                }else {
                                    // 点钟技师
                                    str = [NSString stringWithFormat:@"%@%@", str, jishi];
                                }
                            } else {
                                if ([[dic objectForKey:@"selectType"] isEqual:@"wheelTime"]){
                                    // 轮钟技师
                                    str = [NSString stringWithFormat:@"%@(%@),", str, jishi];
                                }else {
                                    // 点钟技师
                                    str = [NSString stringWithFormat:@"%@%@,", str, jishi];
                                }
                            }
                        }
                    }
                    str = [NSString stringWithFormat:@"%@\n项目时长：%@分钟", str, selectedEntity.projectTime];
                    NSString *cdStr = [NSString stringWithFormat:@"%@", selectedEntity.artificer1Cd];
                    if (selectedEntity.artificer2Cd.length) {
                        cdStr = [NSString stringWithFormat:@"%@、", selectedEntity.artificer2Cd];
                    }
                    DISMISS
                    
    //                UIAlertController *alterController = [[UIAlertController alloc] init];
    //
    //                [alterController setTitle:@"技师状态"];
    //                [alterController setMessage:@"aaa\n bbb/n"];
                    
                    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"技师状态" message:str preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"起钟" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self startEndTime:@"start"];
                        
                    }];
                    [alterController addAction:startAction];
                    
                    UIAlertAction *endAction = [UIAlertAction actionWithTitle:@"落钟" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self startEndTime:@"end"];
                    }];
                    [alterController addAction:endAction];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alterController addAction:cancelAction];
                    UIViewController *viewController = nil;
                    for(UIView* next = [self superview]; next; next = next.superview) {

                        UIResponder*nextResponder = [next nextResponder];

                        if ([nextResponder isKindOfClass:[UIViewController class]]) {

                            viewController = (UIViewController *)nextResponder;

                        }
                    }
                    if (viewController) {
                        [viewController presentViewController:alterController animated:YES completion:^{
                            
                        }];
                    }
                    
                    
                    
    //                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"技师状态" message:[NSString stringWithFormat:@"技师编号:%@\n项目时长:%@分钟", cdStr, selectedEntity.projectTime] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:str, nil];
    //                av.tag = 2002;
    //                [av show];
                } else {
    //                查看等待信息和技师信息
                    DISMISS
                    LJProjectListViewController *next = [[LJProjectListViewController alloc] init];
                    next.entity = selectedEntity;
                    
                    [self.superVC.navigationController pushViewController:next animated:YES];
                }
            } else if (indexPath.row == 6) {
                //        沙发、落钟沙发不可以选择
                if ([selectedEntity.serveStatus isEqualToString:@"downtime"]) {
                    DISMISS
                    return;
                }
                
    //            有项目正在上钟或者暂停 但不是该条项目
                for (LJReceptionDetailModel *entity in self.dataList) {
                    if (([entity.serveStatus isEqualToString:@"uptime"] || [entity.serveStatus isEqualToString:@"suspend"]) && entity != selectedEntity && [entity.customerCd isEqualToString:selectedEntity.customerCd]) {
                        DISMISS
                        return;
                    }
                }
                
                
                //             商品不能选择
                if (selectedEntity.qtyUpdateFlg) {
                    DISMISS
                    return;
                }
                
                LJSofaListViewController *sofaListViewController = [[LJSofaListViewController alloc] init];
                sofaListViewController.roomCd = selectedEntity.roomCd;
                sofaListViewController.selectedEntity = [[SofaModel alloc] init];
                sofaListViewController.selectedEntity.roomCd = selectedEntity.roomCd;
                sofaListViewController.selectedEntity.sofaNo = selectedEntity.sofaNo;
                sofaListViewController.isConsumption = self.isConsumption;
                sofaListViewController.delegate = self;
        
                [superVC.navigationController pushViewController:sofaListViewController animated:YES];
            } else if (indexPath.row == 4) {
                //        修改项目
                if ([selectedEntity.serveStatus isEqualToString:@"downtime"] || [selectedEntity.serveStatus isEqualToString:@"uptime"]) {
                    DISMISS
                    SHOWTEXTINWINDOW(@"上钟、落钟明细不能修改项目", 1);
                    return;
                }
                if (([selectedEntity.settlementStatus isEqualToString:@"appointment"] || [selectedEntity.settlementStatus isEqualToString:@"settleing"]) && selectedEntity.boxCd.length ==0) {
                    // 除扫盒项目外，预结和结算中的项目不允许修改
                    DISMISS
                    SHOWTEXTINWINDOW(@"项目处于预结或结算中状态", 1);
                    return;
                }
                //             商品不能选择项目
                LJSelectedProjectViewController *next = [[LJSelectedProjectViewController alloc] init];
                
                next.detailEntity = selectedEntity;
                if (selectedEntity.artificer1Cd.length) {
                    next.artificerCd = selectedEntity.artificer1Cd;
                } else if (selectedEntity.artificer2Cd.length) {
                    next.artificerCd = selectedEntity.artificer2Cd;
                }
                next.isConsumption = self.isConsumption;
                next.delegate = self;
                next.navColor = NavBackColor;
                if (selectedEntity.projectName.length) {
                    next.titleString = @"修改消费项目";
                } else {
                    next.titleString = @"选择消费项目";
                }
                
                next.view.backgroundColor = WhiteColor;
                
                [superVC.navigationController pushViewController:next animated:YES];
            } else if (indexPath.row == 5) {
                DISMISS
    //            选择技师
                
                SHOWSTATUSCLEAR
                [[NetWorkingModel sharedInstance] GET:testSelectJishi parameters:@{@"userId":[userDefaults objectForKey:USERID]} success:^(AFHTTPRequestOperation *operation, id obj) {
                    DISMISS
                    if (ISSUCCESS) {
                        if ([CONTENTOBJ boolValue]) {
                
                            if ([selectedEntity.serviceHeadcount longLongValue] > 1) {

                            }
                            
                            
                            
                            //        技师
                            // 技师下钟 不可选  技师上钟的不能选
                            if ([selectedEntity.serveStatus isEqualToString:@"downtime"] || [selectedEntity.serveStatus isEqualToString:@"uptime"]) {
                                SHOWTEXTINWINDOW(@"上钟或下钟明细不能修改技师", 1);
                                return;
                            }
                            
                            if (!selectedEntity.projectName.length) {
                                SHOWTEXTINWINDOW(@"项目不能为空", 1);
                                return;
                            }
                            //             商品不能选择技师
                            if (selectedEntity.qtyUpdateFlg) {
                                DISMISS
                                return;
                            }
                            
                            LJReceptionDetailModel *model = nil;
                            //            当前客户选择技师的时候判断  当前用户是否存在上钟的技师
                            for (LJReceptionDetailModel *entity in self.dataList) {
                                if ([entity.customerCd isEqualToString:selectedEntity.customerCd] && (entity.artificer1Cd.length || entity.artificer2Cd.length) && ([entity.serveStatus isEqualToString:@"uptime"] || [entity.serveStatus isEqualToString:@"suspend"]) && ![entity.detailNo isEqualToString:selectedEntity.detailNo]) {
                                    // 点钟  技师cd 非落钟项目有技师 并且该记录不是点击的这一条的记录  选择技师时  就只能选择该技师
                                    model = entity;
                                }
                            }
                            
                            
                            LJSelectTechnicianViewController *next = [[LJSelectTechnicianViewController alloc] init];
                            next.artRecModel = model;
                            
                            next.canLunFlag = YES;
                            if (![selectedEntity.serveStatus isEqualToString:@"suspend"]) {
                                for (LJReceptionDetailModel *entity in self.dataList) {
                                    if ([entity.customerCd isEqualToString:selectedEntity.customerCd] && ([entity.serveStatus isEqualToString:@"overdue"] || [entity.serveStatus isEqualToString:@"suspend"] || [entity.serveStatus isEqualToString:@"uptime"] || [entity.serveStatus isEqualToString:@"wait"]) && ![entity.detailNo isEqualToString:selectedEntity.detailNo]) {
                                        next.canLunFlag = NO;
                                        break;
                                    }
                                }
                            }
                            
                            next.canSelectNotFree = YES;
                            for (LJReceptionDetailModel *entity in self.dataList) {
                                if ([entity.customerCd isEqualToString:selectedEntity.customerCd] && ![entity.serveStatus isEqualToString:@"downtime"] && [entity.serviceHeadcount integerValue] > 1 && ![entity.detailNo isEqualToString:selectedEntity.detailNo]) {
                                    next.canSelectNotFree = NO;
                                    next.doubleEntity = entity;
                                    break;
                                }
                            }
                            next.detailEntity = selectedEntity;
                            next.projectCd = selectedEntity.projectCd;
                            next.artificer1Cd = selectedEntity.artificer1Cd;
                            next.artificer1SelectType = selectedEntity.artificer1SelectType;
                            
                            next.artificer2Cd = selectedEntity.artificer2Cd;
                            next.artificer2SelectType = selectedEntity.artificer2SelectType;
                            
                            next.artificer3Cd = selectedEntity.artificer3Cd;
                            next.artificer3SelectType = selectedEntity.artificer3SelectType;
                            
                            next.artificer4Cd = selectedEntity.artificer4Cd;
                            next.artificer4SelectType = selectedEntity.artificer4SelectType;
                            
                            next.technicianCount = [selectedEntity.serviceHeadcount integerValue];
                            next.isConsumption = self.isConsumption;
                            next.delegate = self;
                            next.navColor = NavBackColor;
                            if (selectedEntity.artificer1Cd.length>0) {
                                next.titleString = @"更换技师";
                            } else {
                                next.titleString = @"选择技师";
                            }
                            
                            next.view.backgroundColor = WhiteColor;
                            
                            [superVC.navigationController pushViewController:next animated:YES];
                        } else {
                            SHOWTEXTINWINDOW(@"没有权限", 1);
                        }
                    } else {
                        BADREQUEST
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                
                
            } else if (indexPath.row == 7) {
                DISMISS
                return;
                //        房间
                if ([selectedEntity.serveStatus isEqualToString:@"downtime"]) {
                    DISMISS
                    return;
                }
                //             商品不能选择
                if (selectedEntity.qtyUpdateFlg) {
                    DISMISS
                    return;
                }
                
                
                LJSelectRoomViewController *next = [[LJSelectRoomViewController alloc] init];
                next.delegate = self;
                next.isConsumption = self.isConsumption;
                next.navColor = NavBackColor;
                next.titleString = @"选择房间";
                next.view.backgroundColor = WhiteColor;
                
                [superVC.navigationController pushViewController:next animated:YES];
            } else if (indexPath.row == 8) {
                //        需要判断是否可以更改数量
                if (selectedEntity.qtyUpdateFlg) {
                    cell.titleLabel.hidden = YES;
                    UITextField *numberTf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
                    [cell addSubview:numberTf];
                    numberTf.tag = 1111;
                    numberTf.delegate = self;
                    numberTf.textAlignment = NSTextAlignmentCenter;
                    numberTf.keyboardType = UIKeyboardTypeNumberPad;
                    
                    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [doneButton setBackgroundColor:[UIColor grayColor]];
                    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
                    [doneButton addTarget:self action:@selector(closeKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
                    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, 40)];
                    [inputView setBackgroundColor:[UIColor grayColor]];
                    [inputView addSubview:doneButton];
                    
                    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(inputView);
                        make.right.equalTo(inputView).with.offset(-kappScreenWidth*(34/744));
                        make.size.mas_equalTo(CGSizeMake(40, 30));
                    }];
                    
                    
                    numberTf.inputAccessoryView = inputView;
                    
                    
                    [numberTf becomeFirstResponder];
                }
                
            } else if (indexPath.row == 13) {
                // 选择推销员
                DISMISS
                return;
                if (nameArr.count) {
                    if ([self.delegate respondsToSelector:@selector(showPickViewWithData:)]) {
                        [self.delegate showPickViewWithData:nameArr];
                        
                    }
                    
                }
            }  else if (indexPath.row == 3) {
                
                if (!cell.titleLabel.isHidden) {
                    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
                    [as showInView:self.superview];
                }
                
                
            }
            
        } else {
            //消费单
            self.myIndexPath = indexPath;
            if (indexPath.row == 10) {
                // 服务状态
                if ([selectedEntity.serveStatus isEqualToString:@"nothing"]) {
                    DISMISS
                    return;
                }
                
                if ([selectedEntity.serveStatus isEqualToString:@"overdue"] || [selectedEntity.serveStatus isEqualToString:@"uptime"]) {
    //                起钟落钟
                    NSString *str = @"技师编号：";
                    if (selectedEntity.artificerList.count) {
                        for (int i = 0; i < selectedEntity.artificerList.count; i++) {
                            NSDictionary *dic = [selectedEntity.artificerList objectAtIndex:i];
                            NSString *jishi = [dic objectForKey:@"artificerCd"];
                            if(i == selectedEntity.artificerList.count -1) {
                                // 最后一位，不加逗号
                                if ([[dic objectForKey:@"selectType"] isEqual:@"wheelTime"]){
                                    // 轮钟技师
                                    str = [NSString stringWithFormat:@"%@(%@)", str, jishi];
                                }else {
                                    // 点钟技师
                                    str = [NSString stringWithFormat:@"%@%@", str, jishi];
                                }
                            } else {
                                if ([[dic objectForKey:@"selectType"] isEqual:@"wheelTime"]){
                                    // 轮钟技师
                                    str = [NSString stringWithFormat:@"%@(%@),", str, jishi];
                                }else {
                                    // 点钟技师
                                    str = [NSString stringWithFormat:@"%@%@,", str, jishi];
                                }
                            }
                        }
                    }
                    str = [NSString stringWithFormat:@"%@\n项目时长：%@分钟", str, selectedEntity.projectTime];
                    NSString *cdStr = [NSString stringWithFormat:@"%@", selectedEntity.artificer1Cd];
                    if (selectedEntity.artificer2Cd.length) {
                        cdStr = [NSString stringWithFormat:@"%@、", selectedEntity.artificer2Cd];
                    }
                    DISMISS
                    
    //                UIAlertController *alterController = [[UIAlertController alloc] init];
    //
    //                [alterController setTitle:@"技师状态"];
    //                [alterController setMessage:@"aaa\n bbb/n"];
                    
                    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"技师状态" message:str preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"起钟" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self startEndTime:@"start"];
                        
                    }];
                    [alterController addAction:startAction];
                    
                    UIAlertAction *endAction = [UIAlertAction actionWithTitle:@"落钟" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self startEndTime:@"end"];
                    }];
                    [alterController addAction:endAction];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alterController addAction:cancelAction];
                    UIViewController *viewController = nil;
                    for(UIView* next = [self superview]; next; next = next.superview) {

                        UIResponder*nextResponder = [next nextResponder];

                        if ([nextResponder isKindOfClass:[UIViewController class]]) {

                            viewController = (UIViewController *)nextResponder;

                        }
                    }
                    if (viewController) {
                        [viewController presentViewController:alterController animated:YES completion:^{
                            
                        }];
                    }
                    
                    
                    
    //                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"技师状态" message:[NSString stringWithFormat:@"技师编号:%@\n项目时长:%@分钟", cdStr, selectedEntity.projectTime] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:str, nil];
    //                av.tag = 2002;
    //                [av show];
                } else {
    //                查看等待信息和技师信息
                    DISMISS
                    LJProjectListViewController *next = [[LJProjectListViewController alloc] init];
                    next.entity = selectedEntity;
                    
                    [self.superVC.navigationController pushViewController:next animated:YES];
                }
            } else if (indexPath.row == 5) {
                //        沙发、落钟沙发不可以选择
                if ([selectedEntity.serveStatus isEqualToString:@"downtime"]) {
                    DISMISS
                    return;
                }
                
    //            有项目正在上钟或者暂停 但不是该条项目
                for (LJReceptionDetailModel *entity in self.dataList) {
                    if (([entity.serveStatus isEqualToString:@"uptime"] || [entity.serveStatus isEqualToString:@"suspend"]) && entity != selectedEntity && [entity.customerCd isEqualToString:selectedEntity.customerCd]) {
                        DISMISS
                        return;
                    }
                }
                
                
                //             商品不能选择
                if (selectedEntity.qtyUpdateFlg) {
                    DISMISS
                    return;
                }
                
                LJSofaListViewController *sofaListViewController = [[LJSofaListViewController alloc] init];
                sofaListViewController.roomCd = selectedEntity.roomCd;
                sofaListViewController.selectedEntity = [[SofaModel alloc] init];
                sofaListViewController.selectedEntity.roomCd = selectedEntity.roomCd;
                sofaListViewController.selectedEntity.sofaNo = selectedEntity.sofaNo;
                sofaListViewController.isConsumption = self.isConsumption;
                sofaListViewController.delegate = self;
        
                [superVC.navigationController pushViewController:sofaListViewController animated:YES];
            } else if (indexPath.row == 3) {
                //        修改项目
                if ([selectedEntity.serveStatus isEqualToString:@"downtime"] || [selectedEntity.serveStatus isEqualToString:@"uptime"]) {
                    DISMISS
                    SHOWTEXTINWINDOW(@"上钟、落钟明细不能修改项目", 1);
                    return;
                }
                if (([selectedEntity.settlementStatus isEqualToString:@"appointment"] || [selectedEntity.settlementStatus isEqualToString:@"settleing"]) && selectedEntity.boxCd.length ==0) {
                    // 除扫盒项目外，预结和结算中的项目不允许修改
                    DISMISS
                    SHOWTEXTINWINDOW(@"项目处于预结或结算中状态", 1);
                    return;
                }
                //             商品不能选择项目
                LJSelectedProjectViewController *next = [[LJSelectedProjectViewController alloc] init];
                
                next.detailEntity = selectedEntity;
                if (selectedEntity.artificer1Cd.length) {
                    next.artificerCd = selectedEntity.artificer1Cd;
                } else if (selectedEntity.artificer2Cd.length) {
                    next.artificerCd = selectedEntity.artificer2Cd;
                }
                next.isConsumption = self.isConsumption;
                next.delegate = self;
                next.navColor = NavBackColor;
                if (selectedEntity.projectName.length) {
                    next.titleString = @"修改消费项目";
                } else {
                    next.titleString = @"选择消费项目";
                }
                
                next.view.backgroundColor = WhiteColor;
                
                [superVC.navigationController pushViewController:next animated:YES];
            } else if (indexPath.row == 4) {
                DISMISS
    //            选择技师
                
    //            for (LJReceptionDetailModel *entity in self.dataList) {
    //                NSLog(@"%@,%@", entity.detailNo, selectedEntity.detailNo);
    //                if ([entity.customerCd isEqualToString:selectedEntity.customerCd] && ![entity.detailNo isEqualToString:selectedEntity.detailNo] && [entity.serviceHeadcount integerValue] > 1 && ![entity.serveStatus isEqualToString:@"downtime"] && (entity.artificer1Cd.length || entity.artificer2Cd.length)&& [selectedEntity.serviceHeadcount integerValue] > 1) {
    //
    //                    SHOWTEXTINWINDOW(@"存在其他排班的双技师项目，不允许选择其他双技师项目技师。", 2);
    //                    return;
    //                }
    //            }
                
                
                SHOWSTATUSCLEAR
                [[NetWorkingModel sharedInstance] GET:testSelectJishi parameters:@{@"userId":[userDefaults objectForKey:USERID]} success:^(AFHTTPRequestOperation *operation, id obj) {
                    DISMISS
                    if (ISSUCCESS) {
                        if ([CONTENTOBJ boolValue]) {
                
                            if ([selectedEntity.serviceHeadcount longLongValue] > 1) {
    //                            [[NetWorkingModel sharedInstance] GET:testDoubleArt parameters:@{@"orderCd":selectedEntity.orderCd, @"customerCd":selectedEntity.customerCd, @"detailNo":selectedEntity.detailNo, @"serviceHeadcount":selectedEntity.serviceHeadcount, @"fag":@"consume"} success:^(AFHTTPRequestOperation *operation, id obj) {
    //
    //                                if (ISSUCCESS) {
    //                                    //        技师
    //                                    // 技师下钟 不可选  技师上钟的不能选
    //                                    if ([selectedEntity.serveStatus isEqualToString:@"downtime"] || [selectedEntity.serveStatus isEqualToString:@"uptime"]) {
    //                                        SHOWTEXTINWINDOW(@"上钟或下钟明细不能修改技师", 1);
    //                                        return;
    //                                    }
    //
    //                                    if (!selectedEntity.projectName.length) {
    //                                        SHOWTEXTINWINDOW(@"项目不能为空", 1);
    //                                        return;
    //                                    }
    //                                    //             商品不能选择技师
    //                                    if (selectedEntity.qtyUpdateFlg) {
    //                                        return;
    //                                    }
    //
    //                                    LJReceptionDetailModel *model = nil;
    //                                    //            当前客户选择技师的时候判断  当前用户是否存在上钟的技师
    //                                    for (LJReceptionDetailModel *entity in self.dataList) {
    //                                        if ([entity.customerCd isEqualToString:selectedEntity.customerCd] && (entity.artificer1Cd.length || entity.artificer2Cd.length) && ([entity.serveStatus isEqualToString:@"uptime"] || [entity.serveStatus isEqualToString:@"suspend"]) && ![entity.detailNo isEqualToString:selectedEntity.detailNo]) {
    //                                            // 点钟  技师cd 非落钟项目有技师 并且该记录不是点击的这一条的记录  选择技师时  就只能选择该技师
    //                                            model = entity;
    //                                        }
    //                                    }
    //
    //
    //                                    LJSelectTechnicianViewController *next = [[LJSelectTechnicianViewController alloc] init];
    //                                    next.artRecModel = model;
    //
    //                                    next.canLunFlag = YES;
    //                                    if (![selectedEntity.serveStatus isEqualToString:@"suspend"]) {
    //                                        for (LJReceptionDetailModel *entity in self.dataList) {
    //                                            if ([entity.customerCd isEqualToString:selectedEntity.customerCd] && ([entity.serveStatus isEqualToString:@"overdue"] || [entity.serveStatus isEqualToString:@"suspend"] || [entity.serveStatus isEqualToString:@"uptime"] || [entity.serveStatus isEqualToString:@"wait"]) && ![entity.detailNo isEqualToString:selectedEntity.detailNo]) {
    //                                                next.canLunFlag = NO;
    //                                                break;
    //                                            }
    //                                        }
    //                                    }
    //
    //                                    next.canSelectNotFree = YES;
    //                                    for (LJReceptionDetailModel *entity in self.dataList) {
    //                                        if ([entity.customerCd isEqualToString:selectedEntity.customerCd] && ![entity.serveStatus isEqualToString:@"downtime"] && [entity.serviceHeadcount integerValue] > 1 && ![entity.detailNo isEqualToString:selectedEntity.detailNo]) {
    //                                            next.canSelectNotFree = NO;
    //                                            next.doubleEntity = entity;
    //                                            break;
    //                                        }
    //                                    }
    //                                    next.detailEntity = selectedEntity;
    //                                    next.projectCd = selectedEntity.projectCd;
    //                                    next.artificer1Cd = selectedEntity.artificer1Cd;
    //                                    next.artificer1SelectType = selectedEntity.artificer1SelectType;
    //
    //                                    next.artificer2Cd = selectedEntity.artificer2Cd;
    //                                    next.artificer2SelectType = selectedEntity.artificer2SelectType;
    //
    //                                    next.artificer3Cd = selectedEntity.artificer3Cd;
    //                                    next.artificer3SelectType = selectedEntity.artificer3SelectType;
    //
    //                                    next.artificer4Cd = selectedEntity.artificer4Cd;
    //                                    next.artificer4SelectType = selectedEntity.artificer4SelectType;
    //
    //                                    next.technicianCount = [selectedEntity.serviceHeadcount integerValue];
    //                                    next.isConsumption = self.isConsumption;
    //                                    next.delegate = self;
    //                                    next.navColor = NavBackColor;
    //                                    if (selectedEntity.artificer1Cd.length > 0) {
    //                                        next.titleString = @"更换技师";
    //                                    } else {
    //                                        next.titleString = @"选择技师";
    //                                    }
    //
    //                                    next.view.backgroundColor = WhiteColor;
    //
    //                                    [superVC.navigationController pushViewController:next animated:YES];
    //                                } else {
    //                                    SHOWTEXTINWINDOW(@"不能选择多人项目技师", 1);
    //                                }
    //
    //                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //                            }];
    //
    //                            return ;
                            }
                            
                            
                            
                            //        技师
                            // 技师下钟 不可选  技师上钟的不能选
                            if ([selectedEntity.serveStatus isEqualToString:@"downtime"] || [selectedEntity.serveStatus isEqualToString:@"uptime"]) {
                                SHOWTEXTINWINDOW(@"上钟或下钟明细不能修改技师", 1);
                                return;
                            }
                            
                            if (!selectedEntity.projectName.length) {
                                SHOWTEXTINWINDOW(@"项目不能为空", 1);
                                return;
                            }
                            //             商品不能选择技师
                            if (selectedEntity.qtyUpdateFlg) {
                                DISMISS
                                return;
                            }
                            
                            LJReceptionDetailModel *model = nil;
                            //            当前客户选择技师的时候判断  当前用户是否存在上钟的技师
                            for (LJReceptionDetailModel *entity in self.dataList) {
                                if ([entity.customerCd isEqualToString:selectedEntity.customerCd] && (entity.artificer1Cd.length || entity.artificer2Cd.length) && ([entity.serveStatus isEqualToString:@"uptime"] || [entity.serveStatus isEqualToString:@"suspend"]) && ![entity.detailNo isEqualToString:selectedEntity.detailNo]) {
                                    // 点钟  技师cd 非落钟项目有技师 并且该记录不是点击的这一条的记录  选择技师时  就只能选择该技师
                                    model = entity;
                                }
                            }
                            
                            
                            LJSelectTechnicianViewController *next = [[LJSelectTechnicianViewController alloc] init];
                            next.artRecModel = model;
                            
                            next.canLunFlag = YES;
                            if (![selectedEntity.serveStatus isEqualToString:@"suspend"]) {
                                for (LJReceptionDetailModel *entity in self.dataList) {
                                    if ([entity.customerCd isEqualToString:selectedEntity.customerCd] && ([entity.serveStatus isEqualToString:@"overdue"] || [entity.serveStatus isEqualToString:@"suspend"] || [entity.serveStatus isEqualToString:@"uptime"] || [entity.serveStatus isEqualToString:@"wait"]) && ![entity.detailNo isEqualToString:selectedEntity.detailNo]) {
                                        next.canLunFlag = NO;
                                        break;
                                    }
                                }
                            }
                            
                            next.canSelectNotFree = YES;
                            for (LJReceptionDetailModel *entity in self.dataList) {
                                if ([entity.customerCd isEqualToString:selectedEntity.customerCd] && ![entity.serveStatus isEqualToString:@"downtime"] && [entity.serviceHeadcount integerValue] > 1 && ![entity.detailNo isEqualToString:selectedEntity.detailNo]) {
                                    next.canSelectNotFree = NO;
                                    next.doubleEntity = entity;
                                    break;
                                }
                            }
                            next.detailEntity = selectedEntity;
                            next.projectCd = selectedEntity.projectCd;
                            next.artificer1Cd = selectedEntity.artificer1Cd;
                            next.artificer1SelectType = selectedEntity.artificer1SelectType;
                            
                            next.artificer2Cd = selectedEntity.artificer2Cd;
                            next.artificer2SelectType = selectedEntity.artificer2SelectType;
                            
                            next.artificer3Cd = selectedEntity.artificer3Cd;
                            next.artificer3SelectType = selectedEntity.artificer3SelectType;
                            
                            next.artificer4Cd = selectedEntity.artificer4Cd;
                            next.artificer4SelectType = selectedEntity.artificer4SelectType;
                            
                            next.technicianCount = [selectedEntity.serviceHeadcount integerValue];
                            next.isConsumption = self.isConsumption;
                            next.delegate = self;
                            next.navColor = NavBackColor;
                            if (selectedEntity.artificer1Cd.length>0) {
                                next.titleString = @"更换技师";
                            } else {
                                next.titleString = @"选择技师";
                            }
                            
                            next.view.backgroundColor = WhiteColor;
                            
                            [superVC.navigationController pushViewController:next animated:YES];
                        } else {
                            SHOWTEXTINWINDOW(@"没有权限", 1);
                        }
                    } else {
                        BADREQUEST
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                
                
            } else if (indexPath.row == 6) {
                DISMISS
                return;
                //        房间
                if ([selectedEntity.serveStatus isEqualToString:@"downtime"]) {
                    DISMISS
                    return;
                }
                //             商品不能选择
                if (selectedEntity.qtyUpdateFlg) {
                    DISMISS
                    return;
                }
                
                
                LJSelectRoomViewController *next = [[LJSelectRoomViewController alloc] init];
                next.delegate = self;
                next.isConsumption = self.isConsumption;
                next.navColor = NavBackColor;
                next.titleString = @"选择房间";
                next.view.backgroundColor = WhiteColor;
                
                [superVC.navigationController pushViewController:next animated:YES];
            } else if (indexPath.row == 7) {
                //        需要判断是否可以更改数量
                if (selectedEntity.qtyUpdateFlg) {
                    cell.titleLabel.hidden = YES;
                    UITextField *numberTf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
                    [cell addSubview:numberTf];
                    numberTf.tag = 1111;
                    numberTf.delegate = self;
                    numberTf.textAlignment = NSTextAlignmentCenter;
                    numberTf.keyboardType = UIKeyboardTypeNumberPad;
                    
                    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [doneButton setBackgroundColor:[UIColor grayColor]];
                    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
                    [doneButton addTarget:self action:@selector(closeKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
                    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, 40)];
                    [inputView setBackgroundColor:[UIColor grayColor]];
                    [inputView addSubview:doneButton];
                    
                    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(inputView);
                        make.right.equalTo(inputView).with.offset(-kappScreenWidth*(34/744));
                        make.size.mas_equalTo(CGSizeMake(40, 30));
                    }];
                    
                    
                    numberTf.inputAccessoryView = inputView;
                    
                    
                    [numberTf becomeFirstResponder];
                }
                
            } else if (indexPath.row == 12) {
                // 选择推销员
                DISMISS
                return;
                if (nameArr.count) {
                    if ([self.delegate respondsToSelector:@selector(showPickViewWithData:)]) {
                        [self.delegate showPickViewWithData:nameArr];
                        
                    }
                    
                }
            }  else if (indexPath.row == 2) {
                
                if (!cell.titleLabel.isHidden) {
                    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
                    [as showInView:self.superview];
                }
                
                
            }
        }
        
        
    } else {
        //接待单
        if (indexPath.row == 3) {
            //        修改项目
            
            LJSelectedProjectViewController *next = [[LJSelectedProjectViewController alloc] init];
            next.detailEntity = selectedEntity;
            if (selectedEntity.artificer1Cd.length) {
                next.artificerCd = selectedEntity.artificer1Cd;
            } else if (selectedEntity.artificer2Cd.length) {
                next.artificerCd = selectedEntity.artificer2Cd;
            }
            next.isConsumption = self.isConsumption;
            next.delegate = self;
            next.navColor = NavBackColor;
            if (selectedEntity.projectName.length) {
                next.titleString = @"修改消费项目";
            } else {
                next.titleString = @"选择消费项目";
            }
            next.view.backgroundColor = WhiteColor;
            
            [superVC.navigationController pushViewController:next animated:YES];
        }  else if (indexPath.row == 2) {
            
            if (!cell.titleLabel.isHidden) {
                UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
                [as showInView:self.superview];
            }
            
            
        }  else if (indexPath.row == 4) {
            //          //        技师
//            for (LJReceptionDetailModel *entity in self.dataList) {
//                if ([entity.customerCd isEqualToString:selectedEntity.customerCd] && ![entity.detailNo isEqualToString:selectedEntity.detailNo] && [entity.serviceHeadcount integerValue] > 1 && ![entity.serveStatus isEqualToString:@"downtime"] && (entity.artificer1Cd.length || entity.artificer2Cd.length)&& [selectedEntity.serviceHeadcount integerValue] > 1) {
//                    
//                    SHOWTEXTINWINDOW(@"存在其他排班的双技师项目，不允许选择其他双技师项目技师。", 2);
//                    return;
//                }
//            }
            //             商品不能选择技师
            if (selectedEntity.qtyUpdateFlg) {
                DISMISS
                return;
            }
            if (!selectedEntity.projectName.length) {
                SHOWTEXTINWINDOW(@"项目不能为空", 1);
                return;
            }
            
            SHOWSTATUSCLEAR
            [[NetWorkingModel sharedInstance] GET:testSelectJishi parameters:@{@"userId":[userDefaults objectForKey:USERID]} success:^(AFHTTPRequestOperation *operation, id obj) {
                DISMISS
                
                if (ISSUCCESS) {
                    if ([CONTENTOBJ boolValue]) {
                        if ([selectedEntity.serviceHeadcount longLongValue] > 1) {
                            [[NetWorkingModel sharedInstance] GET:testDoubleArt parameters:@{@"orderCd":selectedEntity.orderCd, @"customerCd":selectedEntity.customerCd, @"detailNo":selectedEntity.detailNo, @"serviceHeadcount":selectedEntity.serviceHeadcount, @"fag":@"reception"} success:^(AFHTTPRequestOperation *operation, id obj) {
                       
                                if (ISSUCCESS) {
                                    LJReceptionDetailModel *model = nil;
                                    //            当前客户选择技师的时候判断  当前用户是否有未下钟的点钟技师
                                    for (LJReceptionDetailModel *entity in self.dataList) {
                                        if ([entity.customerCd isEqualToString:selectedEntity.customerCd] && (entity.artificer1Cd.length || entity.artificer2Cd.length)) {
                                            // 点钟  技师cd 非落钟项目有技师 并且该记录不是点击的这一条的记录  选择技师时  就只能选择该技师
                                            if (entity.artificer1Cd.length && [entity.artificer1SelectType isEqualToString:@"callTime"] && ![entity.serveStatus isEqualToString:@"downtime"]) {
                                                model = entity;
                                            } else if (entity.artificer2Cd.length && [entity.artificer2SelectType isEqualToString:@"callTime"] && ![entity.serveStatus isEqualToString:@"downtime"]) {
                                                model = entity;
                                            }
                                        }
                                    }
                                    
                                    LJSelectTechnicianViewController *next = [[LJSelectTechnicianViewController alloc] init];
                                    next.artRecModel = model;
                                    
                                    next.detailEntity = selectedEntity;
                                    next.projectCd = selectedEntity.projectCd;
                                    next.artificer1Cd = selectedEntity.artificer1Cd;
                                    next.artificer1SelectType = selectedEntity.artificer1SelectType;
                                    
                                    next.artificer2Cd = selectedEntity.artificer2Cd;
                                    next.artificer2SelectType = selectedEntity.artificer2SelectType;
                                    
                                    next.artificer3Cd = selectedEntity.artificer3Cd;
                                    next.artificer3SelectType = selectedEntity.artificer3SelectType;
                                    
                                    next.artificer4Cd = selectedEntity.artificer4Cd;
                                    next.artificer4SelectType = selectedEntity.artificer4SelectType;
                                    
                                    next.technicianCount = 1;
                                    next.isConsumption = self.isConsumption;
                                    next.delegate = self;
                                    next.navColor = NavBackColor;
                                    if (selectedEntity.artificer1Cd) {
                                        next.titleString = @"更换技师";
                                    } else {
                                        next.titleString = @"选择技师";
                                    }
                                    
                                    next.view.backgroundColor = WhiteColor;
                                    
                                    [superVC.navigationController pushViewController:next animated:YES];
                                } else {
                                    SHOWTEXTINWINDOW(@"不能选择多人项目技师", 1);
                                }
                                
                             
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 
                             }];
                            DISMISS
                            return ;
                        }
                        
                        LJReceptionDetailModel *model = nil;
                        //            当前客户选择技师的时候判断  当前用户是否有未下钟的点钟技师
                        for (LJReceptionDetailModel *entity in self.dataList) {
                            if ([entity.customerCd isEqualToString:selectedEntity.customerCd] && (entity.artificer1Cd.length || entity.artificer2Cd.length)) {
                                // 点钟  技师cd 非落钟项目有技师 并且该记录不是点击的这一条的记录  选择技师时  就只能选择该技师
                                if (entity.artificer1Cd.length && [entity.artificer1SelectType isEqualToString:@"callTime"] && ![entity.serveStatus isEqualToString:@"downtime"]) {
                                    model = entity;
                                } else if (entity.artificer2Cd.length && [entity.artificer2SelectType isEqualToString:@"callTime"] && ![entity.serveStatus isEqualToString:@"downtime"]) {
                                    model = entity;
                                }
                            }
                        }
                        
                        LJSelectTechnicianViewController *next = [[LJSelectTechnicianViewController alloc] init];
                        next.artRecModel = model;
                        
                        next.detailEntity = selectedEntity;
                        next.projectCd = selectedEntity.projectCd;
                        next.artificer1Cd = selectedEntity.artificer1Cd;
                        next.artificer1SelectType = selectedEntity.artificer1SelectType;
                        
                        next.artificer2Cd = selectedEntity.artificer2Cd;
                        next.artificer2SelectType = selectedEntity.artificer2SelectType;
                        
                        next.artificer3Cd = selectedEntity.artificer3Cd;
                        next.artificer3SelectType = selectedEntity.artificer3SelectType;
                        
                        next.artificer4Cd = selectedEntity.artificer4Cd;
                        next.artificer4SelectType = selectedEntity.artificer4SelectType;
                        
                        next.technicianCount = 1;
                        next.isConsumption = self.isConsumption;
                        next.delegate = self;
                        next.navColor = NavBackColor;
                        if (selectedEntity.artificer1Cd) {
                            next.titleString = @"更换技师";
                        } else {
                            next.titleString = @"选择技师";
                        }
                        
                        next.view.backgroundColor = WhiteColor;
                        
                        [superVC.navigationController pushViewController:next animated:YES];
                    } else {
                        SHOWTEXTINWINDOW(@"没有权限", 1)
                    }
                } else {
                    BADREQUEST
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
            
            
        }  else if (indexPath.row == 5) {
            if (selectedEntity.qtyUpdateFlg) {
                cell.titleLabel.hidden = YES;
                UITextField *numberTf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
                [cell addSubview:numberTf];
                numberTf.tag = 1111;
                numberTf.delegate = self;
                numberTf.textAlignment = NSTextAlignmentCenter;
                numberTf.keyboardType = UIKeyboardTypeNumberPad;
                
                UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [doneButton setBackgroundColor:[UIColor grayColor]];
                [doneButton setTitle:@"完成" forState:UIControlStateNormal];
                [doneButton addTarget:self action:@selector(closeKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
                UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kappScreenWidth, 40)];
                [inputView setBackgroundColor:[UIColor grayColor]];
                [inputView addSubview:doneButton];
                
                [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(inputView);
                    make.right.equalTo(inputView).with.offset(-kappScreenWidth*(34/744));
                    make.size.mas_equalTo(CGSizeMake(40, 30));
                }];
                
                
                numberTf.inputAccessoryView = inputView;
                
                
                [numberTf becomeFirstResponder];
            }
            
        } else if (indexPath.row == 8) {
//            选择推销员
            DISMISS
            return;
            if (nameArr.count) {
                if ([self.delegate respondsToSelector:@selector(showPickViewWithData:)]) {
                    [self.delegate showPickViewWithData:nameArr];
                    
                }
                
            }
            
        }
    }
    
    DISMISS
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"点击了 %ld", (long)buttonIndex);
    if (alertView.tag == 2002) {
        switch (buttonIndex) {
            case 0:
//                取消
                
                break;
            case 1:
//                起钟
            {
                NSDictionary *dic = [NSMutableDictionary dictionary];
                if (selectedEntity.orderCd.length) {
                    [dic setValue:selectedEntity.orderCd forKey:@"orderCd"];
                }
                if (selectedEntity.customerCd.length) {
                    [dic setValue:selectedEntity.customerCd forKey:@"customerCd"];
                }
                if (selectedEntity.projectCd.length) {
                    [dic setValue:selectedEntity.projectCd forKey:@"projectCd"];
                }
                if (selectedEntity.detailNo.length) {
                    [dic setValue:selectedEntity.detailNo forKey:@"detailNo"];
                }
                
                if (selectedEntity.artificer2Cd.length) {
                    [dic setValue:selectedEntity.artificer2Cd forKey:@"artificer2Cd"];
                }
                
                if (selectedEntity.artificer1Cd.length) {
                    [dic setValue:selectedEntity.artificer1Cd forKey:@"artificer1Cd"];
                }
                
                [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
                
//                NSDictionary *dic = @{@"orderCd":selectedEntity.orderCd.length ? selectedEntity.orderCd : @"", @"customerCd":selectedEntity.customerCd.length ? selectedEntity.customerCd : @"", @"projectCd":selectedEntity.projectCd.length ? selectedEntity.projectCd : @"", @"detailNo":selectedEntity.detailNo.length ? selectedEntity.detailNo : @"", @"userId":[userDefaults objectForKey:USERID]};
                NSString *url = XIAOFEISTARTTIME;
                if ([selectedEntity.serveStatus isEqualToString:@"uptime"]) {
                    url = XIAOFEIENDTIME;
                }
                SHOWSTATUSCLEAR
                [[NetWorkingModel sharedInstance] POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
                    DISMISS
                    if (ISSUCCESS) {
                        LJConsumptionViewController *vc = (LJConsumptionViewController *)self.superVC;
                        [vc loadData];
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"操作成功";
//                        需要刷新
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                        });
                        
                    } else {
                        if ([OBJMESSAGE isEqualToString:@"sofaNo_is_null"]) {
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                            hud.mode = MBProgressHUDModeText;
                            hud.labelText = @"请先选择沙发";
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                            });
                        } else if ([OBJMESSAGE isEqualToString:@"error_working"]) {
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                            hud.mode = MBProgressHUDModeText;
                            hud.labelText = @"当前技师正在上钟";
                            
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                            });
                        } else if ([OBJMESSAGE isEqualToString:@"error_artificer2Cd"]) {
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                            hud.mode = MBProgressHUDModeText;
                            hud.labelText = @"技师2不能为空";
                            
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                            });
                        } else if ([OBJMESSAGE isEqualToString:@"error_project"]) {
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                            hud.mode = MBProgressHUDModeText;
                            hud.labelText = @"项目不能为空";
                            
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                            });
                        } else if ([OBJMESSAGE isEqualToString:@"error_shangpin"]) {
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                            hud.mode = MBProgressHUDModeText;
                            hud.labelText = @"商品不能起钟";
                            
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                            });
                        } else {
                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                            hud.mode = MBProgressHUDModeText;
                            hud.labelText = @"操作失败";
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                            });
                        }
                        
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
                
                break;
            
            default:
                break;
        }
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 1111) {
        if (textField.text.length) {
            if ([textField.text integerValue] > 0) {
                selectedEntity.projectNum = textField.text;
                [myCollectionView reloadData];
            } else {
                selectedEntity.projectNum = @"1";
                [myCollectionView reloadData];
            }
            
        } else {
            selectedEntity.projectNum = @"1";
            [myCollectionView reloadData];
        }
        
    }
    
    [textField removeFromSuperview];
    
}

- (void) closeKeyBoard:(UIButton *) sender {
    [self endEditing:YES];
}

-(void) startEndTime:(NSString *) status {
    NSDictionary *dic = [NSMutableDictionary dictionary];
    if (selectedEntity.orderCd.length) {
        [dic setValue:selectedEntity.orderCd forKey:@"orderCd"];
    }
    if (selectedEntity.customerCd.length) {
        [dic setValue:selectedEntity.customerCd forKey:@"customerCd"];
    }
    if (selectedEntity.projectCd.length) {
        [dic setValue:selectedEntity.projectCd forKey:@"projectCd"];
    }
    if (selectedEntity.detailNo.length) {
        [dic setValue:selectedEntity.detailNo forKey:@"detailNo"];
    }
    
    [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];

    NSString *url = XIAOFEISTARTTIME;
    if ([status isEqualToString:@"end"]) {
        url = XIAOFEIENDTIME;
    }
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        if (ISSUCCESS) {
            LJConsumptionViewController *vc = (LJConsumptionViewController *)self.superVC;
            [vc loadData];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"操作成功";
//                        需要刷新
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
            });
            
        } else {
            if ([OBJMESSAGE isEqualToString:@"sofaNo_is_null"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"请先选择沙发";
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                });
            } else if ([OBJMESSAGE isEqualToString:@"error_working"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"当前技师正在上钟";
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                });
            } else if ([OBJMESSAGE isEqualToString:@"error_artificer2Cd"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"技师2不能为空";
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                });
            } else if ([OBJMESSAGE isEqualToString:@"error_project"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"项目不能为空";
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                });
            } else if ([OBJMESSAGE isEqualToString:@"error_shangpin"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"商品不能起钟";
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                });
            } else if ([OBJMESSAGE isEqualToString:@"error_artificerCdNotEnough "]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"固定技师项目派遣技师数量不够，不允许起钟";
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                });
            } else if ([OBJMESSAGE isEqualToString:@"error_noUserArtificer "]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"技师用户只能起/落钟自己的项目";
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                });
            } else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"操作失败";
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:self.superview.superview animated:YES];
                });
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma -mark 选择房间

- (void)sendRoom:(LJRoomModel *)room {
    
//    判断全部转单还是拆单
//    
    
    selectedEntity.roomCd = room.roomCd;
    
    [myCollectionView reloadData];
}

#pragma -mark 选择技师
- (void)sendTechnician:(LJSelectTechnicianViewController *)entity {
    
    selectedEntity.artificer1Cd = entity.artificer1Cd;
    selectedEntity.artificer1SelectType = entity.artificer1SelectType;

    selectedEntity.artificer2Cd = entity.artificer2Cd;
    selectedEntity.artificer2SelectType = entity.artificer2SelectType;

    for (LJReceptionDetailModel *model in self.dataList) {
        if (((model.artificer1Cd.length && [model.artificer1SelectType isEqualToString:@"callTime"]) || (model.artificer2Cd.length && [model.artificer2SelectType isEqualToString:@"callTime"])) && ([model.serveStatus isEqualToString:@"wait"] || [model.serveStatus isEqualToString:@"nothing"] || [model.serveStatus isEqualToString:@"overdue"]) && [model.customerCd isEqualToString:entity.detailEntity.customerCd]) {
            model.artificer1Cd = entity.artificer1Cd;
            model.artificer1SelectType = entity.artificer1SelectType;
            
            model.artificer2Cd = entity.artificer2Cd;
            model.artificer2SelectType = entity.artificer2SelectType;
        }
    }
    
    if (self.isConsumption) {
        LJConsumptionViewController *vc = (LJConsumptionViewController *)self.superVC;
        [vc loadData];
    } else {
//        for (LJReceptionDetailModel *model in self.dataList) {
//            if (model.artificer1Cd.length && [model.customerCd isEqualToString:entity.detailEntity.customerCd]) {
//                model.artificer1Cd = entity.artificer1Cd;
//                model.artificer1SelectType = entity.artificer1SelectType;
//                
//                model.artificer2Cd = entity.artificer2Cd;
//                model.artificer2SelectType = entity.artificer2SelectType;
//            }
//        }
//        [myCollectionView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(loadData)]) {
            [self.delegate loadData];
        }
    }
    
}

#pragma -mark 选择项目
- (void)sendProject:(LJProjectModel *)dic {
    
    if (self.isConsumption || !self.isConsumption) {
        NSMutableDictionary *saveDic = [NSMutableDictionary dictionary];
        if (selectedEntity.orderCd.length) {
            [saveDic setValue:selectedEntity.orderCd forKey:@"orderCd"];
        }
        if (selectedEntity.customerCd.length) {
            [saveDic setValue:selectedEntity.customerCd forKey:@"customerCd"];
        }
        if (dic.projectCd.length) {
            [saveDic setValue:dic.projectCd forKey:@"projectCd"];
        }
        if (selectedEntity.detailNo.length) {
            [saveDic setValue:selectedEntity.detailNo forKey:@"detailNo"];
        }
        if ([[userDefaults objectForKey:USERID] length]) {
            [saveDic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
        }
        NSLog(@"dic = %@", saveDic);
        
        NSString *url = JIEDAISAVEPROJECT;
        
        if (self.isConsumption) {
            url = XIAOFEISAVEPROJECT;
        }
        
        [[NetWorkingModel sharedInstance] POST:url parameters:saveDic success:^(AFHTTPRequestOperation *operation, id obj) {
            if (ISSUCCESS) {
                if (dic) {
                    
                    if (dic.qtyUpdateFlg) {
                        if ([selectedEntity.projectCd isEqualToString:dic.projectCd]) {
                            
                        } else {
                            selectedEntity.projectName = dic.projectName;
                            selectedEntity.projectCd = dic.projectCd;
                            selectedEntity.qtyUpdateFlg = dic.qtyUpdateFlg;
                            selectedEntity.serviceHeadcount = dic.serviceHeadcount;
                            selectedEntity.consumeAmt = dic.price;
                            selectedEntity.price = dic.price;
                            selectedEntity.serviceHeadcount = dic.serviceHeadcount;
                            selectedEntity.qtyUpdateFlg = dic.qtyUpdateFlg;
                            selectedEntity.projectNum = @"1";
                            [myCollectionView reloadData];
                            if ([self.delegate respondsToSelector:@selector(loadData)]) {
                                [self.delegate loadData];
                            }
                        }
                    } else {
                        selectedEntity.projectName = dic.projectName;
                        selectedEntity.projectCd = dic.projectCd;
                        selectedEntity.qtyUpdateFlg = dic.qtyUpdateFlg;
                        selectedEntity.serviceHeadcount = dic.serviceHeadcount;
                        selectedEntity.consumeAmt = dic.price;
                        selectedEntity.price = dic.price;
                        selectedEntity.serviceHeadcount = dic.serviceHeadcount;
                        selectedEntity.qtyUpdateFlg = dic.qtyUpdateFlg;
                        selectedEntity.projectNum = @"1";
                        
                        [myCollectionView reloadData];
                        if ([self.delegate respondsToSelector:@selector(loadData)]) {
                            [self.delegate loadData];
                        }

                    }
                }
                
                for (LJReceptionDetailModel *entity in self.dataList) {
                    if (entity.projectName.length == 0) {
                        entity.projectName = dic.projectName;
                        entity.projectCd = dic.projectCd;
                        entity.consumeAmt = dic.price;
                        entity.price = dic.price;
                        entity.qtyUpdateFlg = dic.qtyUpdateFlg;
                        entity.serviceHeadcount = dic.serviceHeadcount;
                        if ([entity.projectNum integerValue] < 1) {
                            entity.projectNum = @"1";
                        }
                    }
                }
                [myCollectionView reloadData];
                if ([self.delegate respondsToSelector:@selector(loadData)]) {
                    [self.delegate loadData];
                }

            } else {
                if ([OBJMESSAGE isEqualToString:@"error_projectTime"]) {
                    [MBProgressHUD hideHUDForView:self.superVC.view animated:YES];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superVC.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"您要更换的项目时长大于原项目";
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [MBProgressHUD hideHUDForView:self.superVC.view animated:YES];
                    });
                    return ;
                }
                [MBProgressHUD hideHUDForView:self.superVC.view animated:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superVC.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"项目保存失败";
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:self.superVC.view animated:YES];
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } else {
        if (dic) {
            
            if (dic.qtyUpdateFlg) {
                if ([selectedEntity.projectCd isEqualToString:dic.projectCd]) {
                    
                } else {
                    selectedEntity.projectName = dic.projectName;
                    selectedEntity.projectCd = dic.projectCd;
                    selectedEntity.qtyUpdateFlg = dic.qtyUpdateFlg;
                    selectedEntity.serviceHeadcount = dic.serviceHeadcount;
                    selectedEntity.consumeAmt = dic.price;
                    selectedEntity.price = dic.price;
                    selectedEntity.projectNum = @"1";
                    selectedEntity.qtyUpdateFlg = dic.qtyUpdateFlg;
                    selectedEntity.serviceHeadcount = dic.serviceHeadcount;
                    [myCollectionView reloadData];
                    if ([self.delegate respondsToSelector:@selector(loadData)]) {
                        [self.delegate loadData];
                    }

                }
            } else {
                selectedEntity.projectName = dic.projectName;
                selectedEntity.projectCd = dic.projectCd;
                selectedEntity.qtyUpdateFlg = dic.qtyUpdateFlg;
                selectedEntity.serviceHeadcount = dic.serviceHeadcount;
                selectedEntity.consumeAmt = dic.price;
                selectedEntity.serviceHeadcount = dic.serviceHeadcount;
                selectedEntity.price = dic.price;
                selectedEntity.qtyUpdateFlg = dic.qtyUpdateFlg;
                selectedEntity.projectNum = @"1";
                
                for (LJReceptionDetailModel *entity in self.dataList) {
                    if (entity.projectName.length == 0) {
                        entity.projectName = dic.projectName;
                        entity.projectCd = dic.projectCd;
                        entity.consumeAmt = dic.price;
                        entity.price = dic.price;
                        entity.serviceHeadcount = dic.serviceHeadcount;
                        entity.qtyUpdateFlg = dic.qtyUpdateFlg;
                        if ([entity.projectNum integerValue] < 1) {
                            entity.projectNum = @"1";
                        }
                    }
                }
                
                [myCollectionView reloadData];
                if ([self.delegate respondsToSelector:@selector(loadData)]) {
                    [self.delegate loadData];
                }

            }
            for (LJReceptionDetailModel *entity in self.dataList) {
                if (entity.projectName.length == 0) {
                    entity.projectName = dic.projectName;
                    entity.projectCd = dic.projectCd;
                    entity.consumeAmt = dic.price;
                    entity.price = dic.price;
                    entity.serviceHeadcount = dic.serviceHeadcount;
                    entity.qtyUpdateFlg = dic.qtyUpdateFlg;
                    if ([entity.projectNum integerValue] < 1) {
                        entity.projectNum = @"1";
                    }
                }
            }
            [myCollectionView reloadData];
            if ([self.delegate respondsToSelector:@selector(loadData)]) {
                [self.delegate loadData];
            }

        }
    }
    
    
    
    
}

#pragma -mark 选择沙发
- (void)sendSofa:(SofaModel *)entity {
    
    if ([entity.sofaNo isEqualToString:selectedEntity.sofaNo]) {
        return;
    }
    
    NSDictionary *dic = [NSMutableDictionary dictionary];
    if (selectedEntity.orderCd.length) {
        [dic setValue:selectedEntity.orderCd forKey:@"orderCd"];
    }
    if (selectedEntity.customerCd.length) {
        [dic setValue:selectedEntity.customerCd forKey:@"customerCd"];
    }
    if (selectedEntity.projectCd.length) {
        [dic setValue:selectedEntity.projectCd forKey:@"projectCd"];
    }
    if (selectedEntity.detailNo.length) {
        [dic setValue:selectedEntity.detailNo forKey:@"detailNo"];
    }
    if (entity.roomCd.length) {
        [dic setValue:entity.roomCd forKey:@"roomCd"];
    }
    if (entity.sofaNo.length) {
        [dic setValue:entity.sofaNo forKey:@"sofaNo"];
    }
    
    if (selectedEntity.sofaNo.length && ![selectedEntity.sofaNo isEqualToString:entity.sofaNo]) {
        [dic setValue:selectedEntity.sofaNo forKey:@"sofaNo1"];
    }
    
    [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];

    NSLog(@"dic = %@", dic);
    SHOWSTATUSCLEAR
    [[NetWorkingModel sharedInstance] POST:XIAOFEIPOSTSOFA parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
        DISMISS
        if (ISSUCCESS) {
            selectedEntity.sofaNo = entity.sofaNo;
            for (LJReceptionDetailModel *model in self.dataList) {
                if (([model.serveStatus isEqualToString:@"nothing"] || [model.serveStatus isEqualToString:@"wait"] || [model.serveStatus isEqualToString:@"overdue"]) && [model.customerCd isEqualToString:selectedEntity.customerCd]) {
                    model.sofaNo = entity.sofaNo;
                }
            }
            
            
            [myCollectionView reloadData];
        } else {
            if ([OBJMESSAGE isEqualToString:@"error_Onclock"]) {
                SHOWTEXTINWINDOW(@"当前明细不能修改沙发", 1);
            } else if ([OBJMESSAGE isEqualToString:@"error_sofaFree"]) {
                SHOWTEXTINWINDOW(@"当前空闲沙发数量不足", 1);
            } else {
                SHOWTEXTINWINDOW(@"操作失败", 1);
            }

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    BOOL flag = YES;
    switch (buttonIndex) {
        case 0:
//            男
            selectedEntity.sex = @"man";
            NSLog(@"%ld", (long)buttonIndex);
            flag = NO;
            break;
        case 1:
//            女
            selectedEntity.sex = @"woman";
            flag = NO;
            NSLog(@"%ld", (long)buttonIndex);
            break;
        default:
            break;
    }
    
    if (flag) {
        return;
    }
    
    if (self.isConsumption) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (selectedEntity.orderCd.length) {
            [dic setValue:selectedEntity.orderCd forKey:@"orderCd"];
        }
        if (selectedEntity.customerCd.length) {
            [dic setValue:selectedEntity.customerCd forKey:@"customerCd"];
        }
        
        if (selectedEntity.sex.length) {
            [dic setValue:selectedEntity.sex forKey:@"sex"];
        }
        if ([[userDefaults objectForKey:USERID] length]) {
            [dic setValue:[userDefaults objectForKey:USERID] forKey:@"userId"];
        }
        
        SHOWSTATUSCLEAR
        [[NetWorkingModel sharedInstance] POST:UPDATESEX parameters:dic success:^(AFHTTPRequestOperation *operation, id obj) {
            DISMISS
            if (ISSUCCESS) {
                for (LJReceptionDetailModel *entity in self.dataList) {
                    if ([selectedEntity.customerCd isEqualToString:entity.customerCd]) {
                        entity.sex = selectedEntity.sex;
                    }
                }
                [myCollectionView reloadData];
            } else {
                if ([OBJMESSAGE isEqualToString:@"error_downTime"]) {
                    SHOWTEXTINWINDOW(@"项目落钟不能修改性别", 1);
                } else {
                    BADREQUEST
                }
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } else {
        for (LJReceptionDetailModel *entity in self.dataList) {
            if ([selectedEntity.customerCd isEqualToString:entity.customerCd]) {
                entity.sex = selectedEntity.sex;
            }
        }
        [myCollectionView reloadData];
    }
    
    
    
    
}

- (void)selectedAll:(UIButton *)sender {
    
    if (sender.isSelected) {
        for (LJReceptionDetailModel *entity in self.dataList) {
            entity.isSelected = NO;
        }
    } else {
//        全选
        for (LJReceptionDetailModel *entity in self.dataList) {
            entity.isSelected = YES;
        }
    }
    
    [sender setSelected:!sender.isSelected];
    [myCollectionView reloadData];
}

- (void)setDataList:(NSMutableArray *)dataList {
    _dataList = dataList;
    [myCollectionView reloadData];
}

@end
