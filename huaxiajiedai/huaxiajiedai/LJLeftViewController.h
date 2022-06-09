//
//  LJLeftViewController.h
//  huaxiajiedai
//
//  Created by qm on 16/5/25.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJLeftViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CustomTopNavigationView *topView;
@property (nonatomic, strong) UITableView *myTableView;

@end
